import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/dbHelper/addData.dart';
import 'package:healthly/dbHelper/searchData.dart';
import 'package:healthly/models/adminModel.dart';
import 'package:healthly/models/doctorModel.dart';
import 'package:healthly/models/hospitalModel.dart';
import 'package:healthly/models/departmentModel.dart';
import 'package:healthly/models/userModel.dart';
import 'package:healthly/screens/showAppoTimesForAdmin.dart';
import 'package:healthly/screens/showHospitals.dart';
import 'package:healthly/screens/showDepartments.dart';
import 'package:flutter/material.dart';

import 'showDoctors.dart';

class OpenAppointment extends StatefulWidget {
  final Admin admin;

  OpenAppointment(this.admin);

  @override
  OpenAppointmentState createState() => OpenAppointmentState(admin);
}

class OpenAppointmentState extends State<OpenAppointment> {
  Admin _admin;

  OpenAppointmentState(this._admin);

  bool hospitalSelected = false;
  bool departmentSelected = false;
  bool doctorSelected = false;
  bool dateSelected = false;
  bool? appointmentControl1;
  bool? appointmentControl2;

  double drImage = 0.0;
  double image = 0.0;

  Hospital hospital = Hospital.empty();
  Department department = Department.empty();
  Doctor doctor = Doctor.empty();
  User user = User.empty();

  String textMessage = " ";

  var appointmentDate;
  var raisedButtonText = "Click and Select";

  var timeDatejoint;

  double imageHour = 0.0;

  @override
  Widget build(BuildContext context) {
    setState(() {
      FirebaseFirestore.instance
          .collection('tblAdmin')
          .get()
          .then((QuerySnapshot docs) {
        _admin.reference = docs.docs[0].reference;
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Make a Doctor Appointment",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 20.0, left: 9.0, right: 9.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  ElevatedButton(
                    child: Text("Click to Select Hospital"),
                    onPressed: () {
                      departmentSelected = false;
                      doctorSelected = false;
                      dateSelected = false;
                      hospitalNavigator(BuildHospitalList());
                    },
                  ),
                  SizedBox(height: 13.0),
                  showSelectedHospital(hospitalSelected),
                  SizedBox(
                    height: 30.0,
                  ),
                  ElevatedButton(
                    child: Text("Click to Select Department"),
                    onPressed: () {
                      if (hospitalSelected) {
                        doctorSelected = false;
                        drImage = 0.0;
                        dateSelected = false;
                        departmentNavigator(BuildDepartmentList(hospital));
                      } else {
                        alrtHospital(
                            context,
                            "You cannot select a department without selecting a hospital");
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
                  dateOfAppointment(),
                  SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton(
                    child: Text("Click to Select Processing Time"),
                    onPressed: () {
                      if (appointmentDate != null &&
                          hospitalSelected &&
                      departmentSelected &&
                      doctorSelected) {
                        basicNavigator(AppointmentTimesForAdmin(
                            appointmentDate.toString(), doctor, _admin));
                        dateSelected = true;
                      } else {
                        alrtHospital(context,
                            "It is not possible to switch to the clock selection until the selections are completed");
                      }
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  showSelectedDate(dateSelected),
                  SizedBox(
                    height: 16.0,
                  ),
                  _buildDoneButton()
                ],
              ),
            ),
          )
        ],
      ),
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

  void departmentNavigator(dynamic page) async {
    department = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (department == null) {
      departmentSelected = false;
    } else {
      departmentSelected = true;
    }
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2021),
    );
    appointmentDate = picked;
    timeDatejoint = null;
    dateSelected = false;
  }

  Widget dateOfAppointment() {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Row(
        children: <Widget>[
          Text(
            "Transaction date: ",
            style: TextStyle(fontSize: 19.0),
          ),
          ElevatedButton(
            child: Text(raisedButtonText),
            onPressed: () {
              _selectDate(context).then((result) =>
                  setState(() {
                    if (appointmentDate == null) {
                      raisedButtonText = "Click and Select";
                      dateSelected = false;
                    } else {
                      raisedButtonText =
                          appointmentDate.toString().substring(0, 10);
                    }
                  }));
            },
          )
        ],
      ),
    );
  }

  showSelectedDate(bool dateSelected) {
    String textMessage = " ";
    if (dateSelected) {
      setState(() {
        textMessage = timeDatejoint.toString();
      });
      imageHour = 1.0;
    } else {
      imageHour = 0.0;
    }

    return Container(
        decoration: BoxDecoration(),
        child: Row(
          children: <Widget>[
            Text(
              "Transaction Date and Time: ",
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Opacity(
                opacity: imageHour,
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

  void basicNavigator(dynamic page) async {
    timeDatejoint = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
  }

  void alrtAppointment(BuildContext context) {
    var alertAppointment = AlertDialog(
        contentPadding: const EdgeInsets.fromLTRB(5.0, 50.0, 5.0, 50.0),
        title: Text(
          "Transaction Summary",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Container(
          padding: EdgeInsets.only(bottom: 50.0),
          child: Column(
            children: <Widget>[
              showSelectedHospital(hospitalSelected),
              _showSelectedDepartment(departmentSelected),
              showSelectedDoctor(doctorSelected),
              showSelectedDate(dateSelected),
              SizedBox(
                height: 13.0,
              ),
              Container(
                child: FlatButton(
                  child: Text(
                    "OK",
                    style:
                    TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context, true);
                    AddService().addDoctorAppointment(doctor);
                    AddService().closeDoctorAppointment(_admin);
                  },
                ),
              ),
            ],
          ),
        ));

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertAppointment;
        });
  }

  _buildDoneButton() {
    return Container(
      child: ElevatedButton(
        child: Text("Complete"),
        onPressed: () {
          if (hospitalSelected &&
              departmentSelected &&
         doctorSelected &&
          dateSelected &&
              timeDatejoint != null) {
            SearchService()
                .searchDoctorById(doctor.idNo)
                .then((QuerySnapshot docs) {
              Doctor temp = Doctor.fromMap(
                  docs.docs[0].data as Map<String, dynamic>);
              if (temp.appointments.contains(timeDatejoint)) {
                doctor.appointments.remove(timeDatejoint);
                _admin.closedHours.remove(timeDatejoint);
                alrtAppointment(context);
              } else {
                alrtHospital(context, "This session is full");
              }
            });
          } else {
            alrtHospital(context, "Missing information");
          }
        },
      ),
    );
  }
}