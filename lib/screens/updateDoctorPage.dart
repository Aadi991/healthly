import 'package:healthly/dbHelper/updateData.dart';
import 'package:healthly/models/doctorModel.dart';
import 'package:healthly/models/hospitalModel.dart';
import 'package:healthly/models/departmentModel.dart';
import 'package:healthly/screens/showDoctors.dart';
import 'package:healthly/screens/showHospitals.dart';
import 'package:healthly/screens/showDepartments.dart';
import 'package:flutter/material.dart';
import 'package:healthly/mixins/validation_mixin.dart';

class UpdateDoctor extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UpdateDoctorState();
  }
}

class UpdateDoctorState extends State with ValidationMixin {
  Hospital hospital = Hospital.empty();
  Doctor doctor = Doctor.empty();
  double image = 0.0;
  double drImage = 0.0;
  bool hospitalSelected = false;
  bool departmentSelected = false;
  bool doctorSelected = false;
  Department department = Department.empty();
  String textMessage = " ";
  late String newName, newLastName, newPassword;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Doctor Update Screen",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 13.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Text(
                        "Step 1: Select the doctor to update",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                    ElevatedButton(
                      child: Text("Click to Select Hospital"),
                      onPressed: () {
                        departmentSelected = false;
                        doctorSelected = false;
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
                    Container(
                      height: 1.3,
                      width: 350.0,
                      color: Colors.green,
                    ),
                    Container(
                      child: Text(
                        "Step 2: Enter the current information of the doctor you have chosen",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                    _newDoctorName(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _newDoctorLastname(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _newDoctorPassword(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _updateButton()
                  ],
                ),
              ),)
          ],
        ),
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

  _newDoctorName() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Name :",
          labelStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
      validator: validateFirstName,
      onSaved: (String? value) {
        newName = value!;
      },
    );
  }

  _newDoctorLastname() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Last Name :",
          labelStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
      validator: validateLastName,
      onSaved: (String? value) {
        newLastName = value!;
      },
    );
  }

  _newDoctorPassword() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Password:",
          labelStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
      validator: validateLastName,
      onSaved: (String? value) {
        newPassword = value!;
      },
    );
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

  _updateButton() {
    return ElevatedButton(
      child: Text(
        "Update Doctor",
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 20.0),
      ),
      onPressed: () {
        if (hospitalSelected && departmentSelected&&doctorSelected) {
          if (formKey.currentState!.validate()) {
            formKey.currentState?.save();
            doctor.name = newName;
            doctor.surname = newLastName;
            doctor.password = newPassword;

            UpdateService().updateDoctor(doctor);
            Navigator.pop(context, true);
          }
        } else {
          alrtHospital(context, "There is incomplete information");
        }
      },
    );
  }
}