import 'package:fluttertoast/fluttertoast.dart';

class Validator {
  Validator._();
  static String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return ("Please Enter Your Email");
    }
    final RegExp emailRegExp = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");
    if (!emailRegExp.hasMatch(value)) {

      Fluttertoast.showToast(msg: "Please Enter a Valid Email.");
      return ("Please Enter a Valid Email.");
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? validatePasswordConfirmation(String? password, String? confirmPassword) {
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name is required';
    }

    final RegExp nameRegExp = RegExp(r"^[a-zA-Z ]+$");
    if (!nameRegExp.hasMatch(name)) {
      return 'Please enter a valid name';
    }

    return null;
  }

  static String? validateBangladeshiPhoneNumber(String? phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return 'Phone number is required';
    }

    final RegExp bdPhoneNumberRegExp = RegExp(r'^\+?880?1[3456789]\d{8}$');
    if (!bdPhoneNumberRegExp.hasMatch(phoneNumber)) {
      return 'Please enter a valid Bangladeshi phone number';
    }

    return null;
  }


}
