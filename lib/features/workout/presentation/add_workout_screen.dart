import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lift_log/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/workout_model.dart';
import '../../../data/models/exercise_model.dart';
import '../../../data/models/set_entry_model.dart';
import '../cubit/workout_cubit.dart';

class AddWorkoutScreen extends StatefulWidget {
  final WorkoutModel? workoutToEdit;
  const AddWorkoutScreen({super.key, this.workoutToEdit});

  @override
  State<AddWorkoutScreen> createState() => _AddWorkoutScreenState();
}

class _AddWorkoutScreenState extends State<AddWorkoutScreen> {
  late TextEditingController _titleController;
  late List<ExerciseModel> _exercises;

  @override
  void initState() {
    super.initState();
    
    // توليد اسم افتراضي بناءً على وقت اليوم
    String defaultTitle = _generateDefaultTitle();
    
    _titleController = TextEditingController(
      text: widget.workoutToEdit?.title ?? defaultTitle,
    )..addListener(_autoSave);
    
    _exercises = widget.workoutToEdit != null
        ? List<ExerciseModel>.from(widget.workoutToEdit!.exercises)
        : [];
  }

  String _generateDefaultTitle() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning Session';
    if (hour < 17) return 'Afternoon Session';
    return 'Evening Session';
  }

  void _addExercise() {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _exercises.add(ExerciseModel(
        id: const Uuid().v4(),
        name: l10n.newExercise,
        category: 'Others',
        sets: [SetEntryModel(weight: 0, reps: 0)],
      ));
    });
    _autoSave();
  }

  void _addSet(int exerciseIndex) {
    setState(() {
      final sets = List<SetEntryModel>.from(_exercises[exerciseIndex].sets);
      sets.add(SetEntryModel(weight: 0, reps: 0));
      _exercises[exerciseIndex] = ExerciseModel(
        id: _exercises[exerciseIndex].id,
        name: _exercises[exerciseIndex].name,
        category: _exercises[exerciseIndex].category,
        sets: sets,
      );
    });
    _autoSave();
  }

  void _autoSave() {
    final workout = WorkoutModel(
      id: widget.workoutToEdit?.id ?? 'active_workout',
      title: _titleController.text,
      date: widget.workoutToEdit?.date ?? DateTime.now(),
      exercises: _exercises,
    );
    context.read<WorkoutCubit>().saveActiveWorkout(workout);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.appName.toUpperCase(),
          style: AppTextStyles.headlineMd.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        l10n.activeSession,
                        style: AppTextStyles.labelLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  TextField(
                    controller: _titleController,
                    style: AppTextStyles.headlineLg.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Text(
                    l10n.startedAt(DateFormat('HH:mm').format(widget.workoutToEdit?.date ?? DateTime.now())),
                    style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 25.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _exercises.length,
                    itemBuilder: (context, index) {
                      return _buildExerciseCard(index);
                    },
                  ),
                  SizedBox(height: 10.h),
                  OutlinedButton.icon(
                    onPressed: _addExercise,
                    icon: const Icon(Icons.add),
                    label: Text(l10n.addExercise),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    ),
                  ),
                  SizedBox(height: 100.h), // مساحة للزرار اللي تحت
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ElevatedButton.icon(
          onPressed: () {
            final workout = WorkoutModel(
              id: widget.workoutToEdit?.id ?? const Uuid().v4(),
              title: _titleController.text,
              date: widget.workoutToEdit?.date ?? DateTime.now(),
              exercises: _exercises,
            );
            if (widget.workoutToEdit != null) {
              context.read<WorkoutCubit>().updateWorkout(workout);
            } else {
              context.read<WorkoutCubit>().addWorkout(workout);
              context.read<WorkoutCubit>().clearActiveWorkout();
            }
            Navigator.pop(context);
          },
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          label: Text(
            l10n.finishWorkout,
            style: AppTextStyles.bodyLg.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            minimumSize: Size(double.infinity, 60.h),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(int exIndex) {
    final theme = Theme.of(context);
    final exercise = _exercises[exIndex];
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 200.w,
                    child: TextField(
                      onChanged: (val) {
                        _exercises[exIndex] = ExerciseModel(
                          id: exercise.id,
                          name: val,
                          category: exercise.category,
                          sets: exercise.sets,
                        );
                        _autoSave();
                      },
                      controller: TextEditingController(text: exercise.name)..selection = TextSelection.collapsed(offset: exercise.name.length),
                      style: AppTextStyles.headlineMd.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  Text(
                    'Barbell · Chest',
                    style: AppTextStyles.bodyMd.copyWith(color: Colors.grey),
                  ),
                ],
              ),
              Icon(Icons.more_vert, color: Colors.grey, size: 20.sp),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              _headerCell(l10n.set, 40.w),
              _headerCell('${l10n.weight} (${l10n.kg})'.toUpperCase(), 80.w),
              _headerCell(l10n.reps.toUpperCase(), 80.w),
              const Spacer(),
              _headerCell(l10n.done.toUpperCase(), 50.w),
            ],
          ),
          SizedBox(height: 10.h),
          ...exercise.sets.asMap().entries.map((entry) => _buildSetRow(exIndex, entry.key, entry.value)),
          SizedBox(height: 15.h),
          GestureDetector(
            onTap: () => _addSet(exIndex),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2), style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.grey, size: 18.sp),
                  SizedBox(width: 8.w),
                  Text(l10n.addSet, style: AppTextStyles.bodyMd.copyWith(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCell(String label, double width) {
    return SizedBox(
      width: width,
      child: Text(
        label,
        style: AppTextStyles.labelSm.copyWith(color: Colors.grey, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildSetRow(int exIndex, int setIndex, SetEntryModel set) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          SizedBox(
            width: 40.w,
            child: Text(
              '${setIndex + 1}',
              style: AppTextStyles.bodyLg.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          _buildInputBox(
            initialValue: set.weight == 0 ? '' : set.weight.toString(),
            onChanged: (val) {
              final weight = double.tryParse(val) ?? 0;
              final sets = List<SetEntryModel>.from(_exercises[exIndex].sets);
              sets[setIndex] = SetEntryModel(weight: weight, reps: set.reps);
              _exercises[exIndex] = ExerciseModel(id: _exercises[exIndex].id, name: _exercises[exIndex].name, category: _exercises[exIndex].category, sets: sets);
              _autoSave();
            },
          ),
          SizedBox(width: 10.w),
          _buildInputBox(
            initialValue: set.reps == 0 ? '' : set.reps.toString(),
            onChanged: (val) {
              final reps = int.tryParse(val) ?? 0;
              final sets = List<SetEntryModel>.from(_exercises[exIndex].sets);
              sets[setIndex] = SetEntryModel(weight: set.weight, reps: reps);
              _exercises[exIndex] = ExerciseModel(id: _exercises[exIndex].id, name: _exercises[exIndex].name, category: _exercises[exIndex].category, sets: sets);
              _autoSave();
            },
          ),
          const Spacer(),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red[400], size: 20.sp),
            onPressed: () {
              setState(() {
                final sets = List<SetEntryModel>.from(_exercises[exIndex].sets);
                sets.removeAt(setIndex);
                _exercises[exIndex] = ExerciseModel(
                  id: _exercises[exIndex].id,
                  name: _exercises[exIndex].name,
                  category: _exercises[exIndex].category,
                  sets: sets,
                );
              });
              _autoSave();
            },
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                final sets = List<SetEntryModel>.from(_exercises[exIndex].sets);
                sets[setIndex] = SetEntryModel(
                  weight: set.weight,
                  reps: set.reps,
                  isDone: !set.isDone,
                );
                _exercises[exIndex] = ExerciseModel(
                  id: _exercises[exIndex].id,
                  name: _exercises[exIndex].name,
                  category: _exercises[exIndex].category,
                  sets: sets,
                );
              });
              _autoSave();
            },
            child: Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: set.isDone ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: set.isDone ? AppColors.primary : Colors.grey.withValues(alpha: 0.3),
                ),
              ),
              child: set.isDone ? Icon(Icons.check, color: Colors.white, size: 16.sp) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBox({required String initialValue, required Function(String) onChanged}) {
    final theme = Theme.of(context);
    return Container(
      width: 80.w,
      height: 40.h,
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: TextFormField(
        initialValue: initialValue,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: AppTextStyles.bodyLg.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        onChanged: onChanged,
        decoration: const InputDecoration(
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.only(top: 8),
        ),
      ),
    );
  }
}
