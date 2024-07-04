import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../common/config/config.dart';
import 'state.dart';

class AddImageController extends GetxController {
  final AddImageState state = AddImageState();
  final TextEditingController nameCarController = TextEditingController();

  Future<void> addImage() async {
    try {
      String nameCar = nameCarController.text;

      final request = http.MultipartRequest('POST', Uri.parse(imageURL))
        ..fields['nameCar'] = nameCar;

      for (var exterior in state.exteriors) {
        request.files.add(http.MultipartFile.fromBytes(
            'exterior', File(exterior).readAsBytesSync(),
            filename: exterior.split("/").last));
      }

      for (var interior in state.interiors) {
        request.files.add(http.MultipartFile.fromBytes(
            'interior', File(interior).readAsBytesSync(),
            filename: interior.split("/").last));
      }

      for (var color in state.colors) {
        request.files.add(http.MultipartFile.fromBytes(
            'color', File(color).readAsBytesSync(),
            filename: color.split("/").last));
      }
      print('Request URL: ${request.url}');
      print('Request Method: ${request.method}');
      print('Request Headers: ${request.headers}');
      print('Request Fields: ${request.fields}');
      print('Request Files: ${request.files}');

      var response = await request.send();

      if (response.statusCode == 201) {
        print('Image of car added successfully');
        Get.snackbar(
          'Success',
          'Image added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
        );

        // Xóa dữ liệu trên các trường nhập liệu
        nameCarController.clear();
        // thumbnailController.clear();
        state.exteriors.value = [];
        state.interiors.value = [];
        state.colors.value = [];
      } else if (response.statusCode == 400) {
        Get.snackbar(
          'Error',
          'Car with this name is not exists',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        print('Car with this name is not exists');
        throw Exception('Car with this name is not exists');
      } else {
        print('Failed to add image of car');
        Get.snackbar(
          'Error',
          'Failed to add image of car',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
        throw Exception('Failed to add image of car');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> pickImages(var images) async {
    List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();
    images.addAll(pickedFiles.map((file) => file.path).toList());
  }
}


// class _ImagePickerWidgetState extends State<ImagePickerWidget> {
//   List<File> _images = [];

//   Future<void> _pickImages() async {
//     List<XFile> pickedFiles = await ImagePicker().pickMultiImage();
//     setState(() {
//       _images = pickedFiles.map((file) => File(file.path)).toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Image Picker'),
//       ),
//       body: ListView.builder(
//         itemCount: _images.length,
//         itemBuilder: (context, index) {
//           return Image.file(
//             _images[index],
//             width: 200,
//             height: 200,
//             fit: BoxFit.cover,
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _pickImages,
//         tooltip: 'Pick Images',
//         child: const Icon(Icons.add_a_photo),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(const MaterialApp(
//     home: ImagePickerWidget(),
//   ));
// }
