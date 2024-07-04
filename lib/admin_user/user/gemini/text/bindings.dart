import 'package:get/get.dart';

import 'controller.dart';

class TextBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TextController>(() => TextController());
  }
}
