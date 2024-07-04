import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class AddImagePage extends GetView<AddImageController> {
  const AddImagePage({super.key});

  AppBar buildAppBar() {
    return AppBar(
      title: const Text(
        "Add Image ",
        style: TextStyle(
          color: Colors.blue,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller.nameCarController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name Car',
                ),
              ),
            ),
            const Text('Exteriors'),
            SizedBox(
              height: 240, // Đặt chiều cao lớn hơn để chứa nhiều hình ảnh
              child: Obx(
                () => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.state.exteriors.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      File(controller.state.exteriors[index]),
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  controller.pickImages(controller.state.exteriors),
              child: const Text("Add exterior image"),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Interiors'),
            SizedBox(
              height: 240, // Đặt chiều cao lớn hơn để chứa nhiều hình ảnh
              child: Obx(
                () => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.state.interiors.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      File(controller.state.interiors[index]),
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  controller.pickImages(controller.state.interiors),
              child: const Text("Add interior image"),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Colors'),
            SizedBox(
              height: 240, // Đặt chiều cao lớn hơn để chứa nhiều hình ảnh
              child: Obx(
                () => ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.state.colors.length,
                  itemBuilder: (context, index) {
                    return Image.file(
                      File(controller.state.colors[index]),
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => controller.pickImages(controller.state.colors),
              child: const Text("Add color image"),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  controller.addImage();
                },
                child: const Text('Add Image'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
