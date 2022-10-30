import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/dbHelper/addData.dart';
import 'package:healthly/dbHelper/searchData.dart';
import 'package:healthly/models/hospitalModel.dart';
import 'package:healthly/models/departmentModel.dart';
import 'package:healthly/screens/showHospitals.dart';
import 'package:flutter/material.dart';
import 'package:healthly/mixins/validation_mixin.dart';

class AddDepartment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddDepartmentState();
  }
}

class AddDepartmentState extends State with ValidationMixin {
  final department = Department.empty();
  Hospital hospital = Hospital.empty();
  bool hospitalSelected = false;
  double image = 0.0;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Add Department",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 75.0, left: 25.0, right: 25.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
                      child: Text("Click to Select Hospital"),
                      onPressed: () {
                        hospitalNavigator(BuildHospitalList());
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    showSelectedHospital(hospitalSelected),
                    SizedBox(
                      height: 20.0,
                    ),
                    _newDepartmentName(),
                    SizedBox(
                      height: 25.0,
                    ),
                    _saveButton()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _newDepartmentName() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Enter New Department Name:",
          labelStyle: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.black))),
      validator: validateFirstName,
      onSaved: (String? value) {
        department.departmentName = value!;
      },
    );
  }

  _saveButton() {
    return ElevatedButton(
      child: Text(
        "Add New Department",
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 20.0),
      ),
      onPressed: () {
        if (hospitalSelected && formKey.currentState!.validate()) {
          formKey.currentState?.save();
          SearchService()
              .searchDepartmentByHospitalIdAndDepartmentName(
              hospital.hospitalId, department.departmentName)
              .then((QuerySnapshot docs) {
            if (docs.docs.isEmpty) {
              AddService().saveDepartment(department, hospital);
              Navigator.pop(context, true);
            } else {
              alrtHospital(context, "You cannot add departments with the same name");
            }
          });
        } else {
          alrtHospital(context, "Missing information");
        }
      },
    );
  }

  void hospitalNavigator(dynamic page) async {
    hospital = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (hospital == null) {
      hospitalSelected = false;
    } else {
      hospitalSelected = true;
    }
  }

  showSelectedHospital(bool selected) {
    String textMessage = " ";
    if (selected) {
      setState(() {
        textMessage = this.hospital.hospitalName.toString();
      });
      image = 1.0;
    } else {
      image = 0.0;
    }

    return Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            Text(
              "Selected Hospital : ",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Opacity(
                opacity: image,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    textMessage,
                    style:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ));
  }

  void alrtHospital(BuildContext context, String message) {
    var alertDoctor = AlertDialog(
      title: Text(
        "Warning!",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(message),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDoctor;
        });
  }
}
