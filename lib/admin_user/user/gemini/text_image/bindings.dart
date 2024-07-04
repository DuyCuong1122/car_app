import 'package:get/get.dart';

import 'controller.dart';

class TextWithImageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TextWithImageController>(() => TextWithImageController());
  }
}
