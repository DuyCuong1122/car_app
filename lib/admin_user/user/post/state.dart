import 'dart:io';

import 'package:get/get.dart';

class PostState {
  final RxList<File?> selectedImages = <File?>[].obs;
  var suggestions = <dynamic>[].obs;
  RxString nameSuggestion = ''.obs;
  RxString hashtag = ''.obs;
  final RxBool isLiked = false.obs;
  RxString name = "".obs;
  RxString email = "".obs;
  RxString idUser = "".obs;
}
