import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

import 'controller.dart';

class ComparePage extends GetView<CompareController> {
  const ComparePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tạo dòng tiêu đề
    TableRow createHeaderRow() {
      return const TableRow(
        children: [
          TableCell(
            child: Center(
              child: Text(
                "Xe 1",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TableCell(
            child: Center(
              child: Text(
                "Tiêu chí",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          TableCell(
            child: Center(
              child: Text(
                "Xe 2",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
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
            child: Center(
              child: Text(
                spec1 != null && spec1.value != "null"
                    ? (spec1.value.toString() == "Available" ? "V" : spec1.value.toString())
                    : "X",
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          TableCell(
            child: Center(
              child: FutureBuilder<String>(
                future: translationText(specName), // Dịch specName từ tiếng Anh sang tiếng Việt
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
          TableCell(
            child: Center(
              child: Text(
                spec2 != null && spec2.value != "null"
                    ? (spec2.value.toString() == "Available" ? "V" : spec2.value.toString())
                    : "X",
                softWrap: true,
                overflow: TextOverflow.visible,
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
        appBar: AppBar(
          title: const Text(
            'So sánh xe',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                    onPressed: controller.getInfo2Cars,
                    child: const Text('So sánh'),
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
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0),
                              child: Table(
                                columnWidths: const {
                                  0: FixedColumnWidth(
                                      100), // Chiều rộng cố định cho cột 1
                                  1: FixedColumnWidth(
                                      200), // Chiều rộng cố định cho cột 2
                                  2: FixedColumnWidth(
                                      100), // Chiều rộng cố định cho cột 3
                                },
                                border: TableBorder.all(
                                  width: 1,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                children: [
                                  createHeaderRow(),
                                  ...commonSpecNames
                                      .map((specName) =>
                                      createSpecRow(specName))
                                      .toList(),
                                ],
                              ),
                            ),
                          ];
                        }).toList(),
                      ),
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> translationText(String text) async {
    final translator = GoogleTranslator();
    var translation =
    await translator.translate(text, from: "en", to: "vi");
    return translation.text;
  }
}
