import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class AddCarPage extends GetView<AddCarController> {
  const AddCarPage({super.key});

  AppBar buildAppBar() {
    return AppBar(
      title: const Text(
        "Thêm xe",
        style: TextStyle(
            color: Colors.blue, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      centerTitle: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 3;

    return Scaffold(
      appBar: buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: controller.nameCarController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tên xe',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: controller.releaseController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Năm sản xuất',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: controller.priceController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Giá',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: controller.descriptionController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Miêu tả',
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 8.0),
              //   child: TextField(
              //     controller: controller.showroomController,
              //     decoration: const InputDecoration(
              //       border: OutlineInputBorder(),
              //       labelText: 'Showroom',
              //     ),
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 8.0),
              //   child: TextField(
              //     controller: controller.stateCarController,
              //     decoration: const InputDecoration(
              //       border: OutlineInputBorder(),
              //       labelText: 'State Car',
              //       hintText: 'in production, out of production, etc.',
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Thumbnail'),
                    const SizedBox(width: 20),
                    Obx(() {
                      return controller.state.file.value != null
                          ? Container(
                        constraints: BoxConstraints(
                          maxWidth: imageSize,
                          maxHeight: imageSize,
                        ),
                        child: Image.file(
                          controller.state.file.value!,
                          fit: BoxFit.cover,
                        ),
                      )
                          : const SizedBox(width: 20);
                    }),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        controller.pickFile();
                      },
                      child: const Text('Chọn ảnh'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    controller.createCar();
                  },
                  child: const Text('Thêm xe'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
