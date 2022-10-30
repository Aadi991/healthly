import 'package:healthly/dbHelper/addData.dart';
import 'package:healthly/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:healthly/mixins/validation_mixin.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterPageState();
  }
}

class RegisterPageState extends State with ValidationMixin {
  final registerFormKey = GlobalKey<FormState>();
  final user = User.empty();

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
          title: Text("New Member Registration"),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
              child: Form(
                key: registerFormKey,
                child: Column(
                  children: <Widget>[
                    idNoField(),
                    passwordField(),
                    firstNameField(),
                    lastNameField(),
                    placeofBirthField(),
                    genderChoose(),
                    dateOfBirthWidget(),
                    submitButton()
                  ],
                ),
              )),
        ));
  }

  static void alrtDone(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("Registration Successful"),
      content: Text("You can login"),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  static void alrtFail(BuildContext context) {
    var alertDialog = AlertDialog(
      title: Text("Login Failed"),
      content: Text("You entered incorrect or missing information"),
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  void basicPop(BuildContext context, bool result) {
    Navigator.pop(context, result);
  }

  Widget idNoField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "T.R. Identity Number:"),
      validator: validateTCNo,
      onSaved: (String? value) {
        user.idNo = value!;
      },
    );
  }

  Widget passwordField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Password:"),
      onSaved: (String? value) {
        user.password = value!;
      },
    );
  }

  Widget firstNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Name"),
      validator: validateFirstName,
      onSaved: (String? value) {
        user.name = value!;
      },
    );
  }

  Widget lastNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Last Name"),
      validator: validateLastName,
      onSaved: (String? value) {
        user.surname = value!;
      },
    );
  }

  Widget placeofBirthField() {
    return TextFormField(
      decoration: InputDecoration(labelText: "Birthplace"),
      onSaved: (String? value) {
        user.placeOfBirth = value!;
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
                  user.gender = selectedGenders;
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
          ElevatedButton(
            child: Text(raisedButtonText),
            onPressed: () {
              _selectDate(context).then((result) => setState(() {
                    raisedButtonText = dateOfBirth.toString().substring(0, 10);
                    user.dateOfBirth = dateOfBirth.toString().substring(0, 10);
                  }));
            },
          )
        ],
      ),
    );
  }

  Widget submitButton() {
    return Container(
      padding: EdgeInsets.only(top: 45.0),
      child: ElevatedButton(
        child: Text(
          "Complete",
          textDirection: TextDirection.ltr,
          style: TextStyle(fontSize: 20.0),
        ),
        onPressed: () {
          if (registerFormKey.currentState!.validate()) {
            registerFormKey.currentState?.save();
            basicPop(context, true);
            AddService().saveUser(user);
          }
          // else {
          // alrtFail(context);
          // }
        },
      ),
    );
  }
}
