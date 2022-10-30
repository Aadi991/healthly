import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/dbHelper/delData.dart';
import 'package:healthly/dbHelper/updateData.dart';
import 'package:healthly/models/favListModel.dart';
import 'package:healthly/models/userModel.dart';
import 'package:flutter/material.dart';

class BuildUserFavList extends StatefulWidget {
  final User user;
  BuildUserFavList(this.user);
  @override
  _BuildUserFavListState createState() => _BuildUserFavListState(user);
}

class _BuildUserFavListState extends State<BuildUserFavList> {
  User _user;
  _BuildUserFavListState(this._user);

  var favoriteDoctorList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Doctors"),
      ),
      body: _buildStremBuilder(context),
    );
  }

  _buildStremBuilder(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("tblFavorites")
          .where("patientId", isEqualTo: _user.idNo)
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
    final favDoc = FavoriteList.fromSnapshot(data);
    favDoc.reference = FavoriteList.fromSnapshot(data).reference;
    return Padding(
      key: ValueKey(favDoc.patientId),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0)),
        child: ListTile(
          title: Row(
            children: <Widget>[
              Text(
                favDoc.doctorName,
                style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                favDoc.doctorSurname,
                style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              )
            ],
          ),
          trailing: Text(
            "Remove from Favorites",
            style:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
          ),
          onTap: () {
            alrtDeleteADoc(context, favDoc);
          },
        ),
      ),
    );
  }

  void alrtDeleteADoc(BuildContext context, FavoriteList fav) {
    var alrtDelete = AlertDialog(
      title: Text(
        "Are you sure you want to remove it from your favourites?",
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
            UpdateService().updateDoctorFavCountMinus(fav.doctorId);
            DelService().deleteDocFromUserFavList(fav);
            Navigator.pop(context);
            Navigator.pop(context, true);
          },
        )
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alrtDelete;
        });
  }
}