// class Spec {
//   String id;
//   String idCar;
//   String category;
//   String specName;
//   String value;

//   Spec({
//     required this.id,
//     required this.idCar,
//     required this.category,
//     required this.specName,
//     required this.value,
//   });

//   factory Spec.fromJson(Map<String, dynamic> json) {
//     return Spec(
//       id: json['_id'],
//       idCar: json['idCar'],
//       category: json['category'],
//       specName: json['specName'],
//       value: json['value'],
//     );
//   }
// }
class Spec {
  String? id;
  String? idCar;
  String? category;
  String? specName;
  String? value;

  Spec({this.id, this.idCar, this.category, this.specName, this.value});

  factory Spec.fromJson(Map<String, dynamic> json) {
    return Spec(
      id: json['_id'],
      idCar: json['idCar'],
      category: json['category'],
      specName: json['specName'],
      value: json['value'] as String?,
    );
  }
}
