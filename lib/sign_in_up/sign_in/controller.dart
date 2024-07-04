import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../common/config/config.dart';
import '../../common/entities/user.dart';
import '../../common/store/user.dart';
import 'index.dart';

// GoogleSignIn googleSignIn = GoogleSignIn(scopes: <String>['openid']);

class SignInController extends GetxController {
  final state = SignInState();
  SignInController();
  // final FirebaseAuth auth = FirebaseAuth.instance;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  // final db = FirebaseFirestore.instance;

  String getEmailUsername(String email) {
    // Tìm vị trí của ký tự '@'
    int atIndex = email.indexOf('@');
    if (atIndex != -1) {
      // Trích xuất phần tên từ đầu đến ký tự '@'
      return email.substring(0, atIndex);
    } else {
      // Nếu không tìm thấy ký tự '@', trả về toàn bộ địa chỉ email
      return email;
    }
  }

  Future<void> handleSignInDB() async {
    String username = usernameController.text;
    String password = passwordController.text;

    const url = sign_in;

    print(url);
    try {
      final response =
          await http.post(Uri.parse(Uri.encodeFull(url)), headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
        "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
      }, body: {
        "username": username,
        "password": password,
      });

      if (response.statusCode == 200) {
        // Print out the comparisons for verification

        final datajson = jsonDecode(response.body);
        UserDB user = UserDB.fromJson(datajson);
        UserDB profile = UserDB(
            email: user.email,
            displayName: user.displayName,
            access_token: user.access_token,
            id: user.id,
            roles: user.roles);

        UserDBStore.to.saveProfile(profile);

        Get.snackbar(
          'Thông báo',
          'Đăng nhập thành công!!!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
        Get.offAndToNamed('/application');
      } else {
        Get.snackbar(
          'Lỗi',
          'Lỗi đăng nhập',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        throw Exception('Failed to Sign-in ');
      }
    } catch (e) {
      log("error: $e");
    }
  }
}
