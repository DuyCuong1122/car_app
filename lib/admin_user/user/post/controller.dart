import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../common/config/config.dart';
import '../../../common/entities/user.dart';
import '../../../common/store/user.dart';
import 'state.dart';

class PostController extends GetxController {
  final state = PostState();
  final TextEditingController search = TextEditingController();
  final ImagePicker picker = ImagePicker();
  final TextEditingController content = TextEditingController();
  final TextEditingController title = TextEditingController();

  void getSuggestions(String query) async {
    log(query);
    if (query.isEmpty) {
      state.suggestions.clear();
      return;
    }

    final response = await http.get(Uri.parse(post_title + query));
    log(post_title + query);
    if (response.statusCode == 200) {
      state.suggestions.assignAll(json.decode(response.body));
      log(state.suggestions.toString());
    } else {
      Get.snackbar('Lỗi', 'không tìm thấy gợi ý');
    }
  }

  Future<List<dynamic>> fetchAllPost() async {
    try {
      final response = await http.get(Uri.parse(allPostURL));
      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load posts : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  Future<List<dynamic>> fetchPostByTitle(String title) async {
    try {
      final response = await http.get(Uri.parse(postByTitle + title));
      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      } else {
        throw Exception(
            'Failed to load posts by title: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch posts by title: $e');
    }
  }

  Future<void> addPost() async {
    try {
      String title_post = title.text;
      String content_post = content.text;

      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(postURL))
        ..fields['title'] = title_post
        ..fields['content'] = content_post
        ..fields['idUser'] = state.idUser.value;

      // Add selected images
      for (File? imageFile in state.selectedImages) {
        if (imageFile != null) {
          final imageBytes = await imageFile.readAsBytes();
          final imageName = imageFile.path.split('/').last;
          request.files.add(http.MultipartFile.fromBytes(
            'images', // Make sure this matches the field name expected by your server
            imageBytes,
            filename: imageName,
          ));
        }
      }

      // Send request
      final response = await request.send();

      if (response.statusCode == 201 || response.statusCode == 200) {
        Get.snackbar('Success', 'Đăng bài thành công');
        content.clear();
        title.clear();
        state.selectedImages.clear();
        Get.back();// Navigate back after successful post
      } else {
        final responseBody = await response.stream.bytesToString();
        throw Exception('Failed to add post: ${response.statusCode} - $responseBody');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add post: $e');
      log('Failed to add post: $e');
    }
  }

  Stream<List<dynamic>> getAllPost() async* {
    while (true) {
      yield await fetchAllPost();
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Stream<List<dynamic>> getPostByTitle(String title) async* {
    while (true) {
      yield await fetchPostByTitle(title);
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> pickImages() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      state.selectedImages.value =
          pickedFiles.map((e) => File(e.path)).toList();
    }
  }

  @override
  void onInit() async {
    String profile = await UserDBStore.to.getProfile();
    UserDB userdata = UserDB.fromJson(jsonDecode(profile));
    log(userdata.roles.toString());
    state.name.value = userdata.displayName ?? "N/A";
    state.email.value = userdata.email ?? "N/A";
    state.idUser.value = userdata.id!;
    log(state.email.value.toString());
    log(state.name.value.toString());
    super.onInit();
  }

  @override
  void onClose() {
    search.dispose();
    super.onClose();
  }
}
