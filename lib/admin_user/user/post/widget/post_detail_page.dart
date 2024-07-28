import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:do_an_tot_nghiep_final/common/config/config.dart';
import 'package:do_an_tot_nghiep_final/common/helper/helper_method.dart';
import 'package:do_an_tot_nghiep_final/common/widgets/comment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../controller.dart';
import 'view_image.dart';

class PostDetailPage extends StatefulWidget {
  final String postId;
  final String message;
  final String user;
  final String time;
  final List<String> likes;
  final List<String> imageUrls;

  const PostDetailPage({
    super.key,
    required this.postId,
    required this.message,
    required this.user,
    required this.time,
    required this.likes,
    required this.imageUrls,
  });

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final _controller = Get.find<PostController>();
  int commentCount = 0;
  final TextEditingController commentTextController = TextEditingController();
  bool _isSendButtonVisible = false;

  @override
  void initState() {
    super.initState();
    _controller.state.isLiked.value =
        widget.likes.contains(_controller.state.name.value);

    // Lắng nghe thay đổi trong TextField để cập nhật trạng thái của nút gửi
    commentTextController.addListener(() {
      setState(() {
        _isSendButtonVisible = commentTextController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    // Giải phóng bộ nhớ khi không cần thiết nữa
    commentTextController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> fetchAllComments(String idPost) async {
    try {
      final response = await http.get(Uri.parse(allCommentURL + idPost));
      if (response.statusCode == 200) {
        // Trả về danh sách các bình luận
        return json.decode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load comments : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch comments: $e');
    }
  }

  Stream<List<dynamic>> getComments(String idPost) async* {
    while (true) {
      yield await fetchAllComments(idPost);
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  void toggleLiked() {
    final userFullName = _controller.state.name.value;
    setState(() {
      _controller.state.isLiked.value = !_controller.state.isLiked.value;
      if (_controller.state.isLiked.value) {
        if (!widget.likes.contains(userFullName)) {
          widget.likes.add(userFullName);
        }
      } else {
        widget.likes.remove(userFullName);
      }
    });
  }

  Future<void> addComment(String commentText) async {
    try {
      final response = await http.post(Uri.parse(commentURL), headers: {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
        "Access-Control-Allow-Headers": "Origin, Content-Type, X-Auth-Token",
      }, body: {
        "idPost": widget.postId,
        "idUser": _controller.state.idUser.value,
        "content": commentText
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void viewImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FullScreenImage(imageUrl: imageUrl),
    ));
  }

  Widget buildImageGrid(List<String> imageUrls) {
    if (imageUrls.isEmpty) {
      return Container();
    }

    if (imageUrls.length == 1) {
      return GestureDetector(
        onTap: () => viewImage(context, imageUrls[0]),
        child: Image.network(
          imageUrls[0],
          fit: BoxFit.cover,
        ),
      );
    }

    if (imageUrls.length == 2) {
      return Row(
        children: imageUrls.map((url) {
          return Expanded(
            child: GestureDetector(
              onTap: () => viewImage(context, url),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    return GridView.builder(
      itemCount: imageUrls.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: imageUrls.length == 3 ? 2 : 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => viewImage(context, imageUrls[index]),
          child: Image.network(
            imageUrls[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text("Chi tiết"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Chi tiết bài viết
          Flexible(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.only(top: 15, left: 20, right: 20),
                padding: const EdgeInsets.only(
                    top: 15, left: 15, right: 15, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.person,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.user,
                              style: const TextStyle(
                                  color: Color.fromRGBO(32, 34, 68, 1),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 5),
                            Text(widget.time,
                                style: const TextStyle(
                                    color: Color.fromRGBO(122, 122, 122, 1),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      widget.message,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        overflow: TextOverflow.clip,
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(height: 20),
                    if (widget.imageUrls.isNotEmpty)
                      buildImageGrid(widget.imageUrls),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: StreamBuilder<List<dynamic>>(
                stream: getComments(widget.postId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Chưa có bình luận nào'),
                    );
                  } else if (snapshot.hasData) {
                    final comments = snapshot.data ?? [];
                    if (comments.isEmpty) {
                      return const Center(
                        child: Text("Chưa có bình luận nào"),
                      );
                    }
                    return ListView.builder(
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];

                        return Comment(
                          text: comment["content"],
                          time: formatDate(comment["createdAt"]),
                          user: comment["displayName"],
                          id: comment['_id'],
                          onTap: _controller.deleteComment,
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("Lỗi"),
                    );
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentTextController,
                    decoration: InputDecoration(
                      hintText: 'Viết bình luận...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (_isSendButtonVisible)
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_isSendButtonVisible) {
                        addComment(commentTextController.text);
                        commentTextController.clear();
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
