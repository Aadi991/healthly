import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/dbHelper/searchData.dart';
import 'package:healthly/models/doctorModel.dart';
import 'package:healthly/models/hospitalModel.dart';
import 'package:healthly/models/departmentModel.dart';
import 'package:healthly/screens/showAppoForDoc.dart';
import 'package:healthly/screens/updateDoctorPass.dart';
import 'package:flutter/material.dart';

class DoctorHomePage extends StatefulWidget {
  final doctor;

  DoctorHomePage(this.doctor);

  @override
  _DoctorHomePageState createState() => _DoctorHomePageState(doctor);
}

class _DoctorHomePageState extends State<DoctorHomePage> {
  Doctor _doctor;


  String hospitalName = "", departmentName = "";

  _DoctorHomePageState(this._doctor);

  Hospital hospital = Hospital.empty();
  Department department = Department.empty();

  @override
  void initState() {
    super.initState();
    hospital = Hospital.empty();
    department = Department.empty();

    SearchService()
        .searchHospitalById(_doctor.hospitalId)
        .then((QuerySnapshot docs) {
      if (docs.docs.isNotEmpty) {
        this.hospital =
            Hospital.fromMap(docs.docs[0].data() as Map<String, dynamic>);
      }
    });
    SearchService()
        .searchDepartmentById(_doctor.departmentId)
        .then((QuerySnapshot docs) {
      if (docs.docs.isNotEmpty) {
        this.department =
            Department.fromMap(docs.docs[0].data() as Map<String, dynamic>);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    hospitalName = hospital.hospitalName.toString();
    departmentName = department.departmentName;
    return Scaffold(
        appBar: AppBar(
          title: Text("Doctor Homepage"),
        ),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          Container(
            padding:
                EdgeInsets.only(top: 30.0, left: 5.0, right: 5.0, bottom: 25.0),
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
                          Icons.healing,
                          size: 50.0,
                        ),
                      ),
                      SizedBox(
                        width: 3.0,
                      ),
                      Container(
                        child: Text(
                          _doctor.name,
                          style: TextStyle(
                              fontSize: 30.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      Container(
                        child: Text(
                          _doctor.surname,
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
                  _buildAttributeRow("T.R. ID Number", _doctor.idNo),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, left: 13.0),
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.greenAccent,
                          width: 120.0,
                          height: 25.0,
                          child: Text(
                            "Hospital",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, left: 13.0),
                        child: Container(
                          child: Text(
                            hospitalName,
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  _buildAttributeRow("Department ", departmentName.toString()),
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
                SizedBox(
                  height: 5.0,
                ),
                _passwordUpdateButton(),
                SizedBox(
                  height: 7.0,
                ),
                _appointmentsViewButton(),
                SizedBox(
                  height: 7.0,
                ),
                _exitButton(),
              ],
            ),
          )
        ])));
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

  _passwordUpdateButton() {
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
          "Update Password",
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          basicNavigator(OnlyUpdatePassword(_doctor), "Operation Complete");
        },
      ),
    );
  }

  _appointmentsViewButton() {
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
          "View Appointments",
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      BuildAppointmentListForDoctor(_doctor)));
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
