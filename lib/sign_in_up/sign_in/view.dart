import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'index.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  bool _isMoved = false;
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    // Bắt đầu animation sau khi widget được xây dựng hoàn tất.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _isMoved = true;
        _passwordVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    final controller = Get.find<SignInController>();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: screenHeight / 7 - 80 > 0 ? screenHeight / 7 - 80 : 40,
            left: screenWidth / 2 - 80,
            child: Image.asset(
              'assets/icon_1.png', // Đường dẫn tới hình ảnh của bạn
              fit: BoxFit.fitWidth,
              width: 180,
              height: 180,
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            bottom: 0, // Container bắt đầu từ dưới cùng của màn hình
            left: 0,
            right: 0,
            height: _isMoved ? screenHeight * 5 / 7 : 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x73A0C5FF), // Màu trắng phía trên
                    Color.fromARGB(
                        255, 8, 139, 200), // Màu xanh dương nhạt phía dưới
                  ],
                  stops: [0.1, 1.0], // Tỷ lệ gradient
                ),
              ),
              child: SingleChildScrollView(
                // Wrap Column with SingleChildScrollView
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    const Text(
                      "Xin chào",
                      style: TextStyle(fontSize: 35, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextField(
                      controller: controller.usernameController,
                      decoration: InputDecoration(
                        labelText: 'Tên đăng nhập',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: controller.passwordController,
                      obscureText: _passwordVisible,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    SizedBox(
                      width:
                          screenWidth, // Độ rộng của nút bằng chiều rộng của màn hình
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          final controller = Get.find<SignInController>();
                          await controller.handleSignInDB(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent, // Màu nền của nút
                        ),
                        child: const Text('Đăng nhập',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.normal,
                            )),
                      ),

                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Divider(
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            "Hoặc",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width:
                          screenWidth, // Độ rộng của nút bằng chiều rộng của màn hình
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.offAndToNamed("/sign_up");
                          print('Đăng nhập');
                        }, // Màu chữ trắng
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Màu nền của nút
                        ),
                        child: const Text('Đăng ký',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 23,
                              fontFamily: 'RobotoMono',
                              fontWeight: FontWeight.normal,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CarSelectionPage extends StatefulWidget {
  const CarSelectionPage({super.key});

  @override
  _CarSelectionPageState createState() => _CarSelectionPageState();
}

class _CarSelectionPageState extends State<CarSelectionPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..addListener(() {
        if (_controller.isCompleted) {
          _controller.repeat();
        }
        setState(() {});
      });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the animation here since MediaQuery can be safely accessed now
    _animation =
        Tween<double>(begin: -100, end: MediaQuery.of(context).size.width)
            .animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Static background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bg.png'),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x73A0C5FF), // Màu trắng phía trên
                  Color.fromARGB(
                      255, 8, 139, 200), // Màu xanh dương nhạt phía dưới
                ],
                stops: [0.1, 1.0],

                // Tỷ lệ gradient
              ),
            ),
          ),
          // Animated car image
          Positioned(
            left: _animation.value,
            bottom: 15,
            child: Image.asset('assets/car.png', width: 100),
          ),
          // Foreground content
          Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // const SizedBox(height: 5),
                  const Text(
                    'Chọn loại xe',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Wrap(
                    spacing: 10.0, // Khoảng cách giữa các nút
                    runSpacing: 10.0, // Khoảng cách giữa các hàng nút
                    children: [
                      CarButton(
                        name1: 'BMW',
                        name2: 'Toyata',
                        image1: "assets/bmw_icon.png",
                        image2: "assets/toyota.png",
                      ),
                      CarButton(
                        name1: 'Mazda',
                        name2: 'Lexus',
                        image1: "assets/mazda.png",
                        image2: "assets/lexus.png",
                      ),
                      CarButton(
                        name1: 'Porsche',
                        name2: 'Peugeot',
                        image1: "assets/porsche.png",
                        image2: "assets/peugeot.png",
                      )
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CarButton extends StatelessWidget {
  final String name1;
  final String name2;
  final String image1;
  final String image2;

  CarButton(
      {required this.name1,
      required this.name2,
      required this.image1,
      required this.image2});

  @override
  Widget build(BuildContext context) {
    double sizeImage = 70;
    return Column(
      children: [
        // Đặt một cột với hai phần tử Row, mỗi Row chứa hình ảnh và văn bản.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Hình ảnh và văn bản cho xe thứ nhất
            GestureDetector(
              child: Column(
                children: [
                  Image.asset(image1,
                      width: sizeImage,
                      height: sizeImage), // Thêm hình ảnh ở đây
                  Text(name1, style: const TextStyle(fontSize: 28)),
                ],
              ),
              onTap: () => Get.toNamed('/application'),
            ),
            // Hình ảnh và văn bản cho xe thứ hai
            GestureDetector(
              child: Column(
                children: [
                  Image.asset(image2,
                      width: sizeImage,
                      height: sizeImage), // Thêm hình ảnh ở đây
                  Text(name2, style: const TextStyle(fontSize: 28)),
                ],
              ),
              onTap: () => Get.toNamed('/application'),
            ),
          ],
        ),
      ],
    );
  }
}
