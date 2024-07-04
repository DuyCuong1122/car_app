import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../common/entities/user.dart';
import '../../../common/store/user.dart';
import '../../../common/values/colors.dart';
import 'index.dart';

import 'package:get/get.dart';

class ApplicationController extends GetxController {
  final state = ApplicationState();
  ApplicationController();

  late final List<String> tabTitles;
  late final PageController pageController;
  late final List<BottomNavigationBarItem> bottomTabs;

  void handPageChanged(int index) {
    state.page = index;
  }

  void handleNavBarTap(int index) {
    pageController.jumpToPage(index);
  }

  @override
  void onInit() async {
    super.onInit();
    tabTitles = ['Trang chủ', 'Cộng đồng', 'Chatbot'];
    bottomTabs = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
          icon: Icon(Icons.home, color: Colors.black),
          activeIcon: Icon(
            Icons.home,
            color: AppColors.secondaryElementText,
          ),
          label: 'Trang chủ',
          backgroundColor: AppColors.primaryBackground),
      const BottomNavigationBarItem(
          icon: Icon(Icons.people, color: AppColors.thirdElementText),
          activeIcon: Icon(
            Icons.people,
            color: AppColors.secondaryElementText,
          ),
          label: 'Cộng đồng',
          backgroundColor: AppColors.primaryBackground),
      const BottomNavigationBarItem(
          icon: Icon(Icons.chat, color: AppColors.thirdElementText),
          activeIcon: Icon(
            Icons.chat,
            color: AppColors.secondaryElementText,
          ),
          label: 'Chatbot',
          backgroundColor: AppColors.primaryBackground),
    ];
    pageController = PageController(initialPage: state.page);
    String profile = await UserDBStore.to.getProfile();
    state.user.value = UserDB.fromJson(jsonDecode(profile));
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
