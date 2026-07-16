import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lift_log/data/models/workout_model.dart';
import 'package:lift_log/data/models/exercise_model.dart';
import 'package:lift_log/data/models/set_entry_model.dart';
import 'package:uuid/uuid.dart';

class RoutineService {
  // زودنا الـ limit لـ 100 عشان نجيب كل الـ Splits اللي في الـ API
  final String _baseUrl = 'https://6a56c9c4b17de7bebbde7ada.mockapi.io/split?limit=100';

  Future<List<WorkoutModel>> getRemoteSuggestedRoutines() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);
        if (decodedData is! List) return [];
        
        final List<dynamic> data = decodedData;
        List<WorkoutModel> allRoutines = [];

        // بنفلتر بذكاء: بناخد بس الـ objects اللي فيها 'days' ونتأكد إنها موجودة
        final splitsOnly = data.where((item) => 
          item is Map && item.containsKey('days')
        );

        for (var split in splitsOnly) {
          final List<dynamic> days = split['days'] is List ? split['days'] : [];
          if (days.isEmpty) continue;

          for (var day in days) {
            if (day is! Map) continue;
            
            // معالجة الـ sameAs: لو اليوم ده تكرار ليوم قبله (زي Day 4 نفس Day 1)
            List<dynamic> exercisesData = day['exercises'] is List ? day['exercises'] : [];
            
            final sameAsValue = day['sameAs'];
            if (sameAsValue != null) {
              final int? targetDayNum = int.tryParse(sameAsValue.toString());
              if (targetDayNum != null) {
                final targetIndex = targetDayNum - 1;
                if (targetIndex >= 0 && targetIndex < days.length) {
                  final targetDay = days[targetIndex];
                  if (targetDay is Map && targetDay['exercises'] is List) {
                    exercisesData = targetDay['exercises'];
                  }
                }
              }
            }
            
            // لو اليوم ده ملوش تمارين (زي Rest Day)، مش بنضيفه كـ Workout
            if (exercisesData.isEmpty) continue;

            final splitName = split['name']?.toString() ?? 'Routine';
            final dayName = day['name']?.toString() ?? day['title']?.toString() ?? 'Day ${day['day'] ?? ''}';

            allRoutines.add(
              WorkoutModel(
                id: 'remote_${const Uuid().v4()}',
                title: "$splitName - $dayName",
                date: DateTime.now(),
                userId: 'system',
                exercises: (exercisesData).map((ex) {
                  // تحويل reps من string لـ int بذكاء (Failure أو 8-10)
                  int repsCount = 0;
                  final repsStr = ex['reps']?.toString() ?? '0';
                  final match = RegExp(r'\d+').firstMatch(repsStr);
                  if (match != null) {
                    repsCount = int.parse(match.group(0)!);
                  }

                  int setsCount = 3;
                  final rawSets = ex['sets'];
                  if (rawSets is int) {
                    setsCount = rawSets;
                  } else {
                    setsCount = int.tryParse(rawSets?.toString() ?? '3') ?? 3;
                  }

                  return ExerciseModel(
                    id: const Uuid().v4(),
                    name: ex['name']?.toString() ?? 'Exercise',
                    category: 'Others',
                    sets: List.generate(
                      setsCount,
                      (index) => SetEntryModel(
                        weight: 0,
                        reps: repsCount,
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }
        }
        return allRoutines;
      }
      return [];
    } catch (e) {
      print('Error fetching routines from API: $e');
      return [];
    }
  }
}

