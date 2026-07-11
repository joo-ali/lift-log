import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../data/models/workout_model.dart';

class RoutineService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<WorkoutModel>> getRemoteSuggestedRoutines() async {
    try {
      final snapshot = await _firestore
          .collection('suggested_routines')
          .orderBy('order') // اختياري: لترتيب الجداول
          .get();

      if (snapshot.docs.isEmpty) return [];

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return WorkoutModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('Error fetching routines: $e');
      return []; // في حالة الخطأ نعود بقائمة فارغة لنستخدم المحلي
    }
  }
}
