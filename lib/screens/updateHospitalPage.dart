import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/dbHelper/searchData.dart';
import 'package:healthly/dbHelper/updateData.dart';
import 'package:healthly/models/hospitalModel.dart';
import 'package:healthly/screens/showHospitals.dart';
import 'package:flutter/material.dart';
import 'package:healthly/mixins/validation_mixin.dart';

class UpdateHospital extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return UpdateHospitalState();
  }
}

class UpdateHospitalState extends State with ValidationMixin {
  Hospital hospital = Hospital.empty();
  bool hospitalSelected = false;
  double image = 0.0;
  late String newName;
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Hospital Update Screen",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 50.0, left: 20.0, right: 18.0),
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
                    SizedBox(height: 13.0),
                    showSelectedHospital(hospitalSelected),
                    SizedBox(
                      height: 30.0,
                    ),
                    _newHospitalName(),
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

  _newHospitalName() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Enter New Hospital Name:",
          labelStyle: TextStyle(
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
              color: Colors.black)),
      validator: validateFirstName,
      onSaved: (String? value) {
        newName = value!;
      },
    );
  }

  void hospitalNavigator(dynamic page) async {
    hospital = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
    print(hospital.hospitalName);

    if (hospital.hospitalName == null) {
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

  _updateButton() {
    return Container(
      child: ElevatedButton(
        child: Text(
          "Update Hospital",
          textDirection: TextDirection.ltr,
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState?.save();
            SearchService()
                .searchHospitalByName(newName)
                .then((QuerySnapshot docs) {
              if (docs.docs.isEmpty && newName != hospital.hospitalName) {
                hospital.hospitalName = newName;
                UpdateService().updateHospital(hospital);
                Navigator.pop(context, true);
              } else {
                alrtHospital(context, "A hospital with this name already exists");
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