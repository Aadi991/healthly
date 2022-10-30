import 'package:cloud_firestore/cloud_firestore.dart';

class Hospital {
  String hospitalName;
  int hospitalId;

  Hospital({required this.hospitalName, required this.hospitalId});

  DocumentReference?  reference;
  factory Hospital.empty() {
    String hospitalName = '';
    int hospitalId = 0;
    return Hospital(hospitalName: hospitalName, hospitalId: hospitalId);
  }

  factory Hospital.fromJson(Map<String, dynamic> json) {
    String hospitalName = json['hospitalName'];
    int hospitalId = json['hospitalId'];
    return Hospital(hospitalName: hospitalName, hospitalId: hospitalId);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hospitalName'] = this.hospitalName;
    data['hospitalId'] = this.hospitalId;
    return data;
  }

  Hospital.fromMap(Map<String, dynamic> map, {this.reference})
      : hospitalName = map["hospitalName"],
        hospitalId = map["hospitalId"];

  Hospital.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String,dynamic>, reference: snapshot.reference);
}
