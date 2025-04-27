import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {

  final storage = GetStorage();

  var languageKey = ''.obs;
  var countryKey = ''.obs;
  var language = ''.obs;

  var locale = Get.locale.toString().obs;

  final Map<String, dynamic> optionsLocales = {
    'en_US': {
      'languageCode': 'en',
      'countryCode': 'US',
      'description': 'English',
      'selected': false,
      'color': Colors.blue[600],
    },
    'ar_SA': {
      'languageCode': 'ar',
      'countryCode': 'SA',
      'description': 'العربية',
      'selected': false,
      'color': Colors.black,
    },
  };

  @override
  void onInit() {
    super.onInit();
    getLanguageState();
  }

  getLanguageState() async {
    if(storage.read('language_key') != null) {
      languageKey.value = storage.read('language_key');
      return setLanguage(key: storage.read('language_key'));
    }

    setLanguage(key: 'en_US');
  }

  setLanguage({required String key}) async {

    final String languageCode = optionsLocales[key]['languageCode'];
    final String countryCode = optionsLocales[key]['countryCode'];

    Get.updateLocale(Locale(languageCode, countryCode));

    locale.value = Get.locale.toString();
    languageKey(key);
    storage.write('language_key', key);
    language(optionsLocales[key]['description']);
    countryKey(optionsLocales[key]['countryCode']);

    update();
  }
}