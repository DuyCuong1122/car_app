import 'package:get/get.dart';

import '../../../common/entities/entities.dart';

class HomeState {
  RxInt carouselCurrentIndex = 0.obs;
  List<String> dropdownmenu = [
    "Tất cả",
    "2024",
    "2023",
    "2022",
    "2021",
    "2020",
    "2019",
    "2018",
    "2017",
    "2016",
    "2015",
    "2014",
  ];
  RxString selectedValue = "Tất cả".obs;
  RxInt choiceChipIndex = 0.obs;
  var cars = <Car>[].obs;
  var suggestions = <dynamic>[].obs;
  var selectedSuggestion = <Car>[].obs;
  List<String> car2025 = [
    "2025 BMW 2 Series",
    "2025 BMW 3 Series",
    "2025 BMW 4 Series",
    "2025 BMW 5 Series",
    "2025 BMW 7 Series",
    "2025 BMW 8 Series",
    "2025 BMW X2",
    "2025 BMW X4",
    "2025 BMW X5",
    "2025 BMW X6",
    "2025 BMW X5 M",
    "2025 BMW X6 M",
    "2025 BMW Z4",
    "2025 BMW i7",
    "2025 BMW i4",
    "2025 BMW iX",
    "2025 BMW M3",
    "2025 BMW M4",
    "2025 BMW M8"
  ];
  var carTypes = ['BMW', 'Toyota', 'Hyundai', 'Lexus', 'Ford'].obs; // Danh sách các loại xe
  var selectedCarType = 'BMW'.obs; // Loại xe đang được chọn
}
