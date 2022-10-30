
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String idNo;
  String name;
  String surname;
  String password;
  String dateOfBirth;
  String gender;
  String placeOfBirth;

  DocumentReference? reference;

  User(
      {required this.idNo,
        required this.name,
        required this.surname,
        required this.password,
        required this.dateOfBirth,
        required this.gender,
        required this.placeOfBirth});

  factory User.empty() {
    String idNo = '';
    String name= '';
    String surname = '';
    String dateOfBirth = '';
    String gender = '';
    String password = '';
    String placeOfBirth = '';
    return User(idNo: idNo, name:name, surname: surname, password: password, dateOfBirth: dateOfBirth, gender: gender, placeOfBirth: placeOfBirth);
  }

   factory User.fromJson(Map<String, dynamic> json) {
     String idNo = json['idNo'];
     String name= json['name'];
     String surname = json['surname'];
     String dateOfBirth = json['dateOfBirth'];
     String gender = json['gender'];
     String password = json['password'];
     String placeOfBirth = json["placeOfBirth"];
    return User(idNo: idNo, name:name, surname: surname, password: password, dateOfBirth: dateOfBirth, gender: gender, placeOfBirth: placeOfBirth);
  }

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : idNo = map["idNo"],
        password = map["password"],
        name= map["name"],
        surname = map["surname"],
        placeOfBirth = map["placeOfBirth"],
        dateOfBirth = map["dateOfBirth"],
        gender = map["gender"];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data()  as Map<String,dynamic>, reference: snapshot.reference);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idNo'] = this.idNo;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['dateOfBirth'] = this.dateOfBirth;
    data['gender'] = this.gender;
    data['password'] = this.password;
    data['placeOfBirth'] = this.placeOfBirth;
    return data;
  }
}
