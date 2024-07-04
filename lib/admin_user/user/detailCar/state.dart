import 'package:do_an_tot_nghiep_final/common/entities/image.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/state_manager.dart';

import '../../../common/entities/car.dart';
import '../../../common/entities/detailCar.dart';
import '../../../common/entities/spec.dart';

class DetailCarState {
  var nameCar = "".obs;
  var year = "".obs;
  var price = "".obs;
  var description = "".obs;
  var thumbnail = "".obs;
  var linkCar = "".obs;
  // var showroom = "".obs;
  // var stateCar = "".obs;
  RxList<Car> car = <Car>[].obs;
  RxList<Spec> specs = <Spec>[].obs;
  RxList<Image> image = <Image>[].obs;
  RxList<Image> colors_image = <Image>[].obs;
  RxList<Image> feature_image = <Image>[].obs;
  RxList<DetailCar> detail = <DetailCar>[].obs;
  var idUser = "".obs;
}
