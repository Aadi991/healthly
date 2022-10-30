import 'package:cloud_firestore/cloud_firestore.dart';

class Admin {
  int id;
  String nickname;
  String password;
  var closedHours = [];

  DocumentReference? reference;

  Admin(this.id, this.nickname, this.password, this.closedHours);

  Admin.full(
      this.id, this.nickname, this.password, this.closedHours, this.reference);

  factory Admin.empty() {
    var id = 0;
    var nickname = '';
    var password = '';
    var closedHours = List.empty();
    return Admin(id, nickname, password, closedHours);
  }

  factory Admin.fromJson(Map<String, dynamic> json) {
    var id = json['Id'];
    var nickname = json['nickname'];
    var password = json['password'];
    var closedHours = List.from(json['closedHours']);
    return Admin(id, nickname, password, closedHours);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['nickname'] = this.nickname;
    data['password'] = this.password;
    data['closedHours'] = this.closedHours;
    return data;
  }

  factory Admin.fromMap(Map<String, dynamic> map,
      {DocumentReference? localReference}) {
    var id = map["Id"] ?? 0;
    var nickname = map["nickname"]?? "";
    var password = map["password"]??"";
    var closedHours =
        map["closedHours"] == null ? List.empty(growable: true) : List.from(map["closedHours"]);
    return Admin.full(id, nickname, password, closedHours, localReference);
  }

  factory Admin.fromSnapshot(DocumentSnapshot snapshot) {
    return Admin.fromMap(snapshot.data() as Map<String, dynamic>,
        localReference: snapshot.reference);
  }
}
