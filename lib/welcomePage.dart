import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Container(
      // Áp dụng nền gradient
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white, // Màu trắng phía trên
            Colors.lightBlue, // Màu xanh dương nhạt phía dưới
          ],
          stops: [0.1, 1.0], // Tỷ lệ gradient
        ),
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Image.asset(
                  'assets/hehe.png',
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 50),
              const Text(
                'Xin chào!',
                style: TextStyle(
                    fontSize: 34, color: Colors.black), // Màu chữ trắng
              ),
              const Expanded(
                  child: Text(
                "Chào mừng đến với ứng dụng xe BMW",
                style: TextStyle(fontSize: 22, color: Colors.black),
              )),
              const SizedBox(height: 30),
              SizedBox(
                width:
                    screenWidth, // Độ rộng của nút bằng chiều rộng của màn hình
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAndToNamed('/sign_in');
                    print('Đăng nhập');
                  }, // Màu chữ trắng
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent, // Màu nền của nút
                  ),
                  child: const Text('Đăng nhập',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'RobotoMono',
                        fontWeight: FontWeight.normal,
                      )),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width:
                    screenWidth, // Độ rộng của nút bằng chiều rộng của màn hình
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAndToNamed('/sign_up');
                    print('Đăng ký');
                  }, // Màu chữ trắng
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Màu nền của nút
                  ),
                  child: const Text('Đăng ký',
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 20,
                          fontFamily: 'RobotoMono',
                          fontWeight: FontWeight.normal)),
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    ));
  }
}
