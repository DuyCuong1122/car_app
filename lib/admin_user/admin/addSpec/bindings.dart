import 'package:get/get.dart';

import 'controller.dart';

class AddSpecBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddSpecController>(() => AddSpecController());
  }
}
