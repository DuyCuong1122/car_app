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
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
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
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
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
                IconButton(
                  onPressed: () => print("button is pressed"),
                  icon: const Icon(Icons.search),
                ),
              ],
            ),
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
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (snapshot.hasData) {
                          final posts = snapshot.data ?? [];
                          if (posts.isEmpty) {
                            return const Center(
                              child: Text("No posts available"),
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
                                  user: post["displayName"] ?? "Unknown",
                                  postId: post["_id"] ?? "No id",
                                  title: post["title"] ?? "No title",
                                  likes: List<String>.from(post["Likes"] ?? []),
                                  imageUrls:
                                  List<String>.from(post["images"] ?? []),
                                  numberOfComments:
                                  post["numberOfComments"] ?? 0,
                                  numberOfLikes: post["numberOfLikes"] ?? 0,
                                  time: formatDate(
                                      post["createdAt"] ?? DateTime.now()),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Text("Unexpected error occurred"),
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
                        height: controller.state.suggestions.isNotEmpty
                            ? 150
                            : 0,
                        child: controller.state.suggestions.isNotEmpty
                            ? ListView.builder(
                          itemCount: controller.state.suggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion =
                            controller.state.suggestions[index];

                            return ListTile(
                              title: Text(
                                  controller.state.suggestions[index]
                                  ['title']),
                              onTap: () {
                                controller.search.clear();
                                controller.state.hashtag.value =
                                suggestion['title'];
                                controller.getSuggestions('');
                                controller.getSuggestions(
                                    suggestion['title']);
                                FocusManager.instance.primaryFocus
                                    ?.unfocus();
                                log('Suggestion selected: ${suggestion['title']}');
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
            isScrollControlled: true, // Allow the bottom sheet to resize dynamically
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Container(
          padding: EdgeInsets.only(bottom: bottomPadding),
          constraints: BoxConstraints(
            maxHeight: availableHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Đăng bài', style: TextStyle(fontSize: 30)),
              const SizedBox(height: 16),
              TextField(
                controller: controller.title,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: "Nhập tiêu đề bài viết...",
                  border: OutlineInputBorder(),
                  label: Text("Tiêu đề"),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller.content,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Nhập nội dung bài viết...",
                  border: OutlineInputBorder(),
                  label: Text("Nội dung"),
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: Obx(() {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.state.selectedImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          controller.state.selectedImages[index]!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  );
                }),
              ),
              ElevatedButton.icon(
                onPressed: controller.pickImages,
                icon: const Icon(Icons.image),
                label: const Text("Chọn hình ảnh"),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  controller.addPost();
                },
                icon: const Icon(Icons.send),
                label: const Text("Đăng bài"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
