import 'package:get/get.dart';

import '../../../common/entities/car.dart';

class DisplayCarState {
  RxString name = ''.obs;
  RxString image = ''.obs;
  RxList<Car> cars = <Car>[].obs;
}
