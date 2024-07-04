import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../../common/config/config.dart';
import 'state.dart';

class AddSpecController extends GetxController {
  final AddSpecState state = AddSpecState();
  AddSpecController();
  final TextEditingController nameCarController = TextEditingController();
  // final TextEditingController thumbnailController = TextEditingController();
  final TextEditingController specNameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController valueController = TextEditingController();
  final TextEditingController unitController = TextEditingController();

  Future<void> createSpec() async {
    try {
      state.nameCar.value = nameCarController.text;
      String specName = specNameController.text;
      String category = categoryController.text;
      String value = valueController.text;
      String unit = unitController.text;

      print('nameCar: ${state.nameCar.value}');
      print('specName: $specName');
      print('category: $category');
      print('value: $value');
      print('unit: $unit');

      final response = await http.post(Uri.parse(specURL), headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
        "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
      }, body: {
        "nameCar": nameCarController.text,
        "category": category,
        "nameSpec": specName,
        "value": value,
        "unit": unit,
      });
      print(response.statusCode);
      if (response.statusCode == 201) {
        print('Spec car ${state.nameCar.value} added successfully');
        Get.snackbar(
          'Success',
          'Car added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );

        // Xóa dữ liệu trên các trường nhập liệu
        nameCarController.clear();
        specNameController.clear();
        categoryController.clear();
        valueController.clear();

        unitController.clear();
      } else if (response.statusCode == 404) {
        Get.snackbar(
          'Error',
          'Car not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        print('Car not found');
        throw Exception('Car not found');
      }
      // else {
      //   print('Failed to create spec');
      //   Get.snackbar(
      //     'Error',
      //     'Failed to create car',
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.red,
      //   );
      //   throw Exception();
      // }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
