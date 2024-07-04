import 'package:get/get.dart';

import 'controller.dart';

class DeleteCarBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeleteCarController>(() => DeleteCarController());
  }
}
