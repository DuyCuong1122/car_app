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
  @override
  void onInit() async {
    String profile = await UserDBStore.to.getProfile();
    UserDB userdata = UserDB.fromJson(jsonDecode(profile));
    state.name.value = userdata.displayName ?? "N/A";
    state.email.value = userdata.email ?? "N/A";
    log(state.email.value.toString());
    log(state.name.value.toString());
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> updateProfile() async {
    String profile = await UserDBStore.to.getProfile();
    UserDB userdata = UserDB.fromJson(jsonDecode(profile));
    String name = nameTextField.text;
    final response = await http.post(Uri.parse(changeNameUser), headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
      "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
    }, body: {
      "id": userdata.id,
      "dissplayName": name
    });
  }
}
