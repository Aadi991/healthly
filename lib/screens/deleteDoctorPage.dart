import 'package:healthly/dbHelper/delData.dart';
import 'package:healthly/models/doctorModel.dart';
import 'package:healthly/models/hospitalModel.dart';
import 'package:healthly/models/departmentModel.dart';
import 'package:healthly/screens/showDoctors.dart';
import 'package:healthly/screens/showHospitals.dart';
import 'package:healthly/screens/showDepartments.dart';
import 'package:flutter/material.dart';

class DeleteDoctor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DeleteDoctorState();
  }
}

class DeleteDoctorState extends State {
  Hospital hospital = Hospital.empty();
  Department department = Department.empty();
  Doctor doctor = Doctor.empty();
  double image = 0.0;
  double drImage = 0.0;
  bool hospitalSelected = false;
  bool departmentSelected = false;
  bool doctorSelected = false;
  String textMessage = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Doctor Erase Screen",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
                      child: Text("Click to Select Hospital"),
                      onPressed: () {
                        departmentSelected = false;
                        doctorSelected = false;
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
                          doctorSelected = false;
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
                      height: 16.0,
                    ),
                    ElevatedButton(
                      child: Text("Click to Select Doctor"),
                      onPressed: () {
                        if (hospitalSelected && departmentSelected) {
                          doctorNavigator(BuildDoctorList(department, hospital));
                        } else {
                          alrtHospital(context,
                              "You cannot choose a doctor without choosing a hospital and department");
                        }
                      },
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    showSelectedDoctor(doctorSelected),
                    SizedBox(
                      height: 25.0,
                    ),
                    _deleteButton()
                  ],
                ),
              ),
            )
          ],
        ),
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
      hospitalSelected = false;
    } else {
      hospitalSelected = true;
    }
  }

  void departmentNavigator(dynamic page) async {
    department = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (department == null) {
      departmentSelected = false;
    } else {
      departmentSelected = true;
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

  void doctorNavigator(dynamic page) async {
    doctor = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (doctor == null) {
      doctorSelected = false;
    } else {
      doctorSelected = true;
    }
  }

  showSelectedDoctor(bool selectedMih) {
    String textMessage = " ";
    if (selectedMih) {
      setState(() {
        textMessage = this.doctor.name.toString() + " " + this.doctor.surname;
      });
      drImage = 1.0;
    } else {
      drImage = 0.0;
    }

    return Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            Text(
              "The Chosen Doctor : ",
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

  _deleteButton() {
    return Container(
      child: ElevatedButton(
        child: Text(
          "Delete Selected Doctor",
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: () {
          if (hospitalSelected && departmentSelected && doctorSelected) {
            DelService().deleteDoctorbyTCKN(doctor);
            Navigator.pop(context, true);
          } else {
            alrtHospital(context, "Missing information");
          }
        },
      ),
    );
  }
}