import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lift_log/core/services/firebase_auth_service.dart';
import 'package:lift_log/data/data_sources/local/user_local_data_source.dart';
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
      // فشل المزامنة السحابية، سنعتمد على البيانات المحلية أو الافتراضية
    }
  }

  Future<void> _mergeTempOnboardingData(UserModel user) async {
    final settingsBox = Hive.box(HiveService.settingsBox);
    final tempCurrent = settingsBox.get('temp_current_weight');
    final tempTarget = settingsBox.get('temp_target_weight');

    if (tempCurrent != null || tempTarget != null) {
      final updatedUser = user.copyWith(
        currentWeight: tempCurrent ?? user.currentWeight,
        targetWeight: tempTarget ?? user.targetWeight,
      );
      await updateUser(updatedUser); // التحديث هنا يرفع لـ Firestore أيضاً
      
      await settingsBox.delete('temp_current_weight');
      await settingsBox.delete('temp_target_weight');
    }
  }

  Future<UserCredential?> login(String email, String password) async {
    final credential = await _firebaseAuthService.signIn(email, password);
    if (credential != null && credential.user != null) {
      // جلب البيانات من السحاب فور تسجيل الدخول
      await _syncProfileFromCloud(credential.user!.uid);
      
      final existingUser = await _localDataSource.getUser();
      if (existingUser == null || existingUser.id != credential.user!.uid) {
        final newUser = UserModel(
          id: credential.user!.uid,
          email: credential.user!.email ?? email,
          name: credential.user!.displayName ?? email.split('@')[0],
        );
        await _localDataSource.saveUser(newUser);
        await _mergeTempOnboardingData(newUser);
      }
    }
    return credential;
  }

  Future<UserCredential?> loginWithGoogle() async {
    final credential = await _firebaseAuthService.signInWithGoogle();
    if (credential != null && credential.user != null) {
      await _syncProfileFromCloud(credential.user!.uid);
      
      final existingUser = await _localDataSource.getUser();
      if (existingUser == null || existingUser.id != credential.user!.uid) {
        final newUser = UserModel(
          id: credential.user!.uid,
          email: credential.user!.email ?? "",
          name: credential.user!.displayName ?? credential.user!.email?.split('@')[0] ?? "Athlete",
        );
        await _localDataSource.saveUser(newUser);
        await _mergeTempOnboardingData(newUser);
      }
    }
    return credential;
  }

  Future<UserCredential?> register(String email, String password, {String? name}) async {
    final credential = await _firebaseAuthService.signUp(email, password);
    if (credential != null && credential.user != null) {
      final userModel = UserModel(
        id: credential.user!.uid,
        email: email,
        name: name ?? email.split('@')[0],
      );
      await updateUser(userModel); // الحفظ محلياً وفي Firestore
      await _mergeTempOnboardingData(userModel);
    }
    return credential;
  }

  Future<void> logout() async {
    await _firebaseAuthService.signOut();
  }

  Future<UserModel?> getCurrentUser() async {
    return await _localDataSource.getUser();
  }

  Future<void> updateUser(UserModel user) async {
    // حفظ محلي
    await _localDataSource.saveUser(user);
    // حفظ في Firestore
    try {
      await _firestore.collection('users').doc(user.id).set(user.toMap(), SetOptions(merge: true));
    } catch (e) {
      // فشل المزامنة السحابية
    }
  }
}
