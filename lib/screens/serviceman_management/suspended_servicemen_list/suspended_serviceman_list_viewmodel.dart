import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/serviceman.dart';

class SuspendedServicemanListViewModel extends GetxController {

  /// Controller(s) & Form keys
  TextEditingController searchController = TextEditingController();
  GlobalKey<FormState> searchFormKey = GlobalKey<FormState>();

  /// List for servicemen suspended by the admin
  RxList<ServiceMan> suspendedServicemen = <ServiceMan>[].obs;

}