import 'dart:convert';
import 'dart:developer';

import 'package:do_an_tot_nghiep_final/admin_user/profile/index.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:get/get.dart';

import '../../common/config/config.dart';
import '../../common/entities/user.dart';
import '../../common/store/user.dart';

class ProfileController extends GetxController {
  ProfileController();
  final state = ProfileState();
  final nameTextField = TextEditingController();
  final addressTextField = TextEditingController();
  final phoneTextField = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    try {
      String? profile = await UserDBStore.to.getProfile();

      UserDB userdata = UserDB.fromJson(jsonDecode(profile));
      state.name.value = userdata.displayName ?? "N/A";
      state.email.value = userdata.email ?? "N/A";
      state.address.value = userdata.address ?? "N/A";
      state.phone.value = userdata.phoneNumber ?? "N/A";
      log(state.email.value.toString());
      log(state.name.value.toString());
      log(state.phone.value.toString());
      log(state.address.value.toString());
    } catch (e) {
      log('Error loading profile: $e');
    }
  }

  Future<void> updateProfile() async {
    try {
      String? profile = await UserDBStore.to.getProfile();

      UserDB userdata = UserDB.fromJson(jsonDecode(profile));
      log("userdata:${userdata.id}");
      final body = {
        "idUser": userdata.id,
        "displayName": nameTextField.text,
        "address": addressTextField.text,
        "phoneNumber": phoneTextField.text
      };
      log(body.toString());
      final response = await http.post(Uri.parse(update_profileURL), headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
        "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
      }, body: body);


      if (response.statusCode == 200) {
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
          'Thay đổi thành công!!!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
      } else {
        Get.snackbar(
          'Lỗi',
          'Lỗi thay đổi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        throw Exception('Failed to change profile');
      }
    } catch (e) {
      log('Error updating profile: $e');
      Get.snackbar(
        'Lỗi',
        'Lỗi thay đổi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }
}
