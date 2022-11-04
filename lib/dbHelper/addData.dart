import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/dbHelper/searchData.dart';
import 'package:healthly/models/activeAppointmentModel.dart';
import 'package:healthly/models/passiveAppoModel.dart';
import 'package:healthly/models/departmentModel.dart';
import 'package:healthly/models/userModel.dart';
import 'package:healthly/models/doctorModel.dart';
import 'package:healthly/models/adminModel.dart';
import 'package:healthly/models/hospitalModel.dart';

class AddService {
  String saveUser(User user) {
    FirebaseFirestore.instance.collection('tblUser').doc().set({
      'name': user.name,
      'surname': user.surname,
      'idNo': user.idNo,
      'gender': user.gender,
      'dateOfBirth': user.dateOfBirth,
      'placeOfBirth': user.placeOfBirth,
      'password': user.password
    });
    return 'user addition completed';
  }

  void saveDoctor(Doctor dr, Department department, Hospital hospital) {
    var appointments = [];
    FirebaseFirestore.instance.collection('tblDoctor').doc().set({
      'idNo': dr.idNo,
      'name': dr.name,
      'surname': dr.surname,
      'password': dr.password,
      'departmentId': department.departmentId,
      'hospitalId': hospital.hospitalId,
      'gender': dr.gender,
      'dateOfBirth': dr.dateOfBirth,
      'placeOfBirth': dr.placeOfBirth,
      'favoriteCounter': 0,
      'appointments': appointments
    });
  }

  void addActiveAppointment(Doctor dr, User user, String date) {
    FirebaseFirestore.instance.collection('tblActiveAppointments').doc().set({
      'doctorId': dr.idNo,
      'patientId': user.idNo,
      'appointmentDate': date,
      'doctorName': dr.name,
      'doctorSurname': dr.surname,
      'patientName': user.name,
      'patientSurname': user.surname
    });
  }

  void addDoctorToUserFavList(PassAppointment rand) {
    FirebaseFirestore.instance.collection('tblFavorites').doc().set({
      'doctorId': rand.doctorId,
      'patientId': rand.patientId,
      'doctorName': rand.doctorName,
      'doctorSurname': rand.doctorSurname,
      'patientName': rand.patientName,
      'patientSurname': rand.patientSurname
    });
  }

  void addPastAppointment(ActiveAppointment appointment) {
    FirebaseFirestore.instance.collection('tblAppointmentHistory').doc().set({
      'doctorId': appointment.doctorId,
      'patientId': appointment.patientId,
      'transactionDate': appointment.appointmentDate,
      'doctorName': appointment.doctorName,
      'doctorSurname': appointment.doctorSurname,
      'patientName': appointment.patientName,
      'patientSurname': appointment.patientSurname
    });
  }

  addDoctorAppointment(Doctor doctor) {
    FirebaseFirestore.instance
        .collection("tblDoctor")
        .doc(doctor.reference?.path)
        .set({'appointments': doctor.appointments}, SetOptions(merge: true));
  }

  closeDoctorAppointment(Admin admin) {
    FirebaseFirestore.instance
        .collection("tblAdmin")
        .doc(admin.reference?.path)
        .set({'closedHours': admin.closedHours}, SetOptions(merge: true));
  }

  String saveAdmin(Admin admin) {
    FirebaseFirestore.instance.collection("tblAdmin").doc().set({
      'id': admin.id,
      'nickname': admin.nickname,
      'password': admin.password
    });
    return 'Add admin completed';
  }

  String saveHospital(Hospital hospital) {
    SearchService().getLastHospitalId().then((QuerySnapshot docs) {
      var id = 0;
      if (!docs.docs.isEmpty) {
        id = docs.docs[0]['hospitalId'] + 1;
      }
      FirebaseFirestore.instance.collection("tblHospital").doc().set({
      'hospitalName': hospital.hospitalName,
      'hospitalId': id,
      });
    });

    return 'Hospital registration complete';
  }

  String saveDepartment(Department department, Hospital hospital) {
    SearchService().getLastDepartmentId().then((QuerySnapshot docs) {
      var id = 0;
      if (!docs.docs.isEmpty) {
        id = docs.docs[0]['departmentId'] + 1;
      }
      FirebaseFirestore.instance.collection("tblDepartment").doc().set({
        "departmentName": department.departmentName,
        "departmentId": id,
        "hospitalId": hospital.hospitalId
      });
    });
    return "Department addition complete";
  }
}