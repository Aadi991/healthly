import 'package:healthly/models/adminModel.dart';
import 'package:healthly/screens/addDoctorPage.dart';
import 'package:healthly/screens/addHospitalPage.dart';
import 'package:healthly/screens/addDepartmentPage.dart';
import 'package:healthly/screens/deleteDoctorPage.dart';
import 'package:healthly/screens/deleteHospitalPage.dart';
import 'package:healthly/screens/deleteDepartmentPage.dart';
import 'package:healthly/screens/closeAppointmentPage.dart';
import 'package:healthly/screens/openAppointmentPage.dart';
import 'package:healthly/screens/updateDoctorPage.dart';
import 'package:healthly/screens/updateHospitalPage.dart';
import 'package:healthly/screens/updateDepartmentPage.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  final Admin admin;

  AdminHomePage(this.admin);

  @override
  _AdminHomePageState createState() => _AdminHomePageState(admin);
}

class _AdminHomePageState extends State<AdminHomePage> {
  Admin _admin;

  _AdminHomePageState(this._admin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        appBar: AppBar(
          leading: Icon(Icons.timeline),
          backgroundColor: Colors.deepOrangeAccent,
          title: Text(
            "Admin Home Page",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _bodyTitle(),
              _buildTitle("Hospital Operations"),
              SizedBox(
                height: 9.0,
              ),
              _hospitalOperationButtons(),
              SizedBox(
                height: 9.0,
              ),
              _buildTitle("Department Actions"),
              SizedBox(
                height: 9.0,
              ),
              _departmentOperationButtons(),
              SizedBox(
                height: 9.0,
              ),
              _buildTitle("Doctor Actions"),
              SizedBox(
                height: 9.0,
              ),
              _doctorProcessButtons(),
              SizedBox(
                height: 9.0,
              ),
              _buildTitle("Other Actions"),
              SizedBox(
                height: 9.0,
              ),
              _otherActionButtons()
            ],
          ),
        ));
  }

  _bodyTitle() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10.0, left: 26.0, right: 26.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 10.0,
          ),
          Text(
            "Id:" + _admin.id.toString(),
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 10.0,
          ),
          Text(
            _admin.nickname,
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  _buildTitle(String textMessage) {
    return Container(
      padding: EdgeInsets.only(top: 18.0, left: 15.0, right: 15.0),
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 15.0),
            alignment: Alignment.centerLeft,
            child: Text(
              textMessage,
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            height: 2.0,
          ),
          Container(
            color: Colors.grey,
            width: 370.0,
            height: 0.7,
          ),
        ],
      ),
    );
  }

  _hospitalOperationButtons() {
    return Container(
      child: Column(
        children: <Widget>[
          createButton("Update Hospital", 0),
          SizedBox(
            height: 5.0,
          ),
          createButton("Add Hospital", 1),
          SizedBox(
            height: 5.0,
          ),
          createButton("Delete Hospital", 2),
        ],
      ),
    );
  }

  _departmentOperationButtons() {
    return Container(
      child: Column(
        children: <Widget>[
          createButton("Update Department", 3),
          SizedBox(
            height: 5.0,
          ),
          createButton("Add Department", 4),
          SizedBox(
            height: 5.0,
          ),
          createButton("Delete Department", 5),
        ],
      ),
    );
  }

  _doctorProcessButtons() {
    return Container(
      child: Column(
        children: <Widget>[
          createButton("Update Doctor", 6),
          SizedBox(
            height: 5.0,
          ),
          createButton("Add Doctor", 7),
          SizedBox(
            height: 5.0,
          ),
          createButton("Delete Doctor", 8),
        ],
      ),
    );
  }

  _otherActionButtons() {
    return Container(
      child: Column(
        children: <Widget>[
          createButton("Close Appointment", 9),
          SizedBox(
            height: 5.0,
          ),
          createButton("Make Appointment", 10),
          SizedBox(
            height: 5.0,
          ),
          createButton("Logout", 11),
        ],
      ),
    );
  }

  createButton(String textMessage, int buttonIndex) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      child: FlatButton(
        child: Text(
          textMessage,
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          switch (buttonIndex) {
            case 0:
              basicNavigator(UpdateHospital());

              break;
            case 1:
              basicNavigator(AddHospital());

              break;
            case 2:
              basicNavigator(DeleteHospital());

              break;
            case 3:
              basicNavigator(UpdateDepartment());
              break;
            case 4:
              basicNavigator(AddDepartment());

              break;
            case 5:
              basicNavigator(DeleteDepartment());

              break;
            case 6:
              basicNavigator(UpdateDoctor());

              break;
            case 7:
              basicNavigator(AddDoctor());

              break;
            case 8:
              basicNavigator(DeleteDoctor());

              break;
            case 9:
              basicNavigator(CloseAppointment(_admin));

              break;
            case 10:
              basicNavigator(OpenAppointment(_admin));

              break;
            case 11:
              Navigator.pop(context); //logout

              break;
            default:
          }
        },
      ),
    );
  }

  void basicNavigator(dynamic page) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (result != null && result == true) {
      alrtDone(context, "Operation Completed");
    }
  }

  void alrtDone(BuildContext context, String message) {
    var alertDoctor = AlertDialog(
      title: Text(
        "Conclusion",
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
