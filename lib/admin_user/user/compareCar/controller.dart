import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../common/config/config.dart';
import '../../../common/entities/entities.dart';
import 'index.dart';

class CompareController extends GetxController {
  CompareController();
  final CompareState state = CompareState();
  final TextEditingController car1Controller = TextEditingController();
  final TextEditingController car2Controller = TextEditingController();
  Map<dynamic, dynamic> tmp = <dynamic, dynamic>{};
  // List<Comparison> comparisons = [];

  Map<String, Set<String>> getSpecNamesByCategory(List<Spec> specs) {
    Map<String, Set<String>> specNamesByCategory = {};
    for (var spec in specs) {
      if (!specNamesByCategory.containsKey(spec.category)) {
        specNamesByCategory[spec.category!] = {};
      }
      specNamesByCategory[spec.category]!.add(spec.specName!);
    }
    return specNamesByCategory;
  }

  Future<void> getInfo2Cars() async {
    final car1 = car1Controller.text;
    final car2 = car2Controller.text;
    final url = '$compareCarURL?car1=$car1&car2=$car2';

    print(url);
    try {
      final response = await http.get(
        Uri.parse(Uri.encodeFull(url)),
        headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
          "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        List<dynamic> parsedJson = jsonDecode(response.body);
        print(parsedJson.toString());
        // comparisons =
        //     parsedJson.map((json) => Comparison.fromJson(json)).toList();
        state.carsWithSpecs1 = parsedJson.map((data) {
          return CarWithSpecs.fromJson(data, 'car1', 'specs1', 'updatedImage1');
        }).toList();

        state.carsWithSpecs2 = parsedJson.map((data) {
          return CarWithSpecs.fromJson(data, 'car2', 'specs2', 'updatedImage2');
        }).toList();

        List<CarWithSpecs> carsWithSpecs = [
          state.carsWithSpecs1[0],
          state.carsWithSpecs2[0]
        ];

        // for (var carWithSpecs in carsWithSpecs1) {
        //   log('Car: ${carWithSpecs.car.nameCar}, Release Year: ${carWithSpecs.car.release}');
        //   for (var spec in carWithSpecs.specs) {
        //     print('  ${spec.category} - ${spec.specName}: ${spec.value}');
        //   }
        // }
        // Lấy các specName theo category cho từng xe
        state.car1SpecsByCategory =
            getSpecNamesByCategory(carsWithSpecs[0].specs);
        state.car2SpecsByCategory =
            getSpecNamesByCategory(carsWithSpecs[1].specs);

        // Tìm các category chung và in ra các specName của chúng
        state.commonCategories = state.car1SpecsByCategory.keys
            .toSet()
            .intersection(state.car2SpecsByCategory.keys.toSet());

        // for (var category in state.commonCategories) {
        //   int count = 0;
        //   print('Category: $category');
        //   Set<String> commonSpecNames = state.car1SpecsByCategory[category]!
        //       .intersection(state.car2SpecsByCategory[category]!);
        //   for (var specName in commonSpecNames) {
        //     print('  SpecName: $specName');
        //     count++;
        //   }
        //   print(count);
        // }

        // for (var carWithSpecs in state.carsWithSpecs2) {
        //   log('Car: ${carWithSpecs.car.nameCar}, Release Year: ${carWithSpecs.car.release}');

        //   // for (var spec in carWithSpecs.specs) {
        //   //   print('  ${spec.category} - ${spec.specName}: ${spec.value}');
        //   // }
        //   carWithSpecs.specs
        //       .where((element) =>
        //           element.category == 'Dimensions, Weights & Capacities')
        //       .forEach((element) {
        //     print(
        //         '  ${element.category} - ${element.specName}: ${element.value}');
        //   });
        // }

        // Print out the comparisons for verification
        // comparisons.forEach((comparison) {
        //   print(comparison.car1);
        //   comparison.specs1.forEach((spec) {
        //     log(spec.toString());
        //   });
        //   print(comparison.car2);
        //   comparison.specs2.forEach((spec) {
        //     tmp[spec.specName] = spec.category;
        //   });
        //   Car car1 = comparisons[0].car1;
        //   Car car2 = comparisons[0].car2;
        //   log('car1: ${car1.nameCar}');
        //   log('car2: ${car2.nameCar}');

        //   // state.cars.forEach((element) {
        //   //   log(element.nameCar);
        //   //   log(element.release);
        //   // });
        // });
        // tmp.forEach((key, value) {
        //   log('key: $key, value: $value');
        //   log('------------------');
        //   // state.cars[key] = value;
        // });
        Get.snackbar(
          'Success',
          'Car found successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );
      } else {
        Get.snackbar(
          'error',
          'Failed to get cars info',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        throw Exception('Failed to get cars info');
      }
    } catch (e) {
      log("error: $e");
    }
  }
}
