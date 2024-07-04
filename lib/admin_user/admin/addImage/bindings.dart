import 'package:get/get.dart';

import 'controller.dart';

class AddImageBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddImageController>(() => AddImageController());
  }
}
