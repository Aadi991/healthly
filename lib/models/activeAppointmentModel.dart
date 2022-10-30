import 'package:cloud_firestore/cloud_firestore.dart';

class ActiveAppointment {
  String doctorId;
  String doctorName;
  String patientId;
  String patientName;
  int randId;
  String appointmentDate;
  DocumentReference? reference;
  String doctorSurname;
  String patientSurname;

  ActiveAppointment(
      {required this.doctorId,
      required this.patientId,
      required this.randId,
      required this.appointmentDate,
      required this.doctorName,
      required this.doctorSurname,
      required this.patientName,
      required this.patientSurname});

  factory ActiveAppointment.empty() {
    var doctorId = "";
    var patientId = "";
    var randId = 0;
    var appointmentDate = "";
    var doctorName ='';
    var patientName = '';
    var doctorSurname = '';
    var patientSurname = '';
    return ActiveAppointment(doctorId: doctorId, patientId: patientId, randId: randId, appointmentDate: appointmentDate, doctorName: doctorName, doctorSurname: doctorSurname, patientName: patientName, patientSurname: patientSurname);
  }

  factory ActiveAppointment.fromJson(Map<String, dynamic> json) {
    var doctorId = json['doctorId'];
    var patientId = json['patientId'];
    var randId = json['randId'];
    var appointmentDate = json['appointmentDate'];
    var doctorName = json['doctorName'];
    var patientName = json['patientName'];
    var doctorSurname = json['doctorSurname'];
    var patientSurname = json['patientSurname'];
    return ActiveAppointment(doctorId: doctorId, patientId: patientId, randId: randId, appointmentDate: appointmentDate, doctorName: doctorName, doctorSurname: doctorSurname, patientName: patientName, patientSurname: patientSurname);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorId'] = this.doctorId;
    data['patientId'] = this.patientId;
    data['randId'] = this.randId;
    data['appointmentDate'] = this.appointmentDate;
    data['doctorName'] = this.doctorName;
    data['patientName'] = this.patientName;
    data['doctorSurname'] = this.doctorSurname;
    data['patientSurname'] = this.patientSurname;
    return data;
  }

  ActiveAppointment.fromMap(Map<String, dynamic> map, {this.reference})
      : doctorId = map["doctorId"],
        patientId = map["patientId"],
        randId = map["randId"],
        appointmentDate = map["appointmentDate"],
        doctorName = map["doctorName"],
        patientName = map["patientName"],
        doctorSurname = map["doctorSurname"],
        patientSurname = map["patientSurname"];

  ActiveAppointment.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String,dynamic>, reference: snapshot.reference);
}
