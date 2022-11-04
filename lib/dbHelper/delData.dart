import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthly/models/activeAppointmentModel.dart';
import 'package:healthly/models/doctorModel.dart';
import 'package:healthly/models/favListModel.dart';
import 'package:healthly/models/hospitalModel.dart';
import 'package:healthly/models/departmentModel.dart';

class DelService {
  ActiveAppointment activeAppointment = ActiveAppointment.empty();

  // This method delete a doctor also her / his active appoit
  deleteDoctorbyTCKN(Doctor doctor) {
    FirebaseFirestore.instance
        .doc(doctor.reference!.path)
        .delete();
    FirebaseFirestore.instance
        .collection("tblActiveAppointment")
        .where('doctorId', isEqualTo: doctor.idNo)
        .get()
        .then((QuerySnapshot docs) {
      if (docs.docs.isNotEmpty) {
        for (var i = 0; i < docs.docs.length; i++) {
          FirebaseFirestore.instance
              .collection("tblActiveAppointment")
              .doc(docs.docs[i].reference.path)
              .delete();
        }
      }
    });
  }

  deleteActiveAppointment(ActiveAppointment appointment) {
    FirebaseFirestore.instance
        .collection('tblActiveAppointment')
        .doc(appointment.reference?.path)
        .delete();
  }

  deleteDocFromUserFavList(FavoriteList fav) {
    FirebaseFirestore.instance
        .collection('tblFavorites')
        .doc(fav.reference?.path)
        .delete();
  }

  deleteDepartmentByDepartmentId(Department department, var reference) {
    FirebaseFirestore.instance
        .doc(reference.path)
        .delete();
    FirebaseFirestore.instance
        .collection("tblDoctor")
        .where('departmentId', isEqualTo: department.departmentId)
        .get()
        .then((QuerySnapshot docs) {
      if (docs.docs.isNotEmpty) {
        for (var i = 0; i < docs.docs.length; i++) {
          FirebaseFirestore.instance
              .collection("tblActiveAppointment")
              .where('doctorId', isEqualTo: docs.docs[i]['idNo'])
              .get()
              .then((QuerySnapshot docs) {
            if (docs.docs.isNotEmpty) {
              for (var i = 0; i < docs.docs.length; i++) {
                FirebaseFirestore.instance
                    .collection("tblActiveAppointment")
                    .doc(docs.docs[i].reference.path)
                    .delete();
              }
            }
          });

          FirebaseFirestore.instance
              .collection("tblDoctor")
              .doc(docs.docs[i].reference.path)
              .delete();
        }
      }
    });
  }

  deleteHospitalById(Hospital hospital) {
    Department department = Department.empty();
    FirebaseFirestore.instance
        .collection("tblDepartment")
        .where('hospitalId', isEqualTo: hospital.hospitalId)
        .get()
        .then((QuerySnapshot docs) {
      for (var i = 0; i < docs.docs.length; i++) {
        if (!docs.docs.isEmpty) {
          department =
              Department.fromMap(docs.docs[i].data() as Map<String, dynamic>);
          deleteDepartmentByDepartmentId(department, docs.docs[i].reference);
        }
      }
    });

    FirebaseFirestore.instance.doc(hospital.reference!.path).delete();
  }
}
