// matching various patterns for kinds of data
import 'package:get/get.dart';

class Validator {
  Validator();

  String? email(String? value) {
    String pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern);
    if (value!.isEmpty) {
      return ("Email can't be empty.");
    } else if (!regex.hasMatch(value)) {
      return 'Invalid Email Address, Enter a valid email address.';
    } else {
      return null;
    }
  }

  String? password(String? value) {
    String pattern = r'^.{6,}$';
    RegExp regex = RegExp(pattern);
    if (value!.isEmpty) {
      return ("Password can't be empty.");
    }
    if (!regex.hasMatch(value)) {
      return 'Please, Enter a Valid Password(Min. 6 Characters.)';
    } else {
      return null;
    }
  }

  String? name(String? value) {
    String pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
    RegExp regex = RegExp(pattern);
    if (value!.isEmpty) {
      return ("Name can't be Empty");
    }
    if (!regex.hasMatch(value)) {
      return ("Enter Valid name(Min. 4 Character).");
    } else {
      return null;
    }
  }

  String? number(String? value) {
    String pattern = r'^\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'validator.number'.tr;
    } else {
      return null;
    }
  }

  String? amount(String? value) {
    String pattern = r'^\d+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'validator.amount'.tr;
    } else {
      return null;
    }
  }

  String? notEmpty(String? value) {
    String pattern = r'^\S+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return "The Field can't be empty";
    } else {
      return null;
    }
  }
}
