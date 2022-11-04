import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/dbHelper/addData.dart';
import 'package:healthly/dbHelper/searchData.dart';
import 'package:healthly/models/doctorModel.dart';
import 'package:healthly/models/hospitalModel.dart';
import 'package:healthly/models/departmentModel.dart';
import 'package:healthly/screens/showHospitals.dart';
import 'package:healthly/screens/showDepartments.dart';
import 'package:flutter/material.dart';
import 'package:healthly/mixins/validation_mixin.dart';

class AddDoctor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddDoctorState();
  }
}

class AddDoctorState extends State with ValidationMixin {
  final doctor = Doctor.empty();
  Hospital hospital = Hospital.empty();
  Department department = Department.empty();
  bool hospitalSelected = false;
  bool departmentSelected = false;
  String textMessage = " ";
  double image = 0.0;
  final formKey = GlobalKey<FormState>();

  var genders = ["Female", "Male"];
  String selectedGenders = "Female";
  var dateOfBirth;
  var raisedButtonText = "Click and Select";

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    dateOfBirth = picked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Add Doctor",
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20.0, left: 9.0, right: 9.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      _idNoField(),
                      _passwordField(),
                      _nameField(),
                      _surnameField(),
                      placeofBirthField(),
                      genderChoose(),
                      dateOfBirthWidget(),
                      SizedBox(
                        height: 13.0,
                      ),
                      ElevatedButton(
                        child: Text("Click to Select Hospital"),
                        onPressed: () {
                          departmentSelected = false;
                          hospitalNavigator(BuildHospitalList());
                        },
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      showSelectedHospital(hospitalSelected),
                      SizedBox(
                        height: 16.0,
                      ),
                      ElevatedButton(
                        child: Text("Click to Select Department"),
                        onPressed: () {
                          if (hospitalSelected) {
                            departmentNavigator(BuildDepartmentList(hospital));
                          } else {
                            alrtHospital(context,
                                "You cannot select a department without selecting a hospital");
                          }
                        },
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      _showSelectedDepartment(departmentSelected),
                      SizedBox(
                        height: 16.0,
                      ),
                      _buildDoneButton(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _idNoField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "T.R. Identity Number:",
          labelStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
      validator: validateTCNo,
      keyboardType: TextInputType.number,
      onSaved: (String? value) {
        doctor.idNo = value!;
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Password:",
          labelStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
      obscureText: true,
      onSaved: (String? value) {
        doctor.password = value!;
      },
    );
  }

  Widget _nameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Name:",
          labelStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
      validator: validateFirstName,
      onSaved: (String? value) {
        doctor.name = value!;
      },
    );
  }

  Widget _surnameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Lastname:",
          labelStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
      validator: validateLastName,
      onSaved: (String? value) {
        doctor.surname = value!;
      },
    );
  }

  Widget placeofBirthField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Birthplace",
          labelStyle: TextStyle(fontWeight: FontWeight.bold)),
      onSaved: (String? value) {
        doctor.placeOfBirth = value!;
      },
    );
  }

  Widget genderChoose() {
    return Container(
        padding: EdgeInsets.only(top: 13.0),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 25.0),
              child: Text(
                "Gender: ",
                style: TextStyle(fontSize: 19.0),
              ),
            ),
            DropdownButton<String>(
              items: genders.map((String genders) {
                return DropdownMenuItem<String>(
                  value: genders,
                  child: Text(genders),
                );
              }).toList(),
              value: selectedGenders,
              onChanged: (String? clicked) {
                setState(() {
                  if (clicked == null) {
                    this.selectedGenders = "Female";
                  } else {
                    this.selectedGenders = clicked;
                  }
                  doctor.gender = selectedGenders;
                });
              },
            ),
          ],
        ));
  }

  Widget dateOfBirthWidget() {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Row(
        children: <Widget>[
          Text(
            "Date of birth: ",
            style: TextStyle(fontSize: 19.0),
          ),
          RaisedButton(
            child: Text(raisedButtonText),
            onPressed: () {
              _selectDate(context).then((result) => setState(() {
                    raisedButtonText = dateOfBirth.toString().substring(0, 10);
                    doctor.dateOfBirth =
                        dateOfBirth.toString().substring(0, 10);
                  }));
            },
          )
        ],
      ),
    );
  }

  void alrtHospital(BuildContext context, String message) {
    var alertDoctor = AlertDialog(
      title: Text("Warning!"),
      content: Text(message),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDoctor;
        });
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
              "Selected Department : ",
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

  _buildDoneButton() {
    return Container(
      padding: EdgeInsets.only(top: 17.0),
      child: RaisedButton(
        child: Text(
          "Complete",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          if (hospitalSelected &&
              departmentSelected &&
              formKey.currentState!.validate()) {
            formKey.currentState?.save();
            SearchService()
                .searchDoctorById(doctor.idNo)
                .then((QuerySnapshot docs) {
              if (docs.docs.isEmpty) {
                AddService()
                    .saveDoctor(this.doctor, this.department, this.hospital);
                Navigator.pop(context, true);
              } else {
                alrtHospital(context, "A doctor with this ID already exists");
              }
            });
          } else {
            alrtHospital(context,
                "To complete the transaction, you must fill in the required fields");
          }
        },
      ),
    );
  }
}
