import 'dart:convert';

import 'package:do_an_tot_nghiep_final/common/config/config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ShowroomController extends GetxController {
  ShowroomController();
  @override
  void onInit() {
    super.onInit();
  }

  Future<List<dynamic>> fetchAllShowroom() async {
    try {
      final response = await http.get(Uri.parse(showroomURL));
      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load showrooms : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch showrooms: $e');
    }
  }

  Future<List<dynamic>> fetchAllCarInShowroom(String showroom) async {
    try {
      final response = await http
          .post(Uri.parse(carShowroomURL), body: {"nameShowroom": showroom});
      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load cars : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch cars: $e');
    }
  }

  Stream<List<dynamic>> getAllShowroom() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      yield await fetchAllShowroom();
    }
  }

  Stream<List<dynamic>> getAllCarInShowroom(String showroom) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      yield await fetchAllCarInShowroom(showroom);
    }
  }
}
