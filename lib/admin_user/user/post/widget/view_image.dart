import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _downloadImage(context, imageUrl),
          ),
        ],
      ),
      body: Center(
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
      ),
    );
  }

  Future<void> _downloadImage(BuildContext context, String imageUrl) async {
    // Check and request storage permission
    if (await _requestPermission(Permission.storage)) {
      try {
        var dio = Dio();
        var response = await dio.get(imageUrl, options: Options(responseType: ResponseType.bytes));
        var documentDirectory = await getExternalStorageDirectory();
        var filePath = '${documentDirectory!.path}/downloaded_image_${DateTime.now().millisecondsSinceEpoch}.jpg';
        var file = File(filePath);
        await file.writeAsBytes(response.data);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image downloaded to ${file.path}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download image: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage permission not granted')),
      );
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      return result == PermissionStatus.granted;
    }
  }
}
