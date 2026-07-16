import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lift_log/core/services/firebase_auth_service.dart';
import 'package:lift_log/data/data_sources/local/user_local_data_source.dart';
import 'package:lift_log/data/models/workout_model.dart';
import 'package:lift_log/data/models/user_model.dart';
import 'package:hive/hive.dart';
import 'package:lift_log/core/services/hive_service.dart';

class AuthRepository {
  final FirebaseAuthService _firebaseAuthService;
  final UserLocalDataSource _localDataSource;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthRepository(
    this._firebaseAuthService,
    this._localDataSource,
  );

  Future<void> _syncProfileFromCloud(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final cloudUser = UserModel.fromMap(doc.data()!);
        await _localDataSource.saveUser(cloudUser);
      }
    } catch (e) {
      // فشل المزامنة السحابية، سنعتمد على البيانات المحلية
    }
  }

  Future<UserCredential?> login(String email, String password) async {
    final credential = await _firebaseAuthService.signIn(email, password);
    if (credential != null && credential.user != null) {
      await _syncProfileFromCloud(credential.user!.uid);
      
      final existingUser = await _localDataSource.getUser();
      if (existingUser == null || existingUser.id != credential.user!.uid) {
        final newUser = UserModel(
          id: credential.user!.uid,
          email: credential.user!.email ?? email,
          name: credential.user!.displayName ?? email.split('@')[0],
        );
        await _localDataSource.saveUser(newUser);
      }
    }
    return credential;
  }

  Future<UserCredential?> register(
    String email,
    String password, {
    String? name,
    double? currentWeight,
    double? targetWeight,
  }) async {
    final credential = await _firebaseAuthService.signUp(email, password);
    if (credential != null && credential.user != null) {
      final userModel = UserModel(
        id: credential.user!.uid,
        email: email,
        name: name ?? email.split('@')[0],
        currentWeight: currentWeight ?? 0.0,
        targetWeight: targetWeight ?? 0.0,
      );
      await updateUser(userModel);
    }
    return credential;
  }

  Future<UserModel?> getCurrentUser() async {
    return await _localDataSource.getUser();
  }

  Future<void> logout() async {
    await _firebaseAuthService.signOut();
    await _localDataSource.deleteUser();
    final workoutBox = Hive.box<WorkoutModel>(HiveService.workoutBox);
    await workoutBox.clear();
  }

  Future<void> updateUser(UserModel user) async {
    await _localDataSource.saveUser(user);
    _firestore
        .collection('users')
        .doc(user.id)
        .set(user.toMap(), SetOptions(merge: true))
        .catchError((e) => print("Firestore Update Error: $e"));
  }
}
