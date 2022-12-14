import 'package:healthly/models/userModel.dart';
import 'package:healthly/screens/appointmentHistory.dart';
import 'package:healthly/screens/makeAppointment.dart';
import 'package:healthly/screens/showActiveAppo.dart';
import 'package:healthly/screens/showUserFavList.dart';
import 'package:healthly/screens/updateUserInfo.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatefulWidget {
  final User user;

  UserHomePage(this.user);

  @override
  State<StatefulWidget> createState() {
    return UserHomePageState(user);
  }
}

class UserHomePageState extends State {
  User user;

  UserHomePageState(this.user);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery
        .of(context)
        .size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          centerTitle: true,
          title: Text("User Homepage"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    top: 30.0, left: 5.0, right: 5.0, bottom: 25.0),
                color: Colors.blueAccent[200],
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18.0),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 13.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 18.0),
                            child: Icon(
                              Icons.person,
                              size: 50.0,
                            ),
                          ),
                          SizedBox(
                            width: 3.0,
                          ),
                          Container(
                            child: Text(
                              user.name,
                              style: TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Container(
                            child: Text(
                              user.surname,
                              style: TextStyle(
                                  fontSize: 30.0, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      Container(
                        color: Colors.grey,
                        width: 370.0,
                        height: 0.4,
                      ),
                      _buildAttributeRow(
                          "T.R. Identity Number", user.idNo),
                      _buildAttributeRow(
                          "Gender", user.gender.toString()),
                      _buildAttributeRow(
                          "Birthplace", user.placeOfBirth.toString()),
                      _buildAttributeRow(
                          "Date of Birth", user.dateOfBirth.toString()),
                      SizedBox(
                        height: 30.0,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: screenSize.width,
                height: screenSize.height / 2,
                color: Colors.blueAccent[200],
                child: Column(
                  children: <Widget>[
                    _makeAppointmentButton(),
                    SizedBox(
                      height: 5.0,
                    ),
                    _activeAppointmentsButton(),
                    SizedBox(
                      height: 5.0,
                    ),
                    _appointmentDelayButton(),
                    SizedBox(
                      height: 5.0,
                    ),
                    _accountInfoButton(),
                    SizedBox(
                      height: 5.0,
                    ),
                    _favoriteListButton(),
                    SizedBox(
                      height: 5.0,
                    ),
                    _exitButton()
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget _buildAttributeRow(var textMessage, var textValue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20.0, left: 13.0),
          child: Container(
            alignment: Alignment.center,
            color: Colors.greenAccent,
            width: 200.0,
            height: 25.0,
            child: Text(
              textMessage,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          width: 25.0,
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.0, left: 13.0),
          child: Container(
            child: Text(
              textValue,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  _makeAppointmentButton() {
    return Container(
      padding: EdgeInsets.all(1.0),
      width: 390.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white),
      child: FlatButton(
          splashColor: Colors.grey,
          highlightColor: Colors.white70,
          child: Text(
            "Make an appointment",
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            basicNavigator(MakeAppointment(user),
                "Your Appointment Received Successfully. Get Well Soon :)");
          }),
    );
  }

  _appointmentDelayButton() {
    return Container(
      padding: EdgeInsets.all(1.0),
      width: 390.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white),
      child: FlatButton(
        splashColor: Colors.grey,
        highlightColor: Colors.white70,
        child: Text(
          "Appointment History",
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () =>
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AppointmentHistory(user))),
      ),
    );
  }

  _activeAppointmentsButton() {
    return Container(
      padding: EdgeInsets.all(1.0),
      width: 390.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white),
      child: FlatButton(
          splashColor: Colors.grey,
          highlightColor: Colors.white70,
          child: Text(
            "List Active Appointments",
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            basicNavigator(BuildAppointmentList(user), "Operation Complete");
          }),
    );
  }

  _favoriteListButton() {
    return Container(
      padding: EdgeInsets.all(1.0),
      width: 390.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white),
      child: FlatButton(
          splashColor: Colors.grey,
          highlightColor: Colors.white70,
          child: Text(
            "View Favorites",
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
          ),
          onPressed: () {
            basicNavigator(BuildUserFavList(user), "Operation Complete");
          }),
    );
  }

  _accountInfoButton() {
    return Container(
      padding: EdgeInsets.all(1.0),
      width: 390.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white),
      child: FlatButton(
        splashColor: Colors.grey,
        highlightColor: Colors.white70,
        child: Text(
          "Update Information",
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          basicNavigator(UpdateUser(user), "Operation Complete");
        },
      ),
    );
  }

  void basicNavigator(dynamic page, String message) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (result != null && result == true) {
      alrtHospital(context, message);
    }
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
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}