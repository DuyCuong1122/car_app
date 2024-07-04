class Image {
  final String id;
  final String path;
  final String idCar;
  final String nameCar;
  final String type;

  Image({
    required this.id,
    required this.path,
    required this.idCar,
    required this.nameCar,
    required this.type,

  });

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      id: json['_id'],
      path: json['path'],
      idCar: json['idCar'],
      nameCar: json['nameCar'],
      type: json['type'],
    );
  }
}