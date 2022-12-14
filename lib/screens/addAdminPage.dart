import 'package:healthly/models/adminModel.dart';
import 'package:flutter/material.dart';
import 'package:healthly/mixins/validation_mixin.dart';

class AddAdmin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddAdminState();
  }
}

class AddAdminState extends State with ValidationMixin {
  late Admin admin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Add Admin",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 20.0, left: 9.0, right: 9.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    _nickNameField(),
                    _passwordField(),
                    SizedBox(
                      height: 30.0,
                    ),
                    _saveButton(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 10.0, left: 8.0, right: 8.0),
        child: _exitButton(),
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Password:",
          labelStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
      obscureText: true,
      onSaved: (String? value) {
        admin.password = value!;
      },
    );
  }

  Widget _nickNameField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Nickname:",
          labelStyle: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold)),
      validator: validateFirstName,
      onSaved: (String? value) {
        admin.nickname = value!;
      },
    );
  }

  _saveButton() {
    return ElevatedButton(
      child: Text(
        "Add New Admin",
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 20.0),
      ),
      onPressed: () {},
    );
  }

  _exitButton() {
    return Container(
      padding: EdgeInsets.all(1.0),
      width: 390.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.redAccent),
      child: FlatButton(
        splashColor: Colors.grey,
        highlightColor: Colors.white70,
        child: Text(
          "Safe Exit",
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () {},
      ),
    );
  }
}