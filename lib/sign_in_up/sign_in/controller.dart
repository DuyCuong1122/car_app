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
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> handleSignInDB(BuildContext context) async {
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
        // Xử lý dữ liệu người dùng
        final datajson = jsonDecode(response.body);
        UserDB user = UserDB.fromJson(datajson);
        UserDB profile = UserDB(
            email: user.email,
            displayName: user.displayName,
            access_token: user.access_token,
            id: user.id,
            roles: user.roles,
            address: user.address,
            phoneNumber: user.phoneNumber);

        UserDBStore.to.saveProfile(profile);

        Get.snackbar(
          'Thông báo',
          'Đăng nhập thành công!!!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );

        // Chuyển sang trang CarSelectionPage khi đăng nhập thành công
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CarSelectionPage()),
        );
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
