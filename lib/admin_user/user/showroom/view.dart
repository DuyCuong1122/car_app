import 'package:do_an_tot_nghiep_final/admin_user/user/showroom/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'showroomDetail/view.dart';

class ShowroomPage extends StatelessWidget {
  final ShowroomController controller = Get.put(ShowroomController());

  ShowroomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text('Showroom', style: TextStyle(fontSize: 28),),
        centerTitle: true,
        backgroundColor: const Color(0xFF4386B9),
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: controller.getAllShowroom(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Hiển thị khi đang tải dữ liệu
          } else if (snapshot.hasError) {
            return Text('Lỗi: ${snapshot.error}'); // Hiển thị khi có lỗi
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('Showroom không có sẵn'); // Hiển thị khi không có dữ liệu
          } else {
            // Hiển thị GridView khi có dữ liệu
            final showrooms = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Số cột trong lưới
                childAspectRatio: 1.0, // Tỉ lệ khung hình của các ô
                crossAxisSpacing: 10, // Khoảng cách ngang giữa các ô
                mainAxisSpacing: 10, // Khoảng cách dọc giữa các ô
              ),
              padding: const EdgeInsets.all(10),
              itemCount: showrooms.length,
              itemBuilder: (context, index) {
                final showroom = showrooms[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => ShowroomDetailPage(), arguments: showroom);
                  },
                  child: Card(
                    elevation: 5.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(showroom['path']),
                        Text(
                          showroom['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
