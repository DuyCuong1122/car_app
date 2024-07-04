class Rating {
  String id;
  String idCar;
  String expert;
  String user;
  Rating(
      {required this.id,
        required this.idCar,
        required this.expert,
        required this.user,
      });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['_id'],
      idCar: json['idCar'],
      expert: json['Expert'],
      user: json['User'],
    );
  }
}
