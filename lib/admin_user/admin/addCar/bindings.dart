import 'package:get/get.dart';

import 'controller.dart';

class AddCarBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddCarController>(() => AddCarController());
  }
}
