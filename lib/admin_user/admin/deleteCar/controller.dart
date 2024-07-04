import 'package:do_an_tot_nghiep_final/admin_user/admin/deleteCar/state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';

import '../../../common/config/config.dart';

class DeleteCarController extends GetxController {
  final DeleteCarState state = DeleteCarState();
  DeleteCarController();
  final TextEditingController nameCarController = TextEditingController();


  Future<void> deleteCar() async {
    try {
      String nameCar = nameCarController.text;

      print('Sending request with body:');
      print('nameCar: $nameCar');

      final response =
          await http.delete(Uri.parse("$carURL/$nameCar"), headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
        "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
      }, body: {
        "nameCar": nameCar,
      });

      if (response.statusCode == 200) {
        print('Car deleted successfully');
        Get.snackbar(
          'Success',
          'Car deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );

        // Xóa dữ liệu trên các trường nhập liệu
        nameCarController.clear();
      } else if (response.statusCode == 404) {
        Get.snackbar(
          'Error',
          'Car with this name does not exist',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        print('Car with this name does not exist');
        throw Exception('Car with this name does not exist');
      } else {
        print('Failed to delete car');
        Get.snackbar(
          'Error',
          'Failed to delete car',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        throw Exception('Failed to delete car');
      }
    } catch (e) {
      print(e);
    }
  }
}
