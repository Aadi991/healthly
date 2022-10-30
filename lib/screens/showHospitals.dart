import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/models/hospitalModel.dart';
import 'package:flutter/material.dart';

class BuildHospitalList extends StatefulWidget {
  @override
  _BuildHospitalListState createState() => _BuildHospitalListState();
}

class _BuildHospitalListState extends State<BuildHospitalList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hospitals"),
      ),
      body: _buildStreamBuilder(context),
    );
  }

  _buildStreamBuilder(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("tblHospital").snapshots(),
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
    final hospital = Hospital.fromSnapshot(data);
    return Padding(
      key: ValueKey(hospital.hospitalId),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          title: Text(hospital.hospitalName),
          onTap: () {
            Navigator.pop(context, hospital);
          },
        ),
      ),
    );
  }
}