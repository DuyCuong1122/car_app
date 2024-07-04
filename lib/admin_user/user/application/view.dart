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
        decoration: const BoxDecoration(color: Colors.lightBlue),
        accountName: Obx(()=>Text(
            (controller.state.user.value?.roles?.first == "ROLE_ADMIN"
                ? "Admin "
                : "User") +
                (controller.state.user.value?.displayName ?? '')),),
        accountEmail: Obx(()=>Text(controller.state.user.value?.email ?? "")),
        currentAccountPicture: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 40,
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
                Navigator.pop(context); // Close Drawer after selection
              },
            ),
            // if (controller.state.user.value!.roles!.first == "ROLE_ADMIN")
            ListTile(
              leading: const Icon(Icons.shop),
              title: const Text('Showrooms'),
              onTap: () async {
                // Navigate to Profile page
                await Get.toNamed('/showroom');
                Navigator.pop(context); // Close Drawer after selection
              },
            ),
            ListTile(
              leading: const Icon(Icons.compare),
              title: const Text('So sánh xe'),
              onTap: () async {
                // Navigate to Profile page
                await Get.toNamed('/compareCar');
                Navigator.pop(context); // Close Drawer after selection
              },
            ),
            Obx(() {
              if (controller.state.user.value?.roles?.contains("ROLE_ADMIN") ?? false) {
                return ListTile(
                  leading: const Icon(Icons.compare),
                  title: const Text('Thêm xe'),
                  onTap: () async {
                    // Điều hướng đến trang Thêm xe
                    await Get.toNamed('/add_car');
                    Navigator.pop(context); // Đóng Drawer sau khi chọn
                  },
                );
              } else {
                return const SizedBox.shrink(); // Trả về một Widget trống thay vì null
              }
            }),

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
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMW Car app'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      drawer: buildDrawer(),
      body: buildPageView(),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }
}
