class Car {
  String id;
  String nameCar;
  String year;
  String linkCar;
  String price;
  String description;
  String thumbnail;

  Car(
      {required this.id,
      required this.nameCar,
      required this.year,
      required this.description,
      required this.linkCar,
      required this.price,
      required this.thumbnail});

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
        id: json['_id'],
        nameCar: json['nameCar'],
        year: json['year'],
        linkCar: json['linkCar'],
        price: json['price'],
        thumbnail: json['thumbnail'],
        description: json['description']);
  }
}
