import 'package:do_an_tot_nghiep_final/admin_user/user/gemini/text_image/index.dart';
import 'package:do_an_tot_nghiep_final/common/store/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/values/colors.dart';
import '../home_page/view.dart';
import '../post/view.dart';
import 'controller.dart';

class ApplicationPage extends GetView<ApplicationController> {
  ApplicationPage({super.key});
  final userInfo = Get.find<UserDBStore>();

  @override
  Widget build(BuildContext context) {
    Widget buildPageView() {
      return PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        onPageChanged: controller.handPageChanged,
        children: const [
          HomePage(),
          PostPage(),
          TextWithImagePage(),
        ],
      );
    }

    Widget buildBottomNavigationBar() {
      return Obx(() => BottomNavigationBar(
            items: controller.bottomTabs,
            currentIndex: controller.state.page,
            type: BottomNavigationBarType.fixed,
            onTap: controller.handleNavBarTap,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            unselectedItemColor: AppColors.tabBarElement,
            selectedItemColor: AppColors.thirdElementText,
          ));
    }

    Widget buildDrawerHeader() {
      return UserAccountsDrawerHeader(
        decoration: const BoxDecoration(color: Color(0xFF499CE5)),
        accountName: Obx(
          () => Text((controller.state.user.value?.roles?.first == "ROLE_ADMIN"
                  ? "Admin "
                  : "User") +
              (controller.state.user.value?.displayName ?? '')),
        ),
        accountEmail: Obx(() => Text(controller.state.user.value?.email ?? "")),
        currentAccountPicture: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 50,
              color: Colors.lightBlueAccent,
            )),
      );
    }

    Widget buildDrawer() {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            buildDrawerHeader(),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Trang chủ'),
              onTap: () {
                // Navigate to HomePage
                controller.pageController.jumpToPage(0);
                Navigator.pop(context); // Close Drawer after selection
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Trang cá nhân'),
              onTap: () async {
                // Navigate to Profile page
                await Get.toNamed('/profile');
                // Navigator.pop(context); // Close Drawer after selection
              },
            ),
            // if (controller.state.user.value!.roles!.first == "ROLE_ADMIN")
            ListTile(
              leading: const Icon(Icons.shop),
              title: const Text('Showrooms'),
              onTap: () async {
                // Navigate to Profile page
                await Get.toNamed('/showroom');
                // Navigator.pop(context); // Close Drawer after selection
              },
            ),
            ListTile(
              leading: const Icon(Icons.compare),
              title: const Text('So sánh xe'),
              onTap: () async {
                // Navigate to Profile page
                await Get.toNamed('/compareCar');
                // Navigator.pop(context); // Close Drawer after selection
              },
            ),
            Obx(() {
              if (controller.state.user.value?.roles?.contains("ROLE_ADMIN") ??
                  false) {
                return ListTile(
                  leading: const Icon(Icons.compare),
                  title: const Text('Chức năng admin'),
                  onTap: () async {
                    // Điều hướng đến trang Thêm xe
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GradientButtonPage()));
                    // Navigator.pop(context); // Đóng Drawer sau khi chọn
                  },
                );
              } else {
                return const SizedBox
                    .shrink(); // Trả về một Widget trống thay vì null
              }
            }),
            ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text('Hỗ trợ khách hàng'),
              onTap: () async {
                // Navigate to Profile page
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SupportCustomer()));
                // Navigator.pop(context); // Close Drawer after selection
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Đăng xuất'),
              onTap: () async {
                // Show a loading dialog while logging out
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );

                // Perform logout
                await userInfo.onLogout();

                // Navigate to sign-in screen and clear the navigation stack
                await Get.offAndToNamed('/sign_in');

                // Close the Drawer after selection
                // Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BMW',
          style: TextStyle(fontSize: 28),
        ),
        backgroundColor: const Color(0xFF4386B9),
        elevation: 0,
        centerTitle: true,
      ),
      drawer: buildDrawer(),
      body: buildPageView(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}

class SupportCustomer extends StatelessWidget {
  const SupportCustomer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue.shade100,
        appBar: AppBar(
          title: const Text(
            "Hỗ trợ khách hàng",
            style: TextStyle(fontSize: 28),
          ),
          backgroundColor: const Color(0xFF4386B9),
          centerTitle: true,
        ),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                "Nếu khách hàng gặp vấn đề khó khăn, thì xin liên hệ với chúng tôi",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Người hỗ trợ : Lê Duy Cường",
                  style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 20,
              ),
              Text("Liên hệ qua số điện thoại : 0339269975",
                  style: TextStyle(fontSize: 20)),
              SizedBox(
                height: 20,
              ),
              Text("Liên hệ qua gmail : leduycuong726@gmail.com",
                  style: TextStyle(fontSize: 20))
            ],
          ),
        ));
  }
}


class GradientButtonPage extends StatelessWidget {
  const GradientButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chức năng của admin', style: TextStyle(fontSize: 28),),
        centerTitle: true,
        backgroundColor: const Color(0xFF4386B9), // Loại bỏ màu nền của AppBar
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x73A0C5FF), // Màu trắng phía trên
              Color.fromARGB(255, 8, 139, 200), // Màu xanh dương nhạt phía dưới
            ],
            stops: [0.1, 1.0], // Tỷ lệ gradient
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Đặt kích thước cho các nút
              SizedBox(
                width: 270, // Chiều rộng cố định cho các nút
                child: RoundedButton(text: 'Thêm xe', page: '/add_car'),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 270,
                child: RoundedButton(text: 'Thêm ảnh xe', page: '/add_image'),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 270,
                child: RoundedButton(text: 'Thêm thông số kỹ thuật', page: '/add_spec'),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final String page;
  const RoundedButton({super.key, required this.text, required this.page});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Get.toNamed(page),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Bo góc
        ),
        backgroundColor: Colors.blueAccent, // Màu nền cho nút bấm
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}