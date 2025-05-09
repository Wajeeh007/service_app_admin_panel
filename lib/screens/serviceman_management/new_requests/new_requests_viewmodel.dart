import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/serviceman.dart';

class NewRequestsViewModel extends GetxController {

  /// New Servicemen requests received to admin
  RxList<ServiceMan> serviceManNewRequests = <ServiceMan>[].obs;

}