import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/dbHelper/addData.dart';
import 'package:healthly/dbHelper/searchData.dart';
import 'package:healthly/dbHelper/updateData.dart';
import 'package:healthly/models/passiveAppoModel.dart';
import 'package:healthly/models/userModel.dart';
import 'package:flutter/material.dart';

class AppointmentHistory extends StatefulWidget {
  final User user;
  AppointmentHistory(this.user);
  @override
  _AppointmentHistoryState createState() => _AppointmentHistoryState(user);
}

class _AppointmentHistoryState extends State<AppointmentHistory> {
  _AppointmentHistoryState(this.user);
  User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Past Appointments"),
      ),
      body: _buildStremBuilder(context),
    );
  }

  _buildStremBuilder(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("tblAppointmentTime")
          .where('patientId', isEqualTo: user.idNo)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          return _buildBody(context, snapshot.data!.docs);
        }
      },
    );
  }

  Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: EdgeInsets.only(top: 15.0),
      children: snapshot
          .map<Widget>((data) => _buildListItem(context, data))
          .toList(),
    );
  }

  _buildListItem(BuildContext context, DocumentSnapshot data) {
    final appointment = PassAppointment.fromSnapshot(data);
    return Padding(
      key: ValueKey(appointment.reference),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.greenAccent,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.healing),
          ),
          title: Row(
            children: <Widget>[
              Text(
                appointment.doctorName.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              SizedBox(
                width: 3.0,
              ),
              Text(
                appointment.doctorSurname.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ],
          ),
          subtitle: Text(appointment.transactionDate),
          trailing: Text(
            "Add to Favorites",
            style:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
          onTap: () {
            alrtFavAdd(context, appointment);
          },
        ),
      ),
    );
  }

  void alrtFavAdd(BuildContext context, PassAppointment rand) {
    var alrtAppointment = AlertDialog(
      title: Text(
        "Are you sure you want to add to favourites?",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("No"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        SizedBox(
          width: 5.0,
        ),
        FlatButton(
          child: Text(
            "Yes",
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            SearchService()
                .searchDocOnUserFavList(rand)
                .then((QuerySnapshot docs) {
              if (docs.docs.isEmpty) {
                AddService().addDoctorToUserFavList(rand);
                UpdateService().updateDoctorFavCountPlus(rand.doctorId);
                Navigator.pop(context);
                Navigator.pop(context, true);
              } else {
                Navigator.pop(context);
                alrtHospital(context, "You cannot add a doctor in your favorite list again.");
              }
            });
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