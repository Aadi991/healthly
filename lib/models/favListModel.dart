import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteList {
  String doctorId;
  String doctorName;
  String doctorSurname;
  String patientId;
  String patientName;
  String patientSurname;
  DocumentReference? reference;

  FavoriteList(
      {required this.doctorId,
      required this.patientId,
      required this.doctorName,
      required this.doctorSurname,
      required this.patientName,
      required this.patientSurname});

  factory FavoriteList.fromJson(Map<String, dynamic> json) {
    String doctorId = json['doctorId'];
    String patientId = json['patientId'];
    String doctorName = json['doctorName'];
    String patientName = json['patientName'];
    String doctorSurname = json['doctorSurname'];
    String patientSurname = json['patientSurname'];
    return FavoriteList(doctorId: doctorId, patientId: patientId, doctorName: doctorName, doctorSurname: doctorSurname, patientName: patientName, patientSurname: patientSurname);

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorId'] = this.doctorId;
    data['patientId'] = this.patientId;
    data['doctorName'] = this.doctorName;
    data['patientName'] = this.patientName;
    data['doctorSurname'] = this.doctorSurname;
    data['patientSurname'] = this.patientSurname;
    return data;
  }

  FavoriteList.fromMap(Map<String, dynamic> map, {required this.reference})
      : doctorId = map["doctorId"],
        patientId = map["patientId"],
        doctorName = map["doctorName"],
        patientName = map["patientName"],
        doctorSurname = map["doctorSurname"],
        patientSurname = map["patientSurname"];

  FavoriteList.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String,dynamic>, reference: snapshot.reference);
}
