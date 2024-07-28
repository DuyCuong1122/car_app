import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

import 'controller.dart';

class ComparePage extends GetView<CompareController> {
  const ComparePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Tạo dòng tiêu đề
    TableRow createHeaderRow() {
      Color backgroundColors = const Color(0x82B3DAFF);
      return TableRow(
        children: [
          TableCell(
            child: Container(
                color: backgroundColors,
                child: const SizedBox(
                    height: 90,
                    width: 200,
                    child: Center(
                      child: Text(
                        "Tiêu chí",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ))),
          ),
          TableCell(
              child: Container(
            color: backgroundColors,
            child: SizedBox(
                height: 90,
                width: 200,
                child: Center(
                  child: Text(
                    controller.state.carsWithSpecs1.first.car.nameCar,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                )),
          )),
          TableCell(
              child: Container(
            color: backgroundColors,
            child: SizedBox(
                height: 90,
                width: 200,
                child: Center(
                  child: Text(
                    controller.state.carsWithSpecs2.first.car.nameCar,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                )),
          )),
        ],
      );
    }

    // Tạo dòng cho các thông số
    TableRow createSpecRow(String specName) {
      final spec1 = controller.state.carsWithSpecs1[0].specs
          .firstWhereOrNull((element) => element.specName == specName);
      final spec2 = controller.state.carsWithSpecs2[0].specs
          .firstWhereOrNull((element) => element.specName == specName);

      return TableRow(
        children: [
          TableCell(
            child: SizedBox(
              height: 70,
              child: Center(
                child: FutureBuilder<String>(
                  future: translationText(
                      specName), // Dịch specName từ tiếng Anh sang tiếng Việt
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data!,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(fontSize: 18),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
          ),
          TableCell(
            child: SizedBox(
              height: 70,
              width: 98,
              child: Center(
                child: Text(
                  spec1 != null && spec1.value != "null"
                      ? (spec1.value.toString() == "Available"
                          ? "V"
                          : spec1.value.toString())
                      : "X",
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          TableCell(
            child: SizedBox(
              height: 70,
              width: 98,
              child: Center(
                child: Text(
                  spec2 != null && spec2.value != "null"
                      ? (spec2.value.toString() == "Available"
                          ? "V"
                          : spec2.value.toString())
                      : "X",
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Kích thước tối đa của màn hình
    final maxSize = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.blue.shade50,
          appBar: AppBar(
            title: const Text(
              'So sánh xe',
              style: TextStyle(
                color: Colors.black,
                fontSize: 28,
              ),
            ),
            centerTitle: true,
            backgroundColor: const Color(0xFF4386B9),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            TextField(
                              controller: controller.car1Controller,
                              decoration: const InputDecoration(
                                labelText: 'Nhập tên xe 1',
                              ),
                            ),
                            if (controller.state.carsWithSpecs1.isNotEmpty)
                              Image.network(
                                controller
                                    .state.carsWithSpecs1.first.car.thumbnail,
                                width: maxSize / 2,
                                height: maxSize / 2,
                                fit: BoxFit.fitWidth,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          children: [
                            TextField(
                              controller: controller.car2Controller,
                              decoration: const InputDecoration(
                                labelText: 'Nhập tên xe 2',
                              ),
                            ),
                            if (controller.state.carsWithSpecs2.isNotEmpty)
                              Image.network(
                                controller
                                    .state.carsWithSpecs2.first.car.thumbnail,
                                width: maxSize / 2,
                                height: maxSize / 2,
                                fit: BoxFit.fitWidth,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      // Ẩn bàn phím khi nhấn nút "So sánh"
                      FocusScope.of(context).unfocus();

                      // Gọi hàm so sánh xe từ controller
                      await controller.getInfo2Cars();
                      (context as Element).markNeedsBuild();
                    },
                    child: const Text(
                      'So sánh',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Hiển thị bảng so sánh
                  if (controller.state.carsWithSpecs1.isNotEmpty &&
                      controller.state.carsWithSpecs2.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.state.commonCategories
                            .expand((category) {
                          final commonSpecNames = controller
                              .state.car1SpecsByCategory[category]!
                              .intersection(controller
                                  .state.car2SpecsByCategory[category]!);
                          return [
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Table(
                                columnWidths: const {
                                  0: FixedColumnWidth(
                                      190), // Chiều rộng cố định cho cột 1
                                  1: FixedColumnWidth(
                                      98), // Chiều rộng cố định cho cột 2
                                  2: FixedColumnWidth(
                                      98), // Chiều rộng cố định cho cột 3
                                },
                                border: TableBorder.all(
                                  width: 1,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                children: [
                                  createHeaderRow(),
                                  ...commonSpecNames.map(
                                      (specName) => createSpecRow(specName)),
                                ],
                              ),
                            ),
                          ];
                        }).toList(),
                      ),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (controller.state.color_car1.isNotEmpty &&
                      controller.state.color_car2.isNotEmpty)
                    Column(
                      children: [
                        const Text(
                          "Màu sắc xe",
                          style: TextStyle(fontSize: 25),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(controller
                                    .state.carsWithSpecs1.first.car.nameCar),
                                SizedBox(
                                  height: maxSize / 3, // Set a fixed height
                                  width: (maxSize / 2 -
                                      10), // Adjust width accordingly
                                  child: PageView.builder(
                                    itemCount:
                                        controller.state.color_car1.length,
                                    itemBuilder: (context, index) {
                                      final image =
                                          controller.state.color_car1[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            image.path,
                                            fit: BoxFit.fitWidth,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          (loadingProgress
                                                                  .expectedTotalBytes ??
                                                              1)
                                                      : null,
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Center(
                                                child: Text('Lỗi tải ảnh'),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(controller
                                    .state.carsWithSpecs2.first.car.nameCar),
                                SizedBox(
                                  height: maxSize / 3, // Set a fixed height
                                  width: (maxSize / 2 -
                                      10), // Adjust width accordingly
                                  child: PageView.builder(
                                    itemCount:
                                        controller.state.color_car2.length,
                                    itemBuilder: (context, index) {
                                      final image =
                                          controller.state.color_car2[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            image.path,
                                            fit: BoxFit.fitWidth,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          (loadingProgress
                                                                  .expectedTotalBytes ??
                                                              1)
                                                      : null,
                                                ),
                                              );
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Center(
                                                child: Text('Lỗi tải ảnh'),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                ],
              ),
            ),
          )),
    );
  }

  Future<String> translationText(String text) async {
    final translator = GoogleTranslator();
    var translation = await translator.translate(text, from: "en", to: "vi");
    return translation.text;
  }
}
