import 'dart:io';

import 'package:get/get.dart';

class TextWithImageState {
  var loading = false.obs;
  var imageFile = Rx<File?>(null);
}
