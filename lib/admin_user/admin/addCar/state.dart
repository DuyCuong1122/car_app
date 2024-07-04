import 'dart:io';

import 'package:get/get.dart';

class AddCarState {
  var nameCar = ''.obs;
  var thumbnail = ''.obs;
  var release = ''.obs;
  RxDouble price = 0.0.obs;
  var stateCar = ''.obs;
  var description = ''.obs;
  var showroom = ''.obs;
  Rx<File?> file = Rx<File?>(null);
}
