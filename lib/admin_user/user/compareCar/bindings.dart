import 'package:get/get.dart';

import 'controller.dart';

class CompareBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CompareController>(() => CompareController());
  }
}
