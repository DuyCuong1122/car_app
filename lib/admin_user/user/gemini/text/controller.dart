import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../../common/config/config.dart';
import 'state.dart';

class TextController extends GetxController {
  TextController();

  final TextState state = TextState();

  final List textChat = [];
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  // Create Gemini Instance
  final GenerativeModel model =
      GenerativeModel(model: 'gemini-1.0-pro-latest', apiKey: API_key);

  // Text only input
  void fromText({required String query}) {
    state.loading.value = true;
    textChat.add({"role": "User", "text": query});
    textController.clear();
    scrollToTheEnd();

    final content = [Content.text(query)];
    model.generateContent(content).then((value) {
      textChat.add({"role": "Gemini", "text": value.text});
      state.loading.value = false;
      scrollToTheEnd();
      update();
    }).onError((error, stackTrace) {
      textChat.add({"role": "Gemini", "text": error.toString()});
      state.loading.value = false;
      scrollToTheEnd();
      update();
    });
  }

  void scrollToTheEnd() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }
}
