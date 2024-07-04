import 'package:do_an_tot_nghiep_final/admin_user/profile/controller.dart';
import 'package:do_an_tot_nghiep_final/admin_user/user/gemini/text_image/controller.dart';
import 'package:get/get.dart';

import '../home_page/controller.dart';
import '../post/controller.dart';
import 'index.dart';

class ApplicationBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApplicationController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => PostController());
    Get.lazyPut(()=> ProfileController());
    Get.lazyPut(()=> TextWithImageController());
  }
}
