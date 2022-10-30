import 'package:cloud_firestore/cloud_firestore.dart';

class Doctor {
  String idNo;
  String name;
  String surname;
  String password;
  int departmentId;
  int hospitalId;
  var appointments = [];
  int favoriteCounter;
  String dateOfBirth;
  String gender;
  String placeOfBirth;

  DocumentReference? reference;

  Doctor(
      {required this.idNo,
      required this.name,
      required this.surname,
      required this.password,
      required this.departmentId,
      required this.hospitalId,
      required this.appointments,
      required this.favoriteCounter,
      required this.dateOfBirth,
      required this.gender,
      required this.placeOfBirth});

  factory Doctor.empty() {
    String idNo = '';
    String name = '';
    String surname = '';
    String password = '';
    int departmentId = 0;
    int hospitalId = 0;
    var appointments = List.empty();
    int favoriteCounter = 0;
    String dateOfBirth = '';
    String gender = '';
    String  placeOfBirth = '';
    return Doctor(idNo: idNo, name: name, surname: surname, password: password, departmentId: departmentId, hospitalId: hospitalId, appointments: appointments, favoriteCounter: favoriteCounter, dateOfBirth: dateOfBirth, gender: gender, placeOfBirth: placeOfBirth);
  }

  factory Doctor.fromJson(Map<String, dynamic> json) {
    String idNo = json['idNo'];
    String name = json['id'];
    String surname = json['surname'];
    String password = json['password'];
    int departmentId = json['departmentId'];
    int hospitalId = json['hospitalId'];
    var appointments = List.from(json['appointments']);
    int favoriteCounter = json['favoriteCounter'];
    String dateOfBirth = json['dateOfBirth'];
    String gender = json['gender'];
    String  placeOfBirth = json["placeOfBirth"];
    return Doctor(idNo: idNo, name: name, surname: surname, password: password, departmentId: departmentId, hospitalId: hospitalId, appointments: appointments, favoriteCounter: favoriteCounter, dateOfBirth: dateOfBirth, gender: gender, placeOfBirth: placeOfBirth);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idNo'] = this.idNo;
    data['id'] = this.name;
    data['surname'] = this.surname;
    data['password'] = this.password;
    data['departmentId'] = this.departmentId;
    data['hospitalId'] = this.hospitalId;
    data['appointments'] = this.appointments;
    data['favoriteCounter'] = this.favoriteCounter;
    data['dateOfBirth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['placeOfBirth'] = this.placeOfBirth;
    return data;
  }

  Doctor.fromMap(Map<String, dynamic> map, {this.reference})
      : idNo = map["idNo"],
        password = map["password"],
        name = map["ad"],
        surname = map["soyad"],
        departmentId = map["departmentId"],
        hospitalId = map["hospitalId"],
        appointments = List.from(map["appointments"]),
        favoriteCounter = map["favoriteCounter"],
        placeOfBirth = map["placeOfBirth"],
        dateOfBirth = map["dateOfBirth"],
        gender = map["gender"];

  Doctor.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String,dynamic>, reference: snapshot.reference);
}
