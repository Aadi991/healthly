import 'package:healthly/dbHelper/delData.dart';
import 'package:healthly/models/hospitalModel.dart';
import 'package:healthly/screens/showHospitals.dart';
import 'package:flutter/material.dart';

class DeleteHospital extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DeleteHospitalState();
  }
}

class DeleteHospitalState extends State {
  Hospital hospital = Hospital.empty();
  bool hospitalSelected = false;
  double image = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        title: Text(
          "Hospital Delete Screen",
          style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 15.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 1.0,
                    ),
                    Container(
                      child: Text(
                        "WARNING!",
                        style: TextStyle(
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent),
                      ),
                    ),
                    Container(
                      child: Text(
                        "When you delete a hospital, you will also delete all departments, doctors and active appointments of that hospital.",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    ElevatedButton(
                      child: Text("Click to Select Hospital"),
                      onPressed: () {
                        hospitalNavigator(BuildHospitalList());
                      },
                    ),
                    SizedBox(height: 13.0),
                    Container(
                      child: showSelectedHospital(hospitalSelected),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    _deleteButton()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void hospitalNavigator(dynamic page) async {
    hospital = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (hospital == null) {
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

  _deleteButton() {
    return ElevatedButton(
      child: Text(
        "Delete Selected Hospital",
        textDirection: TextDirection.ltr,
        style: TextStyle(fontSize: 20.0),
      ),
      onPressed: () {
        if (hospitalSelected) {
          alrtDeleteHospital(context);
        } else {
          alrtHospital(context, "Missing data");
        }
      },
    );
  }

  void alrtDeleteHospital(BuildContext context) {
    var alrtAppointment = AlertDialog(
      title: Text(
        " Along with the hospital, all departments registered to the hospital, department doctors and doctor appointments will be deleted. Do you want to continue?",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(width: 5.0,),
        FlatButton(
          child: Text(
            "Yes",
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            DelService().deleteHospitalById(hospital);
            Navigator.pop(context);
            Navigator.pop(context, true);
          },
        )
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alrtAppointment;
        });
  }
}
