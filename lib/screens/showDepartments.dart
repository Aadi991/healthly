import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/models/hospitalModel.dart';
import 'package:healthly/models/departmentModel.dart';
import 'package:flutter/material.dart';

class BuildDepartmentList extends StatefulWidget {
  final Hospital _hospital;
  BuildDepartmentList(this._hospital);

  @override
  _BuildDepartmentListState createState() => _BuildDepartmentListState(_hospital);
}

class _BuildDepartmentListState extends State<BuildDepartmentList> {
  Hospital _hospital;
  _BuildDepartmentListState(this._hospital);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Departments"),
      ),
      body: _buildStremBuilder(context),
    );
  }

  _buildStremBuilder(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("tblDepartment")
          .where("hospitalId", isEqualTo: _hospital.hospitalId)
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
    final department = Department.fromSnapshot(data);
    return Padding(
      key: ValueKey(department.departmentId),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          title: Text(department.departmentName),
          onTap: () {
            Navigator.pop(context, department);
          },
        ),
      ),
    );
  }
}