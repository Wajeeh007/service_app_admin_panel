
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:service_app_admin_panel/utils/routes.dart';
import 'package:service_app_admin_panel/utils/theme_helpers.dart';
import 'package:service_app_admin_panel/languages/app_languages.dart';
import 'bindings/init.dart';
import 'bindings/language.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      theme: ThemeHelpers.themeData,
      debugShowCheckedModeBanner: false,
      title: 'Admin Panel',
      getPages: Routes.pages,
      initialRoute: Routes.customerDetails,
      translations: AppLanguages(),
      fallbackLocale: const Locale('en', 'US'),
      initialBinding: InitBinding(),
      locale: getLocale(initLanguageController.languageKey.value),
    );
  }

  Locale getLocale(String languageKey) {
    return Locale(
        initLanguageController.optionsLocales[languageKey]['languageCode'],
        initLanguageController.optionsLocales[languageKey]['countryCode']
    );
  }
}