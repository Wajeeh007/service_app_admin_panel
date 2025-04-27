import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/dashboard/dashboard_view.dart';

class Routes {

  static const dashboard = '/dashboard';

  static final pages = [

    GetPage(name: dashboard, page: () => DashboardView())

  ];
}