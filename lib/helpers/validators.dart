import 'package:get/get.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

class Validators {

  static String? validateEmptyField(String? value) {
    if(value == null || value == '' || value.isEmpty) {
      return lang_key.fieldIsRequired.tr;
    } else {
      return null;
    }
  }

  // static String? validateModelYear(String? value) {
  //   if(value == null || value == '' || value.isEmpty) {
  //     return lang_key.fieldIsRequired.tr;
  //   } else if(value.length < 4){
  //     return lang_key.invalidModelYear.tr;
  //   } else {
  //     return null;
  //   }
  // }

  static String? validateEmail(String? value) {
    if(value == null || value == '' || value.isEmpty) {
      return lang_key.fieldIsRequired.tr;
    } else if(GetUtils.isEmail(value)) {
      return lang_key.invalidEmail.tr;
    } else {
      return null;
    }
  }

  // static String? validateOTP(String? value) {
  //   if(value == null || value == '' || value.isEmpty) {
  //     return lang_key.fieldIsRequired.tr;
  //   } else if(value.length < 4) {
  //     return lang_key.otpMustBe4Digits.tr;
  //   } else {
  //     return null;
  //   }
  // }
  //
  // static String? validateConfirmPassword(String? value, String? password) {
  //   if(value == null || value == '' || value.isEmpty) {
  //     return lang_key.fieldIsRequired.tr;
  //   } else if(value != password) {
  //     return lang_key.passwordsDontMatch.tr;
  //   } else {
  //     return null;
  //   }
  // }
  //
  // static String? validateBankCardNo(String? value) {
  //   if(value == null || value == '' || value.isEmpty) {
  //     return lang_key.fieldIsRequired.tr;
  //   } else if(value.length < 16) {
  //     return lang_key.invalidCardNumber.tr;
  //   } else {
  //     return null;
  //   }
  // }
  //
  // static String? validateBankCardCvc(String? value) {
  //   if(value == null || value == '' || value.isEmpty) {
  //     return lang_key.fieldIsRequired.tr;
  //   } else if(value.length < 3) {
  //     return lang_key.invalidCvc.tr;
  //   } else {
  //     return null;
  //   }
  // }
}