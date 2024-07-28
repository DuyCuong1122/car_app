import 'package:do_an_tot_nghiep_final/common/entities/entities.dart';
import 'package:do_an_tot_nghiep_final/common/helper/helper_method.dart';
import 'package:do_an_tot_nghiep_final/common/widgets/comment.dart';
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
            style: const TextStyle(fontSize: 28),
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4386B9),
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
                                    child: Text('Lỗi tải ảnh'),
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
                  Text(
                    "Năm sản xuất: ${detail.car.year}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text("Giá: ${detail.car.price} tỷ VND",
                      style: const TextStyle(fontSize: 16)),
                  Text("Mô tả: ${detail.car.description}",
                      style: const TextStyle(fontSize: 15)),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          height: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
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
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      "Thông số kỹ thuật",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_hasCategory(
                      detail.specs, 'Dimensions, Weights & Capacities'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tổng quan',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        _buildFilteredDataTable(
                            detail.specs, 'Dimensions, Weights & Capacities'),
                      ],
                    ),
                  if (_hasCategory(detail.specs, 'Exterior'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ngoại thất',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        _buildFilteredDataTable(detail.specs, 'Exterior'),
                      ],
                    ),
                  if (_hasCategory(detail.specs, 'Fuel Economy'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nhiên liệu tiêu hao',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        _buildFilteredDataTable(detail.specs, 'Fuel Economy'),
                      ],
                    ),
                  if (_hasCategory(detail.specs, 'Mechanical'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Máy móc',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        _buildFilteredDataTable(detail.specs, 'Mechanical'),
                      ],
                    ),
                  if (_hasCategory(detail.specs, 'Performance'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Hiệu suất',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        _buildFilteredDataTable(detail.specs, 'Performance'),
                      ],
                    ),
                  if (_hasCategory(detail.specs, 'Comfort & Convenience'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tiện ích',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        _buildFilteredDataTable(
                            detail.specs, 'Comfort & Convenience'),
                      ],
                    ),
                  if (_hasCategory(detail.specs, 'Entertainment'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Giải trí',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        _buildFilteredDataTable(detail.specs, 'Entertainment'),
                      ],
                    ),
                  if (_hasCategory(detail.specs, 'Interior'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nội thất',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        _buildFilteredDataTable(detail.specs, 'Interior'),
                      ],
                    ),
                  if (_hasCategory(detail.specs, 'Seating'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ghế ngồi',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        _buildFilteredDataTable(detail.specs, 'Seating'),
                      ],
                    ),
                  if (_hasCategory(detail.specs, 'Security'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'An toàn',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        _buildFilteredDataTable(detail.specs, 'Security'),
                      ],
                    ),
                  if (_hasCategory(detail.specs, 'Technology'))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Công nghệ',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        _buildFilteredDataTable(detail.specs, 'Technology'),
                      ],
                    ),

                  if (controller.state.colors_image.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text("Màu xe",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 300,
                          child: PageView.builder(
                            itemCount: controller.state.colors_image.length,
                            itemBuilder: (context, index) {
                              final colorsImage =
                                  controller.state.colors_image[index];
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    colorsImage.path,
                                    fit: BoxFit.fitWidth,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
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
                                    errorBuilder: (context, error, stackTrace) {
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

                  if (controller.state.feature_image.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Ảnh toàn bộ xe",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 300,
                          child: PageView.builder(
                            itemCount: controller.state.feature_image.length,
                            itemBuilder: (context, index) {
                              final featureImage =
                                  controller.state.feature_image[index];
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    featureImage.path,
                                    fit: BoxFit.fitWidth,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
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
                                    errorBuilder: (context, error, stackTrace) {
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


                  SizedBox(child: Text("Rating: "+controller.state.getAVG.value.toString()),),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("Đánh giá của khách hàng",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 200, // hoặc bất kỳ giới hạn nào bạn muốn
                    ),
                    child: StreamBuilder(
                      stream: controller.getAllEvaluation(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text('Chưa có đánh giá nào!!!'),
                          );
                        } else if (snapshot.hasData) {
                          final evaluations = snapshot.data ?? [];
                          if (evaluations.isEmpty) {
                            return const Center(
                              child: Text("Chưa có đánh giá nào"),
                            );
                          }
                          return ListView.builder(
                            itemCount: evaluations.length,
                            itemBuilder: (context, index) {
                              final evaluation = evaluations[index];
                              return Comment(
                                text: evaluation['content'],
                                time: formatDate(evaluation['createdAt']),
                                user: evaluation['username'],
                                id: evaluation['id'],
                                onTap: controller.deleteEvaluation,
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Text("Chưa có đánh giá!!!"),
                          );
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.commentTextController,
                            decoration: InputDecoration(
                              hintText: 'Viết đánh giá...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () async {
                            await controller.addEvaluation(
                                controller.commentTextController.text);
                            controller.commentTextController.clear();
                          },
                        )
                      ],
                    ),
                  ),
                  // Center(
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     style: ButtonStyle(
                  //       backgroundColor: WidgetStateProperty.all<Color>(
                  //           Colors.blue), // Nền xanh
                  //     ),
                  //     child: const Text(
                  //       "So sánh xe khác",
                  //       style: TextStyle(color: Colors.white), // Màu chữ trắng
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _hasCategory(List<Spec> specs, String category) {
    for (var spec in specs) {
      if (spec.category == category) {
        return true; // Dừng vòng lặp khi tìm thấy category
      }
    }
    return false;
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
              return Text(
                snapshot.data!.text,
                style: const TextStyle(fontSize: 15),
              );
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
        headingRowColor:
            WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            return const Color.fromARGB(255, 87, 155, 210).withOpacity(0.5);
          }
          return const Color(0x82B3DAFF); // Use the default value.
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
