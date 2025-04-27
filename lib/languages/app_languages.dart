import 'package:get/get.dart';
import 'package:service_app_admin_panel/languages/english.dart';

class AppLanguages extends Translations {

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': English().translations
  };

}