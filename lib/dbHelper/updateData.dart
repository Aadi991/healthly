import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/dbHelper/searchData.dart';
import 'package:healthly/models/departmentModel.dart';
import 'package:healthly/models/userModel.dart';
import 'package:healthly/models/doctorModel.dart';
import 'package:healthly/models/hospitalModel.dart';

class UpdateService {
  updateUser(User user) {
    FirebaseFirestore.instance
        .collection("tblUser")
        .doc(user.reference?.path)
        .update({
      'password': user.password.toString(),
      'name': user.name,
      'surname': user.surname
    });
  }

  // String updateUserFavList(String idNo, String doctorNameSurname) {
  // Usertemp;
  // SearchService().searchUserById(idNo).then((QuerySnapshot docs) {
  // temp = User.fromMap( docs.docs[0].data() as Map<String,dynamic>);
  // temp.reference = docs.docs[0].reference;
  // if (!temp.favoriteDoctors.contains(doctorNameSurname)) {
  // temp.favoriteDoctors.add(doctorNameSurname);

  // FirebaseFirestore.instance
  // .collection("tblUser")
  // .doc(temp.reference.path)
  // .update({'favoriteDoctors': temp.favoriteDoctors});
  // }
  // });

  // return "Update performed";
  // }

  String updateDoctor(Doctor doctor) {
    FirebaseFirestore.instance
        .doc(doctor.reference!.path)
        .update({
      'id': doctor.name,
      'password': doctor.password.toString(),
      'surname': doctor.surname
    });
    return "Update performed";
  }

  String updateDoctorFavCountPlus(String doctorNo) {
    Doctor doctor;
    SearchService().searchDoctorById(doctorNo).then((QuerySnapshot docs) {
      doctor = Doctor.fromMap( docs.docs[0].data() as Map<String,dynamic>);
      doctor.reference = docs.docs[0].reference;
      FirebaseFirestore.instance
          .collection("tblDoctor")
          .doc(doctor.reference?.path)
          .update({'favoriteCounter': doctor.favoriteCounter + 1});
    });

    return "Update performed";
  }

  String updateDoctorFavCountMinus(String doctorNo) {
    Doctor doctor;
    SearchService().searchDoctorById(doctorNo).then((QuerySnapshot docs) {
      doctor = Doctor.fromMap( docs.docs[0].data() as Map<String,dynamic>);
      doctor.reference = docs.docs[0].reference;
      FirebaseFirestore.instance
          .collection("tblDoctor")
          .doc(doctor.reference?.path)
          .update({'favoriteCounter': doctor.favoriteCounter - 1});
    });

    return "Update performed";
  }

  String updateDoctorAppointments(String idNo, String transactionDate) {
    Doctor temp;
    SearchService().searchDoctorById(idNo).then((QuerySnapshot docs) {
      temp = Doctor.fromMap( docs.docs[0].data() as Map<String,dynamic>);
      temp.reference = docs.docs[0].reference;
      if (temp.appointments.contains(transactionDate)) {
        temp.appointments.remove(transactionDate);

        FirebaseFirestore.instance
            .collection("tblDoctor")
            .doc(temp.reference?.path)
            .update({'appointments': temp.appointments});
      }
    });

    return "Update performed";
  }

  String updateHospital(Hospital hospital) {
    FirebaseFirestore.instance
        .doc(hospital.reference!.path)
        .update({'hospitalName': hospital.hospitalName.toString()});
    return "Update performed";
  }

  String updateDepartment(Department department) {
    FirebaseFirestore.instance
        .collection("tblDepartment")
        .doc(department.reference?.path)
        .update({'departmentName': department.departmentName.toString()});
    return "Update performed";
  }
}