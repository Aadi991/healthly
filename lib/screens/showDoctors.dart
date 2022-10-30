import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/models/doctorModel.dart';
import 'package:healthly/models/hospitalModel.dart';
import 'package:healthly/models/departmentModel.dart';
import 'package:flutter/material.dart';

class BuildDoctorList extends StatefulWidget {
  final Department _department;
  final Hospital _hospital;
  BuildDoctorList(this._department, this._hospital);

  @override
  _BuildDoctorListState createState() =>
      _BuildDoctorListState(_department, _hospital);
}

class _BuildDoctorListState extends State<BuildDoctorList> {
  Department department;
  Hospital hospital;
  _BuildDoctorListState(this.department, this.hospital);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctors"),
      ),
      body: _buildStremBuilder(context),
    );
  }

  _buildStremBuilder(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("tblDoctor")
          .where("hospitalId", isEqualTo: hospital.hospitalId)
          .where("departmentId", isEqualTo: department.departmentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return _buildBody(context, snapshot.data!.docs);
        }
      },
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: EdgeInsets.only(top: 15.0),
      children: snapshot
          .map<Widget>((data) => _buildListItem(context, data))
          .toList(),
    );
  }

  _buildListItem(BuildContext context, DocumentSnapshot data) {
    final dr = Doctor.fromSnapshot(data);
    return Padding(
      key: ValueKey(dr.idNo),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Text(dr.name),
              SizedBox(
                width: 5.0,
              ),
              Text(dr.surname)
            ],
          ),
          subtitle: Text(department.departmentName),
          onTap: () {
            Navigator.pop(context, dr);
          },
        ),
      ),
    );
  }
}
