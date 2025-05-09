import 'package:get/get.dart';
import 'package:service_app_admin_panel/models/customer.dart';

class SuspendedCustomersListViewModel extends GetxController {

  RxList<Customer> suspendedCustomersList = <Customer>[].obs;

}