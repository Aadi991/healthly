import 'package:cloud_firestore/cloud_firestore.dart';

class PassAppointment {
  int registrationID;
  String doctorId;
  String patientId;
  String transactionDate;
  String doctorName;
  String patientName;
  String doctorSurname;
  String patientSurname;

  DocumentReference? reference;

  PassAppointment(
      {required this.registrationID,
      required this.doctorId,
      required this.patientId,
      required this.transactionDate,
      required this.doctorName,
      required this.doctorSurname,
      required this.patientName,
      required this.patientSurname});

  factory PassAppointment.fromJson(Map<String, dynamic> json) {
    int registrationID = json['registrationID'];
    String doctorId = json['doctorId'];
    String patientId = json['patientId'];
    String transactionDate = json['transactionDate'];
    String doctorName = json['doctorName'];
    String  patientName = json['patientName'];
    String doctorSurname = json['doctorSurname'];
    String patientSurname = json['patientSurname'];
    return PassAppointment(registrationID: registrationID, doctorId: doctorId, patientId: patientId, transactionDate: transactionDate, doctorName: doctorName, doctorSurname: doctorSurname, patientName: patientName, patientSurname: patientSurname);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['registrationID'] = this.registrationID;
    data['doctorId'] = this.doctorId;
    data['patientId'] = this.patientId;
    data['transactionDate'] = this.transactionDate;
    data['doctorName'] = this.doctorName;
    data['patientName'] = this.patientName;
    data['doctorSurname'] = this.doctorSurname;
    data['patientSurname'] = this.patientSurname;
    return data;
  }

  PassAppointment.fromMap(Map<String, dynamic> map, {this.reference})
      : registrationID = map['registrationID'],
        doctorId = map['doctorId'],
        patientId = map['patientId'],
        transactionDate = map['transactionDate'],
        doctorName = map["doctorName"],
        patientName = map["patientName"],
        doctorSurname = map["doctorSurname"],
        patientSurname = map["patientSurname"];

  PassAppointment.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String,dynamic>, reference: snapshot.reference);
}
