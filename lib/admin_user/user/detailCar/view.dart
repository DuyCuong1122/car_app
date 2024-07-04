import 'package:do_an_tot_nghiep_final/common/entities/entities.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/entities/info.dart';
import 'controller.dart';
import 'package:translator/translator.dart';

// Example API key, replace with your actual Google Cloud Translation API key.

class DetailCarPage extends GetView<DetailCarController> {
  const DetailCarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.state.detail.isNotEmpty
                ? controller.state.detail.first.car.nameCar
                : "Chi tiết xe",
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () {
          if (controller.state.detail.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final detail = controller.state.detail.first;

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Center(
                  //   child: Text(
                  //     detail.car.nameCar,
                  //     style: const TextStyle(
                  //         fontSize: 30, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  if (controller.state.image.isNotEmpty)
                    SizedBox(
                      height: 300,
                      child: PageView.builder(
                        itemCount: controller.state.image.length,
                        itemBuilder: (context, index) {
                          final image = controller.state.image[index];
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                image.path,
                                fit: BoxFit.fitWidth,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Text('Failed to load image'),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  if (controller.state.image.isEmpty)
                    const Center(child: CircularProgressIndicator()),
                  Text("Năm phát hành: ${detail.car.year}"),
                  Text("Giá: ${detail.car.price} tỷ VND"),
                  Text("Mô tả: ${detail.car.description}"),
                  if (controller.state.detail.first.infos.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Điểm mạnh',
                          style: TextStyle(fontSize: 20),
                        ),
                        ..._buildTranslatedTexts(detail.infos, 'Pros'),
                      ],
                    ),
                  if (controller.state.detail.first.infos.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Điểm yếu',
                          style: TextStyle(fontSize: 20),
                        ),
                        ..._buildTranslatedTexts(detail.infos, 'Cons'),
                      ],
                    ),
                  if (controller.state.detail.first.infos.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Điểm mới',
                          style: TextStyle(fontSize: 20),
                        ),
                        ..._buildTranslatedTexts(detail.infos, "What's New?"),
                      ],
                    ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Thông số kỹ thuật",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Kích thước, trọng lượng và công suất",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  _buildFilteredDataTable(
                      detail.specs, 'Dimensions, Weights & Capacities'),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Ngoại thất',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  _buildFilteredDataTable(detail.specs, 'Exterior'),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Nhiên liệu tiêu hao',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  _buildFilteredDataTable(detail.specs, 'Fuel Economy'),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Máy móc',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  _buildFilteredDataTable(detail.specs, 'Mechanical'),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Hiệu suất',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  _buildFilteredDataTable(detail.specs, 'Performance'),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Tiện ích',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  _buildFilteredDataTable(
                      detail.specs, 'Comfort & Convenience'),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Giải trí',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  _buildFilteredDataTable(detail.specs, 'Entertainment'),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Nội thất',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  _buildFilteredDataTable(detail.specs, 'Interior'),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Ghế ngồi',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  _buildFilteredDataTable(detail.specs, 'Seating'),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('An toàn',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  _buildFilteredDataTable(detail.specs, 'Security'),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text('Công nghệ',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  _buildFilteredDataTable(detail.specs, 'Technology'),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Đánh giá xe",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Chuyên gia:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal)),
                        Row(
                          children: [
                            Text(controller.state.detail.first.rating.expert),
                            const SizedBox(
                              width: 10,
                            ),
                            _buildStarRating(
                                controller.state.detail.first.rating.expert),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Khách hàng:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal)),
                        Row(
                          children: [
                            Text(controller.state.detail.first.rating.user),
                            const SizedBox(
                              width: 10,
                            ),
                            _buildStarRating(
                                controller.state.detail.first.rating.user),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          Colors.blue), // Nền xanh
                    ),
                    child: const Text(
                      "So sánh xe khác",
                      style: TextStyle(color: Colors.white), // Màu chữ trắng
                    ),
                  ),)
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStarRating(String rating) {
    double parsedRating = double.tryParse(rating) ?? 0.0;
    int fullStars = parsedRating.floor();
    bool hasHalfStar = parsedRating - fullStars >= 0.5;

    List<Widget> stars = [];
    // Add full yellow stars
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.yellow, size: 20));
    }
    // Add half yellow star if necessary
    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.yellow, size: 20));
    }
    // Add remaining white stars
    int remainingStars = 5 - stars.length;
    for (int i = 0; i < remainingStars; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.yellow, size: 20));
    }

    return Row(
      children: stars,
    );
  }

  Future<String> translationText(String text) async {
    final translator = GoogleTranslator();
    var translation = await translator.translate(text, from: "en", to: "vi");
    return translation.text;
  }

  List<Widget> _buildTranslatedTexts(List<Info> infos, String title) {
    final translator = GoogleTranslator();
    return infos.where((info) => info.title == title).map((info) {
      return FutureBuilder<Translation>(
          future: translator.translate(info.body,
              from: 'en', to: 'vi'), // Translate to Vietnamese
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              // Sử dụng snapshot.data!.text để lấy giá trị dịch từ đối tượng Translation
              return Text(snapshot.data!.text);
            } else {
              return const Text('Translation not available');
            }
          });
    }).toList();
  }

  Widget _buildFilteredDataTable(List<Spec> specs, String category) {
    final filteredSpecs =
        specs.where((spec) => spec.category == category).toList();

    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columnSpacing: 50,
        headingRowColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            return const Color.fromARGB(255, 87, 155, 210).withOpacity(0.5);
          }
          return Colors.blue; // Use the default value.
        }),
        columns: const [
          DataColumn(
            label: Text(
              'Thông số',
              textAlign: TextAlign.start,
            ),
            numeric: false,
          ),
          DataColumn(
              label: Text('Giá trị', textAlign: TextAlign.end), numeric: true),
        ],
        rows: filteredSpecs
            .map((spec) => DataRow(
                  cells: [
                    DataCell(FutureBuilder<String>(
                      future: translationText(spec.specName!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return Text(snapshot.data!);
                        } else {
                          return const Text('Translation not available');
                        }
                      },
                    )),
                    DataCell(Text(
                        spec.value! == "Available" ? "Có sẵn" : spec.value!,
                        textAlign: TextAlign.end)),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
