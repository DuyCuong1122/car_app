import 'dart:convert';
import 'package:do_an_tot_nghiep_final/admin_user/user/post/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../common/config/config.dart';
import '../../../../common/entities/user.dart';
import '../../../../common/store/user.dart';
import '../../../../common/widgets/comment_button.dart';
import '../../../../common/widgets/like_button.dart';
import 'post_detail_page.dart';
import 'view_image.dart';

class WallPost extends StatefulWidget {
  final String content;
  final String title;
  final String user;
  final String postId;
  final String time;
  final List<String> likes;
  final List<String> imageUrls;
  final int numberOfComments;
  final int numberOfLikes;
  final String idUser;

  const WallPost({
    super.key,
    required this.content,
    required this.title,
    required this.user,
    required this.postId,
    required this.likes,
    required this.time,
    required this.imageUrls,
    required this.numberOfComments,
    required this.numberOfLikes,
    required this.idUser,
  });

  @override
  _WallPostState createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {
  late UserDB user;
  int numberOfLikes = 0;
  final controller = Get.find<PostController>();
  @override
  void initState() {
    super.initState();
    _initializeUser();
    numberOfLikes = widget.numberOfLikes; // Initialize the likes count
  }

  Future<void> _initializeUser() async {
    final profileJson = await UserDBStore.to.getProfile();
    user = UserDB.fromJson(jsonDecode(profileJson));
    await checkLikedStatus();
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

  Future<void> checkLikedStatus() async {
    final body = json.encode({
      'idPost': widget.postId,
      'idUser': user.id,
    });

    final response = await http.post(
      Uri.parse(checkLikeURL),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
        controller.state.isLiked.value = data["isLiked"] == "true";
    } else {
      throw Exception('Failed to check like status');
    }
  }

  Future<void> deletePost(String id) async {
    final response = await http.delete(
      Uri.parse(deletePostURL + id),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 204) {
      print('Thành công');
    } else {
      throw Exception('Failed to delete post');
    }
  }

  Future<void> toggleLiked() async {
    // Optimistic UI update

      controller.state.isLiked.value = !controller.state.isLiked.value;
      numberOfLikes = controller.state.isLiked.value ? numberOfLikes + 1 : numberOfLikes - 1;

    final body = json.encode({
      'idPost': widget.postId,
      'idUser': user.id,
    });

    final response = await http.post(
      Uri.parse(likeURL),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        // Nếu phản hồi thành công, không cần làm gì thêm vì giao diện đã cập nhật
      } else {
        // Nếu phản hồi không thành công, hoàn tác lại trạng thái "like"
        controller.state.isLiked.value = !controller.state.isLiked.value;
        numberOfLikes = controller.state.isLiked.value ? numberOfLikes + 1 : numberOfLikes - 1;

      }
    } else {
      // Nếu phản hồi không thành công, hoàn tác lại trạng thái "like"

        controller.state.isLiked.value = !controller.state.isLiked.value;
        numberOfLikes = controller.state.isLiked.value ? numberOfLikes + 1 : numberOfLikes - 1;

    }
  }

  void viewImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => FullScreenImage(imageUrl: imageUrl),
    ));
  }

  void navigateToPostDetail() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PostDetailPage(
        postId: widget.postId,
        message: widget.content,
        user: widget.user,
        time: widget.time,
        likes: widget.likes,
        imageUrls: widget.imageUrls,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: navigateToPostDetail,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfo(),
            const SizedBox(height: 15),
            _buildContent(),
            if (widget.imageUrls.isNotEmpty) buildImageGrid(widget.imageUrls),
            const SizedBox(height: 20),
            _buildInteractionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.user,
              style: const TextStyle(
                color: Color.fromRGBO(32, 34, 68, 1),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.time,
              style: const TextStyle(
                color: Color.fromRGBO(122, 122, 122, 1),
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
            // const Expanded(child: SizedBox()),

          ],
        ),
        const Expanded(child: SizedBox()),
        ElevatedButton.icon(
            onPressed: () => deletePost(widget.postId),
            label: const Text('Xóa'),
            icon: const Icon(Icons.delete))
      ],
    );
  }

  Widget _buildContent() {
    return Text(
      widget.content,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: Colors.black,
      ),
    );
  }

  Widget _buildImageGallery() {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              viewImage(context, widget.imageUrls[index]);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(widget.imageUrls[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInteractionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LikeButton(isLiked: widget.likes.contains(controller.state.idUser.value), onTap: toggleLiked),
              const SizedBox(width: 5),
              Text(
                numberOfLikes.toString(),
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommentButton(onTap: navigateToPostDetail),
              const SizedBox(width: 5),
              const Text("Bình luận"),
              const SizedBox(width: 5),
              Text(
                widget.numberOfComments.toString(),
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
