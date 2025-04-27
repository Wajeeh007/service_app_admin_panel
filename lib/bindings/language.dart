import '../languages/language_controller.dart';
import 'package:get/get.dart';

/// Language controller for accessing language keys
LanguageController get initLanguageController {

  try {
    return Get.find();
  } catch (e) {
    Get.put(LanguageController(), permanent: true);
    return Get.find();
  }

}