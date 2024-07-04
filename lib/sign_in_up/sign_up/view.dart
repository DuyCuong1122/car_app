import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
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
    final controller = Get.find<SignUpController>();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned(
            top: screenHeight / 7 - 80 > 0 ? screenHeight / 7 - 80 : 40,
            left: screenWidth / 2 - 80,
            child: Image.asset(
              'assets/icon_1.png', // Đường dẫn tới hình ảnh của bạn
              fit: BoxFit.fill,
              width: 170,
              height: 170,
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
                      height: 22,
                    ),
                    const Text(
                      "Đăng ký",
                      style: TextStyle(fontSize: 35, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextField(
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
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
                      height: 60,
                    ),
                    SizedBox(
                      width:
                          screenWidth, // Độ rộng của nút bằng chiều rộng của màn hình
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.signUp();
                          print('Đăng ký');
                        }, // Màu chữ trắng
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent, // Màu nền của nút
                        ),
                        child: const Text('Đăng ký',
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
                          Get.offAndToNamed("/sign_in");
                        }, // Màu chữ trắng
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Màu nền của nút
                        ),
                        child: const Text('Đăng nhập',
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
