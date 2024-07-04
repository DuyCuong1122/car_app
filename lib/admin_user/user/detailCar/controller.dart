import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';

import '../../../common/entities/detailCar.dart';

import 'package:do_an_tot_nghiep_final/common/config/config.dart';
import 'package:do_an_tot_nghiep_final/common/entities/entities.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../common/store/user.dart';
import 'state.dart';

class DetailCarController extends GetxController {
  final DetailCarState state = DetailCarState();
  DetailCarController();
  final data = Get.arguments;
  final commentTextController = TextEditingController();
  late final idUser;
  @override
  void onInit() async {

    String profile = await UserDBStore.to.getProfile();
    idUser = UserDB.fromJson(jsonDecode(profile)).id!.toString();
    log("idUser" + idUser);
    getDetailCar();
    super.onInit();
  }

  Future<List<dynamic>> fetchEvaluation() async {
    final nameCar = data.nameCar;
    try {
      final response = await http
          .post(Uri.parse(fetchEvaluationURL), body: {'nameCar': data.nameCar});
      if (response.statusCode == 200) {
        // print(response.body);
        return json.decode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load posts : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  Stream<List<dynamic>> getAllEvaluation() async* {
    while (true) {
      yield await fetchEvaluation();
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> addEvaluation(String text) async {
    try {
      final response = await http.post(Uri.parse(addEvaluationURL), body: {
        'nameCar': data.nameCar,
        'idUser': idUser,
        'content': text
      });
      // log(response.statusCode.toString());
    } catch (e) {
      throw Exception('Failed to add evaluation: $e');
    }
  }

  Future<void> getDetailCar() async {
    final nameCar = data.nameCar;
    log(nameCar);
    try {
      final res = await http.get(Uri.parse("$carURL?nameCar=$nameCar"));
      if (res.statusCode == 200) {
        Map<String, dynamic> dataJson = jsonDecode(res.body);

        // Parse JSON to DetailCar object
        DetailCar detailCar = DetailCar.fromJson(dataJson);
        // log(state.detail.first.infos.length.toString());
        // log(detailCar.rating.idCar.toString());
        // Update state with parsed data
        state.detail.clear();
        state.detail.add(detailCar);

        // Update other states for convenience
        state.car.clear();
        state.car.add(detailCar.car);

        state.specs.assignAll(detailCar.specs);
        state.image.assignAll(detailCar.images);
        for(var i in state.image)
          {
            state.colors_image.addIf(i.type == "Colors", i);
            state.feature_image.addIf(i.type != "Colors", i);
          }

        // log(state.image[0].path);
        // Update other individual attributes if needed
      } else {
        throw Exception('Failed to load car details');
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
