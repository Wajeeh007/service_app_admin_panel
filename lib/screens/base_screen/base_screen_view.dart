// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:service_app_admin_panel/screens/customer_management/customer_list/customers_list_view.dart';
// import 'package:service_app_admin_panel/screens/dashboard/dashboard_view.dart';
// import 'package:service_app_admin_panel/screens/order_management/order_management_view.dart';
// import 'package:service_app_admin_panel/screens/service_management/items_list/items_list_view.dart';
// import 'package:service_app_admin_panel/screens/service_management/service_list/service_list_view.dart';
// import 'package:service_app_admin_panel/screens/service_management/sub_services_list/sub_services_list_view.dart';
// import 'package:service_app_admin_panel/screens/serviceman_management/active_serviceman_list/active_serviceman_list_view.dart';
// import 'package:service_app_admin_panel/screens/serviceman_management/new_requests/new_requests_view.dart';
// import 'package:service_app_admin_panel/screens/serviceman_management/suspended_servicemen_list/suspended_serviceman_list_view.dart';
// import 'package:service_app_admin_panel/screens/settings/business_setup/business_setup_view.dart';
// import 'package:service_app_admin_panel/screens/withdraw/withdraw_methods/withdraw_methods_view.dart';
// import 'package:service_app_admin_panel/screens/withdraw/withdraw_requests/withdraw_requests_view.dart';
// import 'package:service_app_admin_panel/screens/zone_setup/zone_list_and_addition_view.dart';
// import '../../utils/constants.dart';
// import '../../utils/custom_widgets/custom_appbar.dart';
// import '../../utils/custom_widgets/sidepanel.dart';
// import '../../utils/global_variables.dart';
// import 'base_screen_viewmodel.dart';
// import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
//
// class BaseScreenView extends StatelessWidget {
//   BaseScreenView({super.key,});
//
//   final BaseScreenViewModel _viewModel = Get.put(BaseScreenViewModel());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(),
//       body: GestureDetector(
//         behavior: HitTestBehavior.opaque,
//         onTap: () => GlobalVariables.openProfileDropdown.value = false,
//         child: Stack(
//           children: [
//
//             Row(
//               children: [
//                 SidePanel(selectedItemIndex: _viewModel.selectedPageIndex),
//                 Expanded(
//                     child: PageView(
//                       controller: _viewModel.pageController,
//                       children: [
//                         DashboardView(),
//                         ZoneSetupView(),
//                         OrderManagementView(),
//                         CustomersListView(),
//                         SuspendedServicemanListView(),
//                         NewRequestsView(),
//                         ActiveServiceManListView(),
//                         SuspendedServicemanListView(),
//                         ServiceListView(),
//                         SubServicesListView(),
//                         ItemsListView(),
//                         WithdrawMethodsView(),
//                         WithdrawRequestsView(),
//                         BusinessSetupView(),
//                       ],
//                     )
//                 ),
//               ],
//             ),
//             ProfileDropDown(),
//             ProfileDropDownContainer(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// Base widget for the profile dropdown
// class ProfileDropDown extends StatelessWidget {
//   const ProfileDropDown({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => GlobalVariables.openProfileDropdown.value ? Positioned(
//       right: 20,
//       top: 0,
//       child: CustomPaint(
//         painter: TrianglePainter(
//             strokeColor: primaryWhite,
//             strokeWidth: 10,
//             paintingStyle: PaintingStyle.fill
//         ),
//         child: const SizedBox(
//           height: 8,
//           width: 10,
//         ),
//       ),
//     ) : const SizedBox()
//     );
//   }
// }
//
// /// Container beneath the triangle for the profile dropdown
// class ProfileDropDownContainer extends StatelessWidget {
//   const ProfileDropDownContainer({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => GlobalVariables.openProfileDropdown.value ? Positioned(
//       right: 10,
//       top: 7,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(8),
//             color: primaryWhite
//         ),
//         child: SizedBox(
//           width: 180,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ListTile(
//                 minTileHeight: 20,
//                 contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 3),
//                 title: Text(
//                   lang_key.logout.tr,
//                   style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                       fontWeight: FontWeight.w600
//                   ),
//                 ),
//                 trailing: Icon(
//                   Icons.logout_rounded,
//                   size: 20,
//                   color: Colors.red,
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     ) : const SizedBox()
//     );
//   }
// }
//
// /// Custom painter class for creating a triangle
// class TrianglePainter extends CustomPainter {
//
//   final Color strokeColor;
//   final PaintingStyle paintingStyle;
//   final double strokeWidth;
//
//   TrianglePainter({
//     this.strokeColor = Colors.black,
//     this.strokeWidth = 3,
//     this.paintingStyle = PaintingStyle.stroke
//   });
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint()
//       ..color = strokeColor
//       ..strokeWidth = strokeWidth
//       ..style = paintingStyle;
//     canvas.drawPath(getTrianglePath(size.width, size.height), paint);
//   }
//
//   Path getTrianglePath(double x, double y) {
//     return Path()
//       ..moveTo(0, y)
//       ..lineTo(x / 2, 0)
//       ..lineTo(x, y)
//       ..lineTo(0, y);
//   }
//
//   @override
//   bool shouldRepaint(TrianglePainter oldDelegate) {
//     return oldDelegate.strokeColor != strokeColor ||
//         oldDelegate.paintingStyle != paintingStyle ||
//         oldDelegate.strokeWidth != strokeWidth;
//   }
// }