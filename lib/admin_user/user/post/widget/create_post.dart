// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../../common/widgets/text_field.dart';
// import '../controller.dart';

// /// Flutter code sample for [showModalBottomSheet].

// class BottomSheetExample extends StatelessWidget {
//   BottomSheetExample({super.key});
//   final controller = Get.find<PostController>();
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: SizedBox(
//       height: 150,
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: MyTextField(
//                       controller: controller.textController,
//                       hintText: "Write something on the wall",
//                       obscureText: false,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: controller.pickImages,
//                     icon: const Icon(Icons.photo_library),
//                   ),
//                   IconButton(
//                     onPressed: controller.postMessage,
//                     icon: const Icon(Icons.arrow_circle_up),
//                   ),
//                 ],
//               ),
//             ),
//             ElevatedButton(
//                 child: const Text('Post'),
//                 onPressed: () {
//                   controller.postMessage();
//                   Navigator.pop(context);
//                 }),
//           ],
//         ),
//       ),
//     ));
//   }
// }
