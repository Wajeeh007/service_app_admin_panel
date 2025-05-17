import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BaseScreenViewModel extends GetxController {

  /// Controller(s)
  PageController pageController = PageController(initialPage: 0);

  /// Current page index
  RxInt selectedPageIndex = 0.obs;

}