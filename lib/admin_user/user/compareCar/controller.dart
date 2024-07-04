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
          'Content-Type': 'application/json',
          'Accept': '*/*',
        },
      );
      log('HTTP response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final parsedJson = jsonDecode(response.body);

        log('Parsed JSON: $parsedJson');

        state.carsWithSpecs1 = parsedJson.map<CarWithSpecs>((data) {
          return CarWithSpecs.fromJson(data, 'car1', 'specs1', 'updatedImage1');
        }).toList();

        state.carsWithSpecs2 = parsedJson.map<CarWithSpecs>((data) {
          return CarWithSpecs.fromJson(data, 'car2', 'specs2', 'updatedImage2');
        }).toList();

        // Tạo map spec names theo category cho 2 xe
        state.car1SpecsByCategory = getSpecNamesByCategory(
            state.carsWithSpecs1.expand((cws) => cws.specs).toList());
        state.car2SpecsByCategory = getSpecNamesByCategory(
            state.carsWithSpecs2.expand((cws) => cws.specs).toList());

        // Tìm các category chung
        state.commonCategories = state.car1SpecsByCategory.keys
            .toSet()
            .intersection(state.car2SpecsByCategory.keys.toSet());
        for(var i in state.carsWithSpecs1.first.images) {
          state.color_car1.addIf(i.type == "Colors", i);
        }
        for ( var i in state.carsWithSpecs2.first.images)
          {
            state.color_car2.addIf(i.type == "Colors", i);
          }
      } else {
        log('Failed to load data');
      }
    } catch (e) {
      log('Error: $e');
    }
  }
}
