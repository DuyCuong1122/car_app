import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:sticky_headers/sticky_headers.dart';

import '../../../common/entities/car.dart';
import 'controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Debouncer debouncer =
        Debouncer(delay: const Duration(milliseconds: 500));

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              StickyHeader(
                header: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: const AlignmentDirectional(-1, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: controller.search,
                            onChanged: (query) {
                              debouncer
                                  .call(() => controller.getSuggestions(query));
                            },
                            autofocus: false,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Tìm kiếm xe',
                              labelStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      17 // Màu chữ khi label ở trạng thái bình thường
                                  ),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              suffixIcon: controller.search.text.isNotEmpty
                                  ? InkWell(
                                      onTap: () {
                                        controller.search.clear();
                                        controller.getSuggestions('');
                                      },
                                      child: const Icon(
                                        Icons.clear,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => print("button is pressed"),
                        icon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                content: Column(
                  children: [
                    const SizedBox(height: 5),
                    const Text(
                      "Dòng xe dự kiện ra mắt",
                      style: TextStyle(fontSize: 25),
                    ),
                    Stack(children: [
                      SizedBox(
                        width: double.infinity,
                        height: 220,
                        child: CarouselSlider(
                          items: [
                            for (var i in controller.state.car2025)
                              Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/image2025/$i.jpg',
                                      width: 300,
                                      height: 200,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
                                  Text(i),
                                ],
                              ),
                          ],
                          options: CarouselOptions(
                            initialPage: 1,
                            viewportFraction: 0.5,
                            disableCenter: true,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.25,
                            enableInfiniteScroll: true,
                            scrollDirection: Axis.horizontal,
                            autoPlay: true,
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayInterval:
                                const Duration(milliseconds: 4800),
                            autoPlayCurve: Curves.linear,
                            pauseAutoPlayInFiniteScroll: true,
                            onPageChanged: (index, _) => controller
                                .state.carouselCurrentIndex.value = index,
                          ),
                        ),
                      ),
                      Obx(() {
                        return Container(
                          color: Colors.white,
                          height: 150,
                          child: controller.state.suggestions.isEmpty
                              ? const SizedBox(
                                  height: 10,
                                )
                              : ListView.builder(
                                  itemCount:
                                      controller.state.suggestions.length,
                                  itemBuilder: (context, index) {
                                    final suggestion =
                                        controller.state.suggestions[index];

                                    return ListTile(
                                      title: Text(controller
                                          .state.suggestions[index]['nameCar']),
                                      onTap: () async {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        await controller.fetchACar(
                                            suggestion['nameCar'].toString());
                                        Car car = controller
                                            .state.selectedSuggestion.first;
                                        log('Suggestion selected: ${suggestion['nameCar']}');
                                        Get.toNamed('/detail', arguments: car);
                                      },
                                    );
                                  },
                                ),
                        );
                      }),
                    ]),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
                      child: Container(
                        width: double.infinity,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 0,
                              color: Colors.blue.shade100,
                              offset: Offset(0.0, 1),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: Colors.blue.shade100,
                          ),
                        ),
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 12, 16, 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                ),
                                child: const Align(
                                  alignment: AlignmentDirectional(-1, 0),
                                  child: Padding(
                                    padding: EdgeInsets.all(6),
                                    child: Text(
                                      'Lọc',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 17),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width:
                                    100, // Set a fixed width for the dropdown
                                child: Obx(() {
                                  return DropdownButton<String>(
                                    menuMaxHeight: 150,
                                    value: controller.state.selectedValue.value,
                                    items: controller.state.dropdownmenu
                                        .map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      controller.setSelected(newValue!);
                                      log(controller.state.selectedValue
                                          .toString());
                                      if (newValue != "Tất cả") {
                                        controller.fetchCars(controller
                                            .state.selectedValue
                                            .toString());
                                      } else {
                                        controller.fetchAllCars();
                                      }
                                      log(controller.state.cars.toString());
                                    },
                                    isExpanded: true,
                                    // Ensure the dropdown expands to fill the container
                                  );
                                }),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Obx(() {
                  return Wrap(
                    spacing: 8.0,
                    children: controller.state.carTypes.map((carType) {
                      return ChoiceChip(
                        label: Text(carType),
                        selected: controller.state.selectedCarType.value == carType,
                        onSelected: (bool selected) {
                          // if (selected) {
                          //   controller.selectedCarType.value = carType;
                          //   // Gọi phương thức để lọc xe dựa trên loại xe được chọn
                          //   if (carType != 'Tất cả') {
                          //     controller.fetchCarsByType(carType);
                          //   } else {
                          //     controller.fetchAllCars();
                          //   }
                          // }
                        },
                      );
                    }).toList(),
                  );
                }),
              ),
              const SizedBox(height: 15),

              Obx(() {
                if (controller.state.cars.isNotEmpty) {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two columns
                      mainAxisSpacing: 10.0, // Spacing between rows
                      crossAxisSpacing: 10.0, // Spacing between columns
                    ),
                    itemCount: controller.state.cars.length,
                    shrinkWrap: true, // Added shrinkWrap
                    physics:
                        const NeverScrollableScrollPhysics(), // Disabled scroll physics
                    itemBuilder: (context, index) {
                      final car = controller.state.cars[index];
                      return InkWell(
                        onTap: () async {
                          await Get.toNamed("/detail", arguments: car);
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CachedNetworkImage(
                                    imageUrl: car.thumbnail,
                                    fit: BoxFit.fitWidth,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Text("Giá từ ${car.price}",
                                    style: const TextStyle(fontSize: 14)),
                                Text(car.nameCar,
                                    style: const TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
