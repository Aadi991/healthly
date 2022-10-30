import 'package:cloud_firestore/cloud_firestore.dart';

class Department {
  String departmentName;
  int departmentId;
  int hospitalId;

  DocumentReference? reference;

  Department({required this.departmentName, required this.departmentId, required this.hospitalId});


  factory Department.empty() {
    String departmentName = "";
    int departmentId = 0;
    int hospitalId = 0;
    return Department(departmentName: departmentName,departmentId: departmentId,hospitalId: hospitalId);
  }

  factory Department.fromJson(Map<String, dynamic> json) {
    String departmentName = json['departmentName'];
    int departmentId = json['departmentId'];
    int hospitalId = json['hospitalId'];
    return Department(departmentName: departmentName,departmentId: departmentId,hospitalId: hospitalId);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['departmentName'] = this.departmentName;
    data['departmentId'] = this.departmentId;
    data['hospitalId'] = this.hospitalId;
    return data;
  }

  Department.fromMap(Map<String, dynamic> map, {this.reference})
      : departmentName = map["departmentName"],
        departmentId = map["departmentId"],
        hospitalId = map["hospitalId"];

  Department.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data() as Map<String,dynamic>, reference: snapshot.reference);
}
