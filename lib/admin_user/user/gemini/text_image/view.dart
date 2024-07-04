import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'controller.dart';

class TextWithImagePage extends GetView<TextWithImageController> {
  const TextWithImagePage({super.key});
  @override
  Widget build(BuildContext context) {
    const colorCamera = Colors.black;
    return SafeArea(
      child: Obx(
        () => Column(
          children: [
            const Center(child: Text(
              'Chatbot',
              style: TextStyle(fontSize: 25, color: Colors.black),
            ),),
            Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.textAndImageChat.length,
                padding: const EdgeInsets.only(bottom: 20),
                itemBuilder: (context, index) {
                  return ListTile(
                    isThreeLine: true,
                    leading: CircleAvatar(
                      child: Text(controller.textAndImageChat[index]["role"]
                          .substring(0, 1)),
                    ),
                    title: Text(
                      controller.textAndImageChat[index]["role"],
                      style: const TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      controller.textAndImageChat[index]["text"],
                      style: const TextStyle(fontSize: 15),
                    ),
                    textColor: colorCamera,
                    trailing: controller.textAndImageChat[index]["image"] == ""
                        ? null
                        : Image.file(
                            controller.textAndImageChat[index]["image"],
                            width: 90,
                          ),
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.textController,
                      style: const TextStyle(color: colorCamera),
                      decoration: InputDecoration(
                        hintText: "Đặt câu hỏi",
                        hintStyle:
                            const TextStyle(color: colorCamera, fontSize: 17),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide.none),
                        fillColor: Colors.transparent,
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: colorCamera,
                    ),
                    onPressed: () async {
                      final XFile? image = await controller.picker
                          .pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        controller.fromTextAndImage(
                          query: controller.textController.text,
                          image: File(image.path),
                        );
                      }
                    },
                  ),
                  IconButton(
                    icon: controller.state.loading.value
                        ? const CircularProgressIndicator()
                        : const Icon(
                            Icons.send,
                            color: colorCamera,
                          ),
                    onPressed: () {
                      if (controller.state.imageFile.value == null) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //     const SnackBar(
                        //         content: Text("Please select an image")));
                        controller.fromText(query: controller.textController.text);

                        return;
                      }
                      controller.fromTextAndImage(
                          query: controller.textController.text,
                          image: controller.state.imageFile.value!);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
