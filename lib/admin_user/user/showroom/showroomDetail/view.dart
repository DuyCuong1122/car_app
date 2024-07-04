import 'package:do_an_tot_nghiep_final/admin_user/user/showroom/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShowroomDetailPage extends StatelessWidget {
  ShowroomDetailPage({super.key});
  final controller = Get.find<ShowroomController>();
  final dynamic data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final String showroomName = data['name'] ?? 'Unknown Showroom';

    return Scaffold(
      appBar: AppBar(
        title: Text(showroomName),
      ),
      body: StreamBuilder<List<dynamic>>(
        stream: controller.getAllCarInShowroom(showroomName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            ); // Hiển thị khi đang tải dữ liệu
          } else if (snapshot.hasError) {
            return Text('Lỗi: ${snapshot.error}'); // Hiển thị khi có lỗi
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('Showroom không có sẵn xe'); // Hiển thị khi không có dữ liệu
          } else {
            // Hiển thị GridView khi có dữ liệu
            final cars = snapshot.data!;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Số cột trong lưới
                childAspectRatio: 1.0, // Tỉ lệ khung hình của các ô
                crossAxisSpacing: 10, // Khoảng cách ngang giữa các ô
                mainAxisSpacing: 10, // Khoảng cách dọc giữa các ô
              ),
              padding: const EdgeInsets.all(10),
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];
                return GestureDetector(
                  onTap: () {
                    // Hành động khi nhấn vào xe
                    // Ví dụ: Điều hướng đến trang chi tiết xe
                  },
                  child: Card(
                    elevation: 5.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(car['image_path']),
                        Text(
                          car['name'],
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
