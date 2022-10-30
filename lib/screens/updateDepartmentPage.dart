import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/dbHelper/searchData.dart';
import 'package:healthly/dbHelper/updateData.dart';
import 'package:healthly/models/hospitalModel.dart';
import 'package:healthly/models/departmentModel.dart';
import 'package:healthly/screens/showHospitals.dart';
import 'package:healthly/screens/showDepartments.dart';
import 'package:flutter/material.dart';

class UpdateDepartment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UpdateDepartmentState();
  }
}

class UpdateDepartmentState extends State {
  Hospital hospital = Hospital.empty();
  double image = 0.0;
  bool hospitalSelected = false;
  bool departmentSelected = false;
  Department department = Department.empty();
  String textMessage = " ";
  String newDepartmentName = "";
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Department Update Screen",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 50.0, left: 15.0, right: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: ElevatedButton(
                        child: Text(
                          "Click to Select Hospital",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          departmentSelected = false;
                          hospitalNavigator(BuildHospitalList());
                        },
                      ),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    showSelectedHospital(hospitalSelected),
                    SizedBox(
                      height: 30.0,
                    ),
                    ElevatedButton(
                      child: Text("Click to Select Department"),
                      onPressed: () {
                        if (hospitalSelected) {
                          departmentNavigator(BuildDepartmentList(hospital));
                        } else {
                          alrtHospital(
                              context, "You cannot select a department without selecting a hospital");
                        }
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    _showSelectedDepartment(departmentSelected),
                    SizedBox(
                      height: 30.0,
                    ),
                    _newDepartmentName(),
                    SizedBox(
                      height: 20.0,
                    ),
                    _updateButton()
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
              color: Colors.black)),
      onSaved: (String? value) {
        newDepartmentName = value!;
      },
    );
  }

  void hospitalNavigator(dynamic page) async {
    hospital = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (hospital == null) {
      setState(() {
        hospitalSelected = false;
      });
    } else {
      setState(() {
        hospitalSelected = true;
      });
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
              "Chosen Hospital : ",
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

  void departmentNavigator(dynamic page) async {
    department = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (department == null) {
      setState(() {
        departmentSelected = false;
      });
    } else {
      setState(() {
        departmentSelected = true;
      });
    }
  }

  void alrtHospital(BuildContext context, String message) {
    var alertHospital = AlertDialog(
      title: Text("Warning!"),
      content: Text(message),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertHospital;
        });
  }

  _showSelectedDepartment(bool selected) {
    double image = 0.0;

    if (selected) {
      setState(() {
        textMessage = this.department.departmentName.toString();
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
              "Selected Department: ",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Opacity(
                opacity: image,
                child: Container(
                    alignment: Alignment.center,
                    child: _buildTextMessage(textMessage)))
          ],
        ));
  }

  _buildTextMessage(String incomingText) {
    return Text(
      textMessage,
      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
    );
  }

  _updateButton() {
    return ElevatedButton(
      child: Text(
        "Update Department",
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 20.0),
      ),
      onPressed: () {
        if (formKey.currentState!.validate()) {
          formKey.currentState?.save();
          SearchService()
              .searchDepartmentByHospitalIdAndDepartmentName(
              hospital.hospitalId, newDepartmentName)
              .then((QuerySnapshot docs) {
            if (docs.docs.isEmpty && department.departmentName != newDepartmentName) {
              department.departmentName = newDepartmentName;
              UpdateService().updateDepartment(department);
              Navigator.pop(context, true);
            } else {
              alrtHospital(context,
                  "A department with the same name already exists in the hospital you selected");
            }
          });
        } else {
          alrtHospital(context, "Missing Information");
        }
      },
    );
  }
}