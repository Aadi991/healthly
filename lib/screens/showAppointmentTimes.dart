import 'package:healthly/models/doctorModel.dart';
import 'package:flutter/material.dart';

class AppointmentTimes extends StatefulWidget {
  final String appointmentDate;
  final doctor;
  AppointmentTimes(this.appointmentDate, this.doctor);

  @override
  _AppointmentTimesState createState() =>
      _AppointmentTimesState(appointmentDate, doctor);
}

class _AppointmentTimesState extends State<AppointmentTimes> {
  String appointmentDate;
  Doctor doctor;
  List<String> union = [];
  List<bool> unionControl = [];
  List<String> hours = [
    " , 09:00",
    " , 10:00",
    " , 11:00",
    " , 13:00",
    " , 14:00",
    " , 15:00",
    " , 16:00"
  ];

  var result = "Select";

  _AppointmentTimesState(this.appointmentDate, this.doctor);

  @override
  void initState() {
    super.initState();
    for (var item in hours) {
      union
          .add((appointmentDate.toString().substring(0, 10) + item).toString());
    }
    for (var i = 0; i < union.length; i++) {
      if (doctor.appointments.contains(union[i])) {
        unionControl.insert(i, false);
      } else {
        unionControl.insert(i, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.access_time),
          centerTitle: true,
          title: Text("Appointment Hours"),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 50.0, left: 25.0, right:30.0),
          child: Column(
            children: <Widget>[
              Container(
                child: Text(
                  "Specified hours are appointment start times. 1 hour is allocated for each appointment.",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                      color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              chooserTime(),
            ],
          ),
        ));
  }

  chooserTime() {
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildText("09:00"),
              _buildButton(0, result),
              _buildText("10:00"),
              _buildButton(1, result),
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildText("11:00"),
              SizedBox(
                width: 20.0,
              ),
              _buildButton(2, result),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 13.0, bottom: 13.0),
          child: Text(
            "Lunch Break",
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildText("13:00"),
              _buildButton(3, result),
              _buildText("14:00"),
              _buildButton(4, result),
            ],
          ),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _buildText("15:00"),
              _buildButton(5, result),
              _buildText("16:00"),
              _buildButton(6, result),
            ],
          ),
        ),
      ],
    );
  }

  _buildText(String time) {
    return Text(
      time,
      style: TextStyle(fontSize: 19.0, fontWeight: FontWeight.bold),
    );
  }

  _buildButton(int index, String textMessage) {
    chooseColor() {
      if (unionControl[index]) {
        return Colors.greenAccent;
      } else {
        return Colors.redAccent;
      }
    }

    return Container(
      decoration: BoxDecoration(color: chooseColor()),
      child: FlatButton(
        child: Text(
          textMessage,
          style: TextStyle(fontSize: 12.0),
        ),
        onPressed: () {
          _buttonPressEvent(index);
        },
      ),
    );
  }

  _buttonPressEvent(int index) {
    if (unionControl[index]) {
      Navigator.pop(context, union[index]);
    } else {
      alrtHospital(context, "This session cannot be selected.");
    }
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
}