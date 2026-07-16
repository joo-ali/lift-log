import 'package:hive_flutter/hive_flutter.dart';
import 'package:lift_log/data/models/user_model.dart';
import 'package:lift_log/core/services/hive_service.dart';

class UserLocalDataSource {
  Box<UserModel> get _userBox => Hive.box<UserModel>(HiveService.userBox);

  Future<void> saveUser(UserModel user) async {
    await _userBox.put('current_user', user);
  }

  Future<UserModel?> getUser() async {
    return _userBox.get('current_user');
  }

  Future<void> deleteUser() async {
    await _userBox.delete('current_user');
  }
}
