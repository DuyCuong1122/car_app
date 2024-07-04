import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import '../../../common/config/config.dart';
import '../../../common/entities/car.dart';
import 'state.dart';

class HomeController extends GetxController {
  HomeState state = HomeState();
  final search = TextEditingController();

  void setSelected(String value) {
    state.selectedValue.value = value;
  }

  void selectCarType(String type) {
    state.selectedCarType.value = type;
  }

  void getSuggestions(String query) async {
    log(query);
    if (query.isEmpty) {
      state.suggestions.clear();
      return;
    }

    final response = await http.get(Uri.parse(searchCarURL + query));
    if (response.statusCode == 200) {
      state.suggestions.assignAll(json.decode(response.body));
    } else {
      Get.snackbar('Error', 'Failed to load suggestions');
    }
  }

  String cleanBase64(String base64String) {
    // Loại bỏ các ký tự không hợp lệ cho Base64
    base64String = base64String.replaceAll(RegExp(r'[^A-Za-z0-9+/=]'), '');

    // Thêm padding nếu cần thiết
    while (base64String.length % 4 != 0) {
      base64String += '=';
    }

    return base64String;
  }

// Hàm giải mã Base64
  Uint8List decodeBase64(String base64String)  {
    String cleanedBase64String = cleanBase64(base64String);
    return base64.decode(cleanedBase64String);
  }

  void fetchCars(String nameCar) async {
    state.cars.clear();
    try {
      final response = await http.get(
        Uri.parse(searchCarURL + nameCar),
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
          "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> carList = jsonDecode(response.body);
        state.cars.value = carList.map((data) => Car.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load cars');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load cars: $e');
    }
  }

  Future<void> fetchACar(String nameCar) async {
    state.cars.clear();
    try {
      final response = await http.get(
        Uri.parse(searchCarURL + nameCar),
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
          "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> carList = jsonDecode(response.body);
        state.selectedSuggestion.value = carList.map((data) => Car.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load cars');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load cars: $e');
    }
  }

  Future<void> fetchAllCars() async {
    state.cars.clear();
    try {
      final response = await http.get(
        Uri.parse(carsURL),
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
          "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> carList = jsonDecode(response.body);

        List<Car> cars = carList.map((data) => Car.fromJson(data)).toList();
        state.cars.value = List.from(cars.reversed);
      } else {
        throw Exception('Failed to load cars');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load cars: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllCars();
  }
}
