import 'package:get/get.dart';

import 'controller.dart';

class ShowroomBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShowroomController());
  }
}
