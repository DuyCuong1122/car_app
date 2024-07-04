class Info {
  String id;
  String idCar;
  String title;
  String body;
  Info(
      {required this.id,
        required this.idCar,
        required this.title,
        required this.body,
        });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
        id: json['_id'],
        idCar: json['idCar'],
        title: json['title'],
        body: json['body'],
        );
  }
}
