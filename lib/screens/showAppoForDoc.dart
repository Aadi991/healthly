import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/dbHelper/addData.dart';
import 'package:healthly/dbHelper/delData.dart';
import 'package:healthly/dbHelper/updateData.dart';
import 'package:healthly/models/activeAppointmentModel.dart';
import 'package:healthly/models/doctorModel.dart';
import 'package:flutter/material.dart';

class BuildAppointmentListForDoctor extends StatefulWidget {
  final doctor;
  BuildAppointmentListForDoctor(this.doctor);
  @override
  _BuildAppointmentListState createState() =>
      _BuildAppointmentListState(doctor);
}

class _BuildAppointmentListState extends State<BuildAppointmentListForDoctor> {
  Doctor doctor;
  _BuildAppointmentListState(this.doctor);

  late String gender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Appointments"),
      ),
      body: _buildStremBuilder(context),
    );
  }

  _buildStremBuilder(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("tblActiveAppointment")
          .where('doctorId', isEqualTo: doctor.idNo)
          .where('appointmentDate',
          isLessThanOrEqualTo: (DateTime.now()
              .add(Duration(days: 30))
              .toString()
              .substring(0, 10)))
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
            child: Icon(Icons.person),
          ),
          title: Row(
            children: <Widget>[
              Text(
                appointment.patientName.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              SizedBox(
                width: 3.0,
              ),
              Text(
                appointment.patientSurname.toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
            ],
          ),
          subtitle: Text(appointment.appointmentDate),
          trailing: Text(
            "Complete",
            style:
            TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
          ),
          onTap: () {
            alrtCompleteAppointment(context, appointment);
          },
        ),
      ),
    );
  }

  void alrtCompleteAppointment(BuildContext context, ActiveAppointment rand) {
    var alrtAppointment = AlertDialog(
      title: Text(
        "Finish the Appointment",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Yes",
            textAlign: TextAlign.center,
          ),
          onPressed: () {
            UpdateService()
                .updateDoctorAppointments(doctor.idNo, rand.appointmentDate);
            DelService().deleteActiveAppointment(rand);
            AddService().addPastAppointment(rand);
            Navigator.pop(context);
            Navigator.pop(context);
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