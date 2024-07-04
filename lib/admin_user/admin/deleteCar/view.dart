import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class DeleteCarPage extends GetView<DeleteCarController> {
  const DeleteCarPage({super.key});

  AppBar buildAppBar() {
    return AppBar(
        title: const Text(
      "Add Car",
      style: TextStyle(
          color: Colors.blue, fontSize: 18, fontWeight: FontWeight.w600),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Column(
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                controller.deleteCar();
              },
              child: const Text('Delete Car'),
            ),
          ),
        ],
      ),
    );
  }
}
