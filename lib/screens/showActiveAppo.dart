import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/dbHelper/delData.dart';
import 'package:healthly/dbHelper/updateData.dart';
import 'package:healthly/models/activeAppointmentModel.dart';
import 'package:healthly/models/userModel.dart';
import 'package:flutter/material.dart';

class BuildAppointmentList extends StatefulWidget {
  final User user;
  BuildAppointmentList(this.user);
  @override
  _BuildAppointmentListState createState() => _BuildAppointmentListState(user);
}

class _BuildAppointmentListState extends State<BuildAppointmentList> {
  User user;
  _BuildAppointmentListState(this.user);

  String? send;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Active Appointments"),
      ),
      body: _buildStremBuilder(context),
    );
  }

  _buildStremBuilder(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("tblActiveAppointment")
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
    final appointment = ActiveAppointment.fromSnapshot(data);

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
          subtitle: Text(appointment.appointmentDate),
          trailing: Text("Cancel",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.redAccent),),
          onTap: () {
            alrtAppointmentCancelEt(context, appointment);
          },
        ),
      ),
    );
  }

  void alrtAppointmentCancelEt(BuildContext context, ActiveAppointment rand) {
    var alrtAppointment = AlertDialog(
      title: Text(
        "Are you sure you want to cancel the appointment?",
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
            UpdateService()
                .updateDoctorAppointments(rand.doctorId, rand.appointmentDate);
            DelService().deleteActiveAppointment(rand);
            Navigator.pop(context);
            Navigator.pop(context,true);
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