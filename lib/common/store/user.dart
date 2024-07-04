// import 'dart:convert';
// import 'package:get/get.dart';
//
// import '../entities/user.dart';
// import '../services/storage.dart';
// import '../values/storage.dart';
//
// class UserDBStore extends GetxController {
//   static UserDBStore get to => Get.find();
//
//   // login state
//   final _isLogin = false.obs;
//   // token
//   String token = '';
//   // profile
//   final _profile = UserDB().obs;
//
//   bool get isLogin => _isLogin.value;
//   UserDB get profile => _profile.value;
//   bool get hasToken => token.isNotEmpty;
//
//   @override
//   void onInit() {
//     super.onInit();
//     token = StorageService.to.getString(STORAGE_ACCESS_TOKEN_KEY);
//     var profileOffline = StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
//     if (profileOffline.isNotEmpty) {
//       _isLogin.value = true;
//       _profile(UserDB.fromJson(jsonDecode(profileOffline)));
//     }
//   }
//
//   // set token
//   Future<void> setToken(String value) async {
//     await StorageService.to.setString(STORAGE_USER_TOKEN_KEY, value);
//     token = value;
//   }
//
//   // 获取 profile
//   Future<String> getProfile() async {
//     if (token.isEmpty) return "";
//     // var result = await UserAPI.profile();
//     // _profile(result);
//     // _isLogin.value = true;
//     return StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
//   }
//
//   // 保存 profile
//   Future<void> saveProfile(UserDB profile) async {
//     _isLogin.value = true;
//     print('profile: ${profile.access_token}');
//     StorageService.to.setString(STORAGE_USER_PROFILE_KEY, jsonEncode(profile));
//     setToken(profile.access_token!);
//   }
//
//   // 注销
//   Future<void> onLogout() async {
//     // if (_isLogin.value) await UserAPI.logout();
//     await StorageService.to.remove(STORAGE_USER_TOKEN_KEY);
//     await StorageService.to.remove(STORAGE_USER_PROFILE_KEY);
//     _isLogin.value = false;
//     token = '';
//   }
// }
// store/user.dart
import 'dart:convert';
import 'package:get/get.dart';

import '../entities/user.dart';
import '../services/storage.dart';
import '../values/storage.dart';

class UserDBStore extends GetxController {
  static UserDBStore get to => Get.find();

  // login state
  final _isLogin = false.obs;
  // token
  String token = '';
  // profile
  final _profile = UserDB().obs;

  bool get isLogin => _isLogin.value;
  UserDB get profile => _profile.value;
  bool get hasToken => token.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    token = StorageService.to.getString(STORAGE_ACCESS_TOKEN_KEY);
    var profileOffline = StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
    if (profileOffline.isNotEmpty) {
      _isLogin.value = true;
      _profile(UserDB.fromJson(jsonDecode(profileOffline)));
    }
  }

  // set token
  Future<void> setToken(String value) async {
    await StorageService.to.setString(STORAGE_USER_TOKEN_KEY, value);
    token = value;
  }

  // 获取 profile
  Future<String> getProfile() async {
    if (token.isEmpty) return "";
    // var result = await UserAPI.profile();
    // _profile(result);
    // _isLogin.value = true;
    return StorageService.to.getString(STORAGE_USER_PROFILE_KEY);
  }

  // 保存 profile
  Future<void> saveProfile(UserDB profile) async {
    _isLogin.value = true;
    print('profile: ${profile.access_token}');
    StorageService.to.setString(STORAGE_USER_PROFILE_KEY, jsonEncode(profile.toJson()));
    setToken(profile.access_token!);
    _profile.value = profile; // Update local profile state
  }

  // 注销
  Future<void> onLogout() async {
    // if (_isLogin.value) await UserAPI.logout();
    await StorageService.to.remove(STORAGE_USER_TOKEN_KEY);
    await StorageService.to.remove(STORAGE_USER_PROFILE_KEY);
    _isLogin.value = false;
    token = '';
  }
}
