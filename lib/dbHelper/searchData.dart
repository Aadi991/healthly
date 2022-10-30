import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/models/doctorModel.dart';
import 'package:healthly/models/passiveAppoModel.dart';

class SearchService {
  searchById(String incomingId, String incomingPassword, int formKey) {
    if (formKey == 0) {
      return FirebaseFirestore.instance
          .collection('tblUser')
          .where('idNo', isEqualTo: incomingId)
          .where('password', isEqualTo: incomingPassword)
          .get();
    } else if (formKey == 1) {
      return FirebaseFirestore.instance
          .collection('tblDoctor')
          .where('idNo', isEqualTo: incomingId)
          .where('password', isEqualTo: incomingPassword)
          .get();
    } else if (formKey == 2) {
      return FirebaseFirestore.instance
          .collection('tblAdmin')
          .where('nickname', isEqualTo: incomingId)
          .where('password', isEqualTo: incomingPassword)
          .get();
    }
  }

  searchByPassword(String incomingPassword, int formKey) {
    if (formKey == 0) {
      return FirebaseFirestore.instance
          .collection('tblUser')
          .where('password', isEqualTo: incomingPassword)
          .get();
    } else if (formKey == 1) {
      return FirebaseFirestore.instance
          .collection('tblDoctor')
          .where('password', isEqualTo: incomingPassword)
          .get();
    } else if (formKey == 2) {
      return FirebaseFirestore.instance
          .collection('tblAdmin')
          .where('password', isEqualTo: incomingPassword)
          .get();
    }
  }

  searchHospitalByName(String value) {
    return FirebaseFirestore.instance
        .collection("tblHospital")
        .where('hospitalName', isEqualTo: value)
        .get();
  }

  searchHospitalById(int value) {
    return FirebaseFirestore.instance
        .collection("tblHospital")
        .where('hospitalId', isEqualTo: value)
        .get();
  }

  searchDepartmentById(int value) {
    return FirebaseFirestore.instance
        .collection("tblDepartment")
        .where('departmentId', isEqualTo: value)
        .get();
  }

  searchDepartmentsByHospitalId(int hospitalId) {
    return FirebaseFirestore.instance
        .collection("tblDepartment")
        .where('hospitalId', isEqualTo: hospitalId)
        .get();
  }

  searchDepartmentByHospitalIdAndDepartmentName(int hospitalId, String departmentName) {
    return FirebaseFirestore.instance
        .collection("tblDepartment")
        .where('hospitalId', isEqualTo: hospitalId)
        .where('departmentName', isEqualTo: departmentName)
        .get();
  }

  searchDoctorAppointment(Doctor doctor, String date) {
    return FirebaseFirestore.instance
        .collection("tblActiveAppointment")
        .where('doctorId', isEqualTo: doctor.idNo)
        .where('appointmentDate', isEqualTo: date)
        .get();
  }

  searchDoctorById(String idNo) {
    return FirebaseFirestore.instance
        .collection("tblDoctor")
        .where('idNo', isEqualTo: idNo)
        .get();
  }

  searchUserById(String idNo) {
    return FirebaseFirestore.instance
        .collection("tblUser")
        .where('idNo', isEqualTo: idNo)
        .get();
  }

  getHospitals() {
    return FirebaseFirestore.instance.collection("tblHospital").get();
  }

  getDepartments() {
    return FirebaseFirestore.instance.collection("tblDepartment").get();
  }

  getLastDepartmentId() {
    return FirebaseFirestore.instance
        .collection("tblDepartment")
        .orderBy("departmentId", descending: true)
        .get();
  }

  getLastHospitalId() {
    return FirebaseFirestore.instance
        .collection("tblHospital")
        .orderBy("hospitalId", descending: true)
        .get();
  }

  getDoctors() {
    return FirebaseFirestore.instance.collection("tblDoctor").get();
  }

  getPastAppointments() {
    return FirebaseFirestore.instance.collection("tblAppointmentTime").get();
  }

  searchPastAppointmentsByPatientTCKN(String tckn) {
    return FirebaseFirestore.instance
        .collection("tblAppointmentTime")
        .where('patientId', isEqualTo: tckn)
        .get();
  }

  searchActiveAppointmentsByPatientTCKN(String tckn) {
    return FirebaseFirestore.instance
        .collection("tblActiveAppointment")
        .where('patientId', isEqualTo: tckn)
        .get();
  }

  searchActiveAppointmentsWithPatientTCKNAndDoctorTCKN(
      String patientId, String doctorId) {
    return FirebaseFirestore.instance
        .collection("tblActiveAppointment")
        .where('patientId', isEqualTo: patientId)
        .where('doctorId', isEqualTo: doctorId)
        .get();
  }

  searchDocOnUserFavList(PassAppointment rand) {
    return FirebaseFirestore.instance
        .collection("tblFavorites")
        .where('patientId', isEqualTo: rand.patientId)
        .where('doctorId', isEqualTo: rand.doctorId)
        .get();
  }
}