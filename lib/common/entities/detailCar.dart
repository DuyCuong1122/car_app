import 'car.dart';
import 'image.dart';
import 'info.dart';
import 'rating.dart';
import 'spec.dart';

class DetailCar {
  Car car;
  List<Spec> specs;
  List<Image> images;
  List<Info> infos;
  Rating rating;

  DetailCar({required this.car, required this.specs, required this.images, required this.infos, required this.rating});
  factory DetailCar.fromJson(Map<String, dynamic> json) {
    return DetailCar(
        car: Car.fromJson(json['car']),
        specs: (json['specs'] as List).map((e) => Spec.fromJson(e)).toList(),
        images:
            (json['images'] as List).map((e) => Image.fromJson(e)).toList(),
        rating: Rating.fromJson(json['ratings']),
        infos: (json['infos'] as List).map((e) => Info.fromJson(e)).toList()
    );
  }
}
