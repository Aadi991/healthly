import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/dbHelper/searchData.dart';
import 'package:healthly/dbHelper/updateData.dart';
import 'package:healthly/models/doctorModel.dart';
import 'package:flutter/material.dart';

class OnlyUpdatePassword extends StatefulWidget {
  final doctor;
  OnlyUpdatePassword(this.doctor);
  @override
  _OnlyUpdatePasswordState createState() => _OnlyUpdatePasswordState(doctor);
}

class _OnlyUpdatePasswordState extends State<OnlyUpdatePassword> {
  Doctor doctor;
  _OnlyUpdatePasswordState(this.doctor);
  get formKey => GlobalKey<FormState>();
  String? newPassword;
  String? oldpassword;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Update Password"),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: 100.0, left: 20.0, right: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    oldPassword(),
                    SizedBox(
                      height: 13.0,
                    ),
                    passwordField(),
                    SizedBox(
                      height: 45.0,
                    ),
                    submitButton()
                  ],
                ),
              )),
        ));
  }

  Widget passwordField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "New Password",
          labelStyle:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      onSaved: (String? value) {
        newPassword = value!;
      },
      obscureText: true,
    );
  }

  Widget oldPassword() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Old Password",
          labelStyle:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      onSaved: (String? value) {
        oldpassword = value!;
      },
      obscureText: true,
    );
  }

  submitButton() {
    return Container(
      child: ElevatedButton(
        child: Text("Complete"),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState?.save();
            if (doctor.password != newPassword && doctor.password == oldPassword) {
              doctor.password = newPassword!;
              SearchService()
                  .searchDoctorById(doctor.idNo)
                  .then((QuerySnapshot docs) {
                doctor.reference = docs.docs[0].reference;
                UpdateService().updateDoctor(doctor);
              });

              Navigator.pop(context, true);
            } else {
              alrtHospital(context, "You entered incorrect or missing information...");
            }
          } else {
            alrtHospital(context, "You entered incorrect or missing information...");
          }
        },
      ),
    );
  }

  void alrtHospital(BuildContext context, String message) {
    var alertDoctor = AlertDialog(
      title: Text(
        "Information!",
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