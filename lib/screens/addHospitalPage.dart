import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/dbHelper/addData.dart';
import 'package:healthly/dbHelper/searchData.dart';
import 'package:healthly/models/hospitalModel.dart';
import 'package:flutter/material.dart';
import 'package:healthly/mixins/validation_mixin.dart';

class AddHospital extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddHospitalState();
  }
}

class AddHospitalState extends State with ValidationMixin {
  final hospital = Hospital.empty();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Hospital",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20.0, right: 16.0, left: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _hospitalNameField(),
                  SizedBox(
                    height: 30.0,
                  ),
                  _buildDoneButton()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _hospitalNameField() {
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
            labelText: "Hospital Name to Add",
            labelStyle: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        validator: validateFirstName,
        autocorrect: false,
        onSaved: (String? value) {
          hospital.hospitalName = value!;
        },
      ),
    );
  }

  _buildDoneButton() {
    return Container(
      child: ElevatedButton(
        child: Text(
          "Complete",
          style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          formKey.currentState!.validate();
          formKey.currentState?.save();
          SearchService()
              .searchHospitalByName(hospital.hospitalName)
              .then((QuerySnapshot docs) {
            if (docs.docs.isEmpty) {
              AddService().saveHospital(hospital);
              Navigator.pop(context, true);
            } else {
              alrtHospital(context, "You cannot add a hospital with the same name");
            }
          });
        },
      ),
    );
  }

  void alrtHospital(BuildContext context, String message) {
    var alertHospital = AlertDialog(
      title: Text(
        "Warning!",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertHospital;
        });
  }
}