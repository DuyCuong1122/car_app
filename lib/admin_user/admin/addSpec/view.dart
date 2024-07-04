import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class AddSpecPage extends GetView<AddSpecController> {
  const AddSpecPage({super.key});

  AppBar buildAppBar() {
    return AppBar(
        title: const Text(
      "Add Spec Car",
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
            child: TextField(
              controller: controller.categoryController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Category',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller.specNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Spec name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller.valueController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Value',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller.unitController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Unit',
              ),
            ),
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  controller.createSpec();
                },
                child: Text('Add Spec for ${controller.state.nameCar.value}'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
