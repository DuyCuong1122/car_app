import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  void showEditDialog(BuildContext context) {
    controller.nameTextField.text = controller.state.name.value;
    controller.phoneTextField.text = controller.state.phone.value;
    controller.addressTextField.text = controller.state.address.value;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chỉnh sửa'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller.nameTextField,
                decoration: const InputDecoration(labelText: 'Tên'),
              ),
              TextField(
                controller: controller.phoneTextField,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
              ),
              TextField(
                controller: controller.addressTextField,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Đóng hộp thoại
            },
            child: const Text('Huỷ'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateProfile();
              controller.state.name.value = controller.nameTextField.text;
              controller.state.address.value = controller.addressTextField.text;
              controller.state.phone.value = controller.phoneTextField.text;
              Get.back(); // Đóng hộp thoại sau khi lưu
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  Widget itemProfile(String title, String subtitle, IconData iconData) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF5BA6E1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 5),
            color: Colors.blue.shade200.withOpacity(.2),
            spreadRadius: 2,
            blurRadius: 10,
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 16),),
        leading: Icon(iconData),
        trailing: Icon(Icons.arrow_forward, color: Colors.grey.shade400),
        tileColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Làm AppBar trong suốt
        backgroundColor: const Color(0xFF4386B9),
        elevation: 0, // Loại bỏ bóng đổ
        title: const Text('Trang cá nhân', style: TextStyle(fontSize: 28),),
        centerTitle: true,
        // Nếu cần, bạn có thể tùy chỉnh màu của văn bản hoặc các biểu tượng trong AppBar
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 25), // Đặt màu văn bản
        iconTheme:
            const IconThemeData(color: Colors.black), // Đặt màu biểu tượng
      ),
      // Thay đổi màu nền của Scaffold
      backgroundColor: Colors.lightBlue.shade50, // Màu xanh nước biển nhạt
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/2023 M3 Sedan.jpg'),
              ),
              const SizedBox(height: 20),
              itemProfile('Tên ', controller.state.name.value, Icons.person),
              const SizedBox(height: 10),
              itemProfile(
                  'Số điện thoại', controller.state.phone.value, Icons.phone),
              const SizedBox(height: 10),
              itemProfile('Địa chỉ', controller.state.address.value,
                  Icons.local_activity),
              const SizedBox(height: 10),
              itemProfile('Email', controller.state.email.value, Icons.mail),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => showEditDialog(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                  ),
                  child: const Text('Chỉnh sửa', style: TextStyle(fontSize: 17, color: Colors.black),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
