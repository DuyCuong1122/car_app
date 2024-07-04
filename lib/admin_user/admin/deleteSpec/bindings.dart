import 'package:get/get.dart';

import 'controller.dart';

class DeleteSpecBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeleteSpecController>(() => DeleteSpecController());
  }
}
