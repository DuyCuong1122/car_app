import 'package:get/get.dart';

import '../../../common/entities/comparison.dart';

class CompareState {
  List<CarWithSpecs> carsWithSpecs1 = <CarWithSpecs>[].obs;
  List<CarWithSpecs> carsWithSpecs2 = <CarWithSpecs>[].obs;
  Set<String> commonCategories = <String>{};
  Map<String, Set<String>> car1SpecsByCategory = <String, Set<String>>{}.obs;
  Map<String, Set<String>> car2SpecsByCategory = <String, Set<String>>{}.obs;
}
