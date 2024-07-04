
import 'package:get/get.dart';

import '../../../common/entities/comparison.dart';
import '../../../common/entities/image.dart';


class CompareState {
  List<CarWithSpecs> carsWithSpecs1 = <CarWithSpecs>[].obs;
  List<CarWithSpecs> carsWithSpecs2 = <CarWithSpecs>[].obs;
  Set<String> commonCategories = <String>{};
  Map<String, Set<String>> car1SpecsByCategory = <String, Set<String>>{}.obs;
  Map<String, Set<String>> car2SpecsByCategory = <String, Set<String>>{}.obs;
  RxList<Image> color_car1 = <Image>[].obs;
  RxList<Image> color_car2 = <Image>[].obs;
}
