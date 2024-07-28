import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';

import '../../../common/helper/helper_method.dart';
import 'controller.dart';
import 'widget/wall_post.dart';

class PostPage extends GetView<PostController> {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Debouncer debouncer =
    Debouncer(delay: const Duration(milliseconds: 500));

    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    color: const Color(0xFF5BA6E1),
                    child: TextFormField(
                      controller: controller.search,
                      onChanged: (query) {
                        debouncer.call(() {
                          controller.state.nameSuggestion.value =
                              controller.search.text.toString();
                          controller.getSuggestions(query);
                          log(controller.state.nameSuggestion.value);
                        });
                      },
                      autofocus: false,
                      obscureText: false,
                      decoration: InputDecoration(
                        labelText: 'Hashtag',
                        labelStyle: const TextStyle(fontSize: 20),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
                        suffixIcon: controller.search.text.isNotEmpty
                            ? InkWell(
                          onTap: () {
                            controller.search.clear();
                            controller.getSuggestions('');
                          },
                          child: const Icon(
                            Icons.clear,
                            size: 15,
                            color: Colors.black,
                          ),
                        )
                            : null,
                      ),
                    ),
                  ),
                ),
                // IconButton(
                //   onPressed: () => print("button is pressed"),
                //   icon: const Icon(Icons.search),
                // ),
              ],
            ),
            Obx(() {
              return controller.state.hashtag.value.isNotEmpty
                  ? Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '# ${controller.state.hashtag.value}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.state.hashtag.value = '';
                        controller.state.suggestions.clear();
                      },
                      icon: const Icon(Icons.clear),
                    ),
                  ],
                ),
              )
                  : const SizedBox.shrink();
            }),
            Expanded(
              child: Stack(
                children: [
                  Obx(
                        () => StreamBuilder<List<dynamic>>(
                      stream: controller.state.nameSuggestion.value.isNotEmpty
                          ? controller.getPostByTitle(
                          controller.state.nameSuggestion.value.toString())
                          : controller.getAllPost(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text("Không có bài đăng nào!!!"),
                          );
                        } else if (snapshot.hasData) {
                          final posts = snapshot.data ?? [];
                          if (posts.isEmpty) {
                            return const Center(
                              child: Text("Không có bài đăng nào"),
                            );
                          }

                          return ListView.builder(
                            itemCount: posts.length,
                            itemBuilder: (context, index) {
                              final post = posts[index];

                              return GestureDetector(
                                onTap: () {},
                                child: WallPost(
                                  content: post["content"] ?? "No content",
                                  user: post["displayName"] == "N/A" ? post['username'] : post["displayName"],
                                  postId: post["_id"] ?? "No id",
                                  title: post["title"] ?? "No title",
                                  likes: List<String>.from(post["likes"] ?? []),
                                  imageUrls:
                                  List<String>.from(post["images"] ?? []),
                                  numberOfComments:
                                  post["numberOfComments"] ?? 0,
                                  numberOfLikes: post["numberOfLikes"] ?? 0,
                                  time: formatDate(
                                      post["createdAt"] ?? DateTime.now().toString()),
                                  idUser: post["idUser"]?? "",
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Text("Lỗi không mong muốn"),
                          );
                        }
                      },
                    ),
                  ),
                  Obx(() {
                    return Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: Colors.white,
                        height:
                        controller.state.suggestions.isNotEmpty ? 150 : 0,
                        child: controller.state.suggestions.isNotEmpty
                            ? ListView.builder(
                          itemCount: controller.state.suggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion =
                            controller.state.suggestions[index]['title'];

                            return ListTile(
                              title: Text(suggestion),
                              onTap: () {
                                controller.search.clear();
                                controller.state.hashtag.value =
                                    suggestion;
                                controller.state.suggestions.clear();
                                controller.getSuggestions('');
                                FocusManager.instance.primaryFocus
                                    ?.unfocus();
                                log('Suggestion selected: $suggestion');
                              },
                            );
                          },
                        )
                            : (controller.state.hashtag.value.isNotEmpty
                            ? SizedBox(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("Hashtag"),
                              Text(controller.state.hashtag.value
                                  .toString())
                            ],
                          ),
                        )
                            : const SizedBox.shrink()),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled:
            true, // Allow the bottom sheet to resize dynamically
            barrierColor: Colors.lightBlueAccent,
            backgroundColor: Colors.white,
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            builder: (context) => bottomSheetExample(context),
          );
        },
        child: const Icon(Icons.post_add_rounded),
      ),
    );
  }

  Widget bottomSheetExample(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final availableHeight = MediaQuery.of(context).size.height - bottomPadding;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade50,
        body: Container(
          padding: EdgeInsets.only(bottom: bottomPadding, left: 8, right: 8, top: 8),
          constraints: BoxConstraints(
            maxHeight: availableHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 25,),
              const Center(child: Text('Đăng bài', style: TextStyle(fontSize: 30,),),),
              const SizedBox(height: 25),
              Expanded(
                child: ListView(
                  children: [
                    TextField(
                      controller: controller.title,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: "Nhập tiêu đề bài viết...",
                        hintStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(),
                        label: Text("Tiêu đề", style: TextStyle(fontSize: 20),),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: controller.content,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText: "Nhập nội dung bài viết...",
                        hintStyle: TextStyle(fontSize: 18),
                        border: OutlineInputBorder(),
                        label: Text("Nội dung",style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 220,
                      child: Obx(() {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.state.selectedImages.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                controller.state.selectedImages[index]!,
                                width: 200,
                                height: 200,
                                fit: BoxFit.fitWidth,
                              ),
                            );
                          },
                        );
                      }),
                    ),
                    Center(
                      child: Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: controller.pickImages,
                            icon: const Icon(Icons.image),
                            label: const Text("Chọn hình ảnh", style: TextStyle(fontSize: 18),),
                          ),
                          const SizedBox(height: 15,),
                          ElevatedButton.icon(
                            onPressed: () async {
                              await controller.addPost();
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.send),
                            label: const Text("Đăng bài",style: TextStyle(fontSize: 18),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
