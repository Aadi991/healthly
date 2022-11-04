import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/dbHelper/addData.dart';
import 'package:healthly/dbHelper/searchData.dart';
import 'package:healthly/models/adminModel.dart';
import 'package:healthly/models/doctorModel.dart';
import 'package:healthly/models/userModel.dart';
import 'package:healthly/screens/addAdminPage.dart';
import 'package:healthly/screens/adminHomePage.dart';
import 'package:healthly/screens/doctorHomePage.dart';
import 'package:healthly/screens/registerPage.dart';
import 'package:healthly/screens/userHomePage.dart';
import 'package:flutter/material.dart';
import 'package:healthly/mixins/validation_mixin.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomePageState();
  }
}

class WelcomePageState extends State
    with SingleTickerProviderStateMixin, ValidationMixin {
  late TabController _tabController;
  final userFormKey = GlobalKey<FormState>();
  final doctorFormKey = GlobalKey<FormState>();
  final adminFormKey = GlobalKey<FormState>();
  User user = User.empty();
  Doctor doctor = Doctor.empty();
  Admin admin = Admin(07007, "admin", "mieowCat", []);
  late Future<QuerySnapshot> incomingData;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    //AddService().saveAdmin(admin);
    this.incomingData = FirebaseFirestore.instance.collection('tblUser').get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fast Anadolu Appointment System",
          textDirection: TextDirection.ltr,
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white70,
          tabs: <Widget>[
            Text(
              "User",
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            Text(
              "Doctor",
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            Text(
              "Admin",
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                pagePlanWithForm(idNoField(0, context), passwordField(0),
                    "Welcome", userFormKey),
                registerButton()
              ])),
          pagePlanWithForm(idNoField(1, context), passwordField(1),
              "Doctor Login", doctorFormKey),
          pagePlanWithForm(adminNicknameField(), passwordField(2),
              "Admin Login", adminFormKey)
        ],
      ),
    );
  }

  void basicNavigator(dynamic page) async {
    bool result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));

    if (result != null && result == true) {
      RegisterPageState.alrtDone(context);
    }
  }

  Container registerButton() {
    return Container(
      child: FlatButton(
        child: Text(
          "Register",
          style: TextStyle(fontSize: 15.0),
        ),
        textColor: Colors.black,
        splashColor: Colors.cyanAccent,
        onPressed: () {
          basicNavigator(RegisterPage());
        },
      ),
    );
  }

  /*Container pagePlan(String pageHeader, String labelText) {
    return Container(
        padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
        // If there is no singlechildscrollview, when trying to enter data to the textfield, the keyboard is placed on the screen and the image is distorted, ...
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 13.0, bottom: 10.0),
                  child: pageHeaderPlan(pageHeader)),
              TextField(
                  controller: txtTCNO,
                  maxLength: 11,
                  decoration: labelTextPlan(labelText)),
              TextField(
                controller: txtPassword,
                decoration: InputDecoration(labelText: "Password"),
              ),
              Container(
                padding: EdgeInsets.only(top:30.0),
                child: FlatButton(
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 22.0),
                  ),
                  textColor: Colors.blueAccent,
                  splashColor: Colors.cyanAccent,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ));
  } */

  InputDecoration labelTextPlan(String value) {
    return InputDecoration(labelText: value);
  }

  Text pageHeaderPlan(String value) {
    return Text(
      value,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
    );
  }

  Container pagePlanWithForm(Widget firstTextField, Widget secondTextField,
      String pageHeader, GlobalKey<FormState> formKey) {
    return Container(
        margin: EdgeInsets.only(top: 25.0, right: 25.0, left: 25.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(top: 13.0, bottom: 10.0),
                  child: pageHeaderPlan(pageHeader),
                ),
                firstTextField,
                secondTextField,
                loginButton(formKey)
              ],
            ),
          ),
        ));
  }

  Widget idNoField(int tabIndex, BuildContext context) {
    var initialValue = "01470201232";
    (tabIndex == 1) ? initialValue = "61329712321" : {};
    return TextFormField(
      initialValue: initialValue,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "T.R. Identity Number:",
        labelStyle: TextStyle(
            fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
      onSaved: (String? value) {
        if (tabIndex == 0) {
          user.idNo = value!;
        } else {
          doctor.idNo = value!;
        }
      },
    );
  }

  Widget passwordField(int tabIndex) {
    return TextFormField(
      initialValue: "mieowCat",
      decoration: InputDecoration(
        labelText: "Password:",
        labelStyle: TextStyle(
            fontSize: 17.0, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
      validator: validatePassword,
      obscureText: true,
      onSaved: (String? value) {
        if (tabIndex == 0) {
          user.password = value!;
        } else if (tabIndex == 1) {
          doctor.password = value!;
        } else {
          admin.password = value!;
        }
      },
    );
  }

  Widget adminNicknameField() {
    return TextFormField(
      initialValue: admin.nickname,
      decoration: InputDecoration(labelText: "Username:"),
      validator: validateAdmin,
      onSaved: (String? value) {
        admin.nickname = value!;
      },
    );
  }

  bool idNoVerify = false;
  bool passwordVerify = false;
  var tempSearchStore = [];

  //method to find if there is a registered user with the entered ID number...
  initiateSearch(enteredId, incomingPassword, int tabIndex, String searchWhere,
      String searchPass) {
    SearchService()
        .searchById(enteredId, incomingPassword, tabIndex)
        .then((QuerySnapshot docs) {
      for (int i = 0; i < docs.docs.length; i++) {
        tempSearchStore.add(docs.docs[i].data());

        if (tabIndex == 0) {
          print(docs.docs[i].reference);
          user = User.fromMap(docs.docs[i].data() as Map<String, dynamic>);
        } else if (tabIndex == 1) {
          doctor = Doctor.fromMap(docs.docs[i].data() as Map<String, dynamic>);
        } else if (tabIndex == 2) {
          admin = Admin.fromMap(docs.docs[i].data() as Map<String, dynamic>);
        }
      }
    });
    for (var item in tempSearchStore) {
      if (item[searchWhere] == enteredId &&
          item[searchPass] == incomingPassword) {
        idNoVerify = true;
        passwordVerify = true;
      }
    }
  }

  Widget loginButton(GlobalKey<FormState> formKey) {
    return Container(
      padding: EdgeInsets.only(top: 30.0),
      child: FlatButton(
        child: Text(
          "Login",
          style: TextStyle(fontSize: 22.0),
        ),
        textColor: Colors.blueAccent,
        splashColor: Colors.cyanAccent,
        onPressed: () {
          idNoVerify = false;
          passwordVerify = false;
          formKey.currentState?.validate();
          formKey.currentState?.save();
          if (formKey == userFormKey) {
            initiateSearch(user.idNo, user.password, 0, 'idNo', 'password');

            if (idNoVerify && passwordVerify) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => UserHomePage(user)));
            }
          } else if (formKey == doctorFormKey) {
            initiateSearch(doctor.idNo, doctor.password, 1, 'idNo', 'password');

            if (idNoVerify && passwordVerify) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DoctorHomePage(doctor)));
            }
          } else if (formKey == adminFormKey) {
            initiateSearch(
                admin.nickname, admin.password, 2, 'nickname', 'password');

            if (idNoVerify && passwordVerify) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminHomePage(admin)));
            }
          }
        },
      ),
    );
  }
}
