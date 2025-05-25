import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_appbar.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/loader_view.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/sidepanel.dart';

import '../../helpers/hide_overlays.dart';
import '../constants.dart';
import '../global_variables.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

class ScreensBaseWidget extends StatelessWidget {
  const ScreensBaseWidget({
    super.key,
    required this.selectedSidePanelItem,
    required this.children,
    required this.scrollController,
    this.overlayPortalControllersAndShowDropDown,
    this.args
  });

  final String selectedSidePanelItem;
  final List<Widget> children;
  final ScrollController scrollController;
  final List<Map<OverlayPortalController, RxBool>>? overlayPortalControllersAndShowDropDown;
  final Map<String, dynamic>? args;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => hideAllOverlayPortalControllers(overlayPortalControllersAndIcons: overlayPortalControllersAndShowDropDown),
        child: Stack(
          children: [

            Row(
              children: [
                SidePanel(
                  scrollController: scrollController,
                  selectedItemIndex: selectedSidePanelItem,
                  args: args,
                ),
                Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          spacing: 15,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: children,
                        ),
                      ),
                    )
                ),
              ],
            ),
            ProfileDropDown(),
            ProfileDropDownContainer(),
            LoaderView(),
          ],
        ),
      ),
    );
  }
}

/// Base widget for the profile dropdown
class ProfileDropDown extends StatelessWidget {
  const ProfileDropDown({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GlobalVariables.openProfileDropdown.value ? Positioned(
      right: 20,
      top: 0,
      child: CustomPaint(
        painter: TrianglePainter(
            strokeColor: primaryWhite,
            strokeWidth: 10,
            paintingStyle: PaintingStyle.fill
        ),
        child: const SizedBox(
          height: 8,
          width: 10,
        ),
      ),
    ) : const SizedBox()
    );
  }
}

/// Container beneath the triangle for the profile dropdown
class ProfileDropDownContainer extends StatelessWidget {
  const ProfileDropDownContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GlobalVariables.openProfileDropdown.value ? Positioned(
      right: 10,
      top: 7,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: primaryWhite
        ),
        child: SizedBox(
          width: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                minTileHeight: 20,
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 3),
                title: Text(
                  lang_key.logout.tr,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600
                  ),
                ),
                trailing: Icon(
                  Icons.logout_rounded,
                  size: 20,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    ) : const SizedBox()
    );
  }
}

/// Custom painter class for creating a triangle
class TrianglePainter extends CustomPainter {

  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter({
    this.strokeColor = Colors.black,
    this.strokeWidth = 3,
    this.paintingStyle = PaintingStyle.stroke
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;
    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}