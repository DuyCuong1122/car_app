import 'package:do_an_tot_nghiep_final/common/entities/spec.dart';

import 'car.dart';
import 'image.dart';

class CarWithSpecs {
  Car car;
  List<Spec> specs;
  List<Image> images;

  CarWithSpecs({required this.car, required this.specs, required this.images});

  factory CarWithSpecs.fromJson(
      Map<String, dynamic> json, String carKey, String specsKey, String imagesKey) {
    return CarWithSpecs(
      car: Car.fromJson(json[carKey]),
      specs:
          (json[specsKey] as List).map((spec) => Spec.fromJson(spec)).toList(),
      images: (json[imagesKey] as List).map((image) => Image.fromJson(image)).toList(),
    );
  }
}
