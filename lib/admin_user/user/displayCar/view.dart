import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class DisplayCarPage extends GetView<DisplayCarController> {
  const DisplayCarPage({super.key});
  AppBar buildAppBar() {
    return AppBar(
      title: const Text(
        "Car",
        style: TextStyle(
            color: Colors.blue, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      // actions: [
      //   IconButton(
      //       onPressed: () => Get.toNamed('/addCar'),
      //       icon: const Icon(Icons.add))
      // ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Car",
            style: TextStyle(
                color: Colors.blue, fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        body: Obx(() => GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns
                mainAxisSpacing: 10.0, // Spacing between rows
                crossAxisSpacing: 10.0, // Spacing between columns
              ),
              itemCount: controller.state.cars.length,
              itemBuilder: (context, index) {
                final car = controller.state.cars[index];
                return InkWell(
                    onTap: () => Get.toNamed("/detail", arguments: car),
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          // Image.network(
                          //   car.thumbnail,
                          //   scale: 1.0,
                          //   width: double.infinity,
                          //   height: 300,
                          //   errorBuilder: (context, error, stackTrace) {
                          //     return const Text('Failed to load image');
                          //   },
                          // ),
                          Text(car.nameCar),
                        ],
                      ),
                    )));
              },
            )));
  }
}
