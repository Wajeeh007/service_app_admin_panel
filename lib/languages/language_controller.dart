import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../helpers/local_storage_functions.dart';
import '../utils/constants.dart';

class LanguageController extends GetxController {

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
    // 'ar_SA': {
    //   'languageCode': 'ar',
    //   'countryCode': 'SA',
    //   'description': 'العربية',
    //   'selected': false,
    //   'color': Colors.black,
    // },
  };

  @override
  void onInit() {
    super.onInit();
    getLanguageState();
  }

  Future getLanguageState() async {
    if(await LocalStorageFunctions.readFromStorage(key: languageCodeKey, container: languageContainerName) != null) {
      final langKey = await LocalStorageFunctions.readFromStorage(key: languageCodeKey, container: languageContainerName);
      languageKey.value = langKey;
      return setLanguage(key: langKey);
    }

    setLanguage(key: 'en_US');
  }

  Future<void> setLanguage({required String key}) async {

    final String languageCode = optionsLocales[key]['languageCode'];
    final String countryCode = optionsLocales[key]['countryCode'];

    Get.updateLocale(Locale(languageCode, countryCode));

    locale.value = Get.locale.toString();
    languageKey(key);
    await LocalStorageFunctions.writeToStorage(key: languageCodeKey, value: key, container: languageContainerName);
    language(optionsLocales[key]['description']);
    countryKey(optionsLocales[key]['countryCode']);

    update();
  }
}