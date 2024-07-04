import 'dart:convert';
import 'dart:developer';
import '../../../common/entities/detailCar.dart';

import 'package:do_an_tot_nghiep_final/common/config/config.dart';
import 'package:do_an_tot_nghiep_final/common/entities/entities.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../common/entities/car.dart';
import '../../../common/entities/image.dart';
import 'state.dart';

class DetailCarController extends GetxController {
  final DetailCarState state = DetailCarState();
  DetailCarController();
  var data = Get.arguments;

  @override
  void onInit() {
    super.onInit();
    getDetailCar();
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
        log(detailCar.rating.idCar.toString());
        // Update state with parsed data
        state.detail.clear();
        state.detail.add(detailCar);

        // Update other states for convenience
        state.car.clear();
        state.car.add(detailCar.car);

        state.specs.assignAll(detailCar.specs);
        state.image.assignAll(detailCar.images);
        log(state.image[0].path);
        // Update other individual attributes if needed
      } else {
        throw Exception('Failed to load car details');
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}
