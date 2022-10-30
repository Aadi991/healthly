import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/dbHelper/searchData.dart';
import 'package:healthly/dbHelper/updateData.dart';
import 'package:healthly/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:healthly/mixins/validation_mixin.dart';

class UpdateUser extends StatefulWidget {
  final User user;
  UpdateUser(this.user);
  @override
  _UpdateUserState createState() => _UpdateUserState(user);
}

class _UpdateUserState extends State<UpdateUser> with ValidationMixin {
  _UpdateUserState(this.user);
  User user = User.empty();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Information"),
      ),
      backgroundColor: Colors.limeAccent,
      body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 35.0, left: 13.0, right: 13.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                firstNameField(),
                lastNameField(),
                passwordField(),
                SizedBox(
                  height: 25.0,
                ),
                buildSubmitButton()
              ],
            ),
          )),
    );
  }

  Widget passwordField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Password",
          labelStyle:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      onSaved: (String? value) {
        user.password = value!;
      },
      obscureText: true,
    );
  }

  Widget firstNameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Name",
          labelStyle:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      validator: validateFirstName,
      onSaved: (String? value) {
        user.name = value!;
      },
    );
  }

  Widget lastNameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Surname",
          labelStyle:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      validator: validateLastName,
      onSaved: (String? value) {
        user.surname = value!;
      },
    );
  }

  buildSubmitButton() {
    return Container(
      padding: EdgeInsets.only(right: 5.0, left: 5.0),
      width: 200.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(13.0),
          ),
          color: Colors.black),
      child: ElevatedButton(
        child: Text("Complete",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 20.0)),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState?.save();
            SearchService()
                .searchUserById(user.idNo)
                .then((QuerySnapshot docs) {
              user.reference = docs.docs[0].reference;
              UpdateService().updateUser(user);
            });

            Navigator.pop(context, true);
          }
        },
      ),
    );
  }
}