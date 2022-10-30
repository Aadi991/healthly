class ValidationMixin {
  String? validateTCNo(String? value) {
    if (value!.length != 11) {
      return "T.R. Identity Number must be 11 digits";
    }

    return null;
  }

  String? validateFirstName(String? value) {
    if (value!.length < 2) {
      return "Name must be at least two characters";
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value!.length < 2) {
      return "Last name must be at least two characters";
    }
    return null;
  }

  String? validateAdmin(String? value) {
    if (value != "admin") {
      return "You have entered incorrect or missing information";
    }
    return null;
  }
  String? validatePassword(String? value){
    if(value!.length <4){
      return "Must be at least 4 digits";
    }
    return null;
  }
}