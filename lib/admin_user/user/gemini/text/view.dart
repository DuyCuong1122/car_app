import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class TextPage extends GetView<TextController> {
  const TextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Obx(
      () => Column(
        children: [
          Row(
            children: [
              const SizedBox(width: 20),
              Image.asset('assets/logo.png', height: 100, width: 100),
              const Expanded(child: SizedBox(height: 100)),
              const Text(
                'Chat with Gemini',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              const SizedBox(width: 30),
            ],
          ),
          Expanded(
            child: ListView.builder(
              controller: controller.scrollController,
              itemCount: controller.textChat.length,
              padding: const EdgeInsets.only(bottom: 20),
              itemBuilder: (context, index) {
                return ListTile(
                  isThreeLine: true,
                  leading: CircleAvatar(
                    child: Text(
                        controller.textChat[index]["role"].substring(0, 1)),
                  ),
                  title: Text(controller.textChat[index]["role"]),
                  subtitle: Text(controller.textChat[index]["text"]),
                  textColor: Colors.white,
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
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type a message",
                      hintStyle: const TextStyle(color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: Colors.transparent,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                IconButton(
                  icon: controller.state.loading.value
                      ? const CircularProgressIndicator()
                      : const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                  onPressed: () {
                    controller.fromText(query: controller.textController.text);
                  },
                ),
              ],
            ),
          ),
          // SizedBox(height: 52)
        ],
      ),
    ));
  }
}
