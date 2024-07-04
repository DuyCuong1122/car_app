import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../common/config/config.dart';
import 'state.dart';

class DeleteSpecController extends GetxController {
  final DeleteSpecState state = DeleteSpecState();
  DeleteSpecController();
  final TextEditingController nameCarController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController nameSpecController = TextEditingController();

  Future<void> deleteCar() async {
    try {
      String nameCar = nameCarController.text;
      String category = categoryController.text;
      String nameSpec = nameSpecController.text;

      print('Sending request with body:');
      print('nameCar: $nameCar');
      print('category: $category');
      print('nameSpec: $nameSpec');

      final response = await http.delete(Uri.parse(specURL), headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
        "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
      }, body: {
        "nameCar": nameCar,
        "category": category,
        "nameSpec": nameSpec,
      });

      if (response.statusCode == 200) {
        print('Spec Car deleted successfully');
        Get.snackbar(
          'Success',
          'Spec Car deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );

        // Xóa dữ liệu trên các trường nhập liệu
        nameCarController.clear();
        categoryController.clear();
        nameSpecController.clear();
      } else if (response.statusCode == 404) {
        Get.snackbar(
          'Error',
          'Car with this name does not exist',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        print('Car with this name does not exist');
        throw Exception('Car with this name does not exist');
      } else if (response.statusCode == 400) {
        Get.snackbar(
          'Error',
          'Spec with this name does not exist',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        print('Spec with this name does not exist');
        throw Exception('Spec with this name does not exist');
      } else {
        print('Failed to delete Spec');
        Get.snackbar(
          'Error',
          'Failed to delete Spec',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        throw Exception('Failed to delete Spec');
      }
    } catch (e) {
      print(e);
    }
  }
}
