import 'package:get/get.dart';

import 'controller.dart';

class DetailCarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailCarController>(() => DetailCarController());
  }
}
