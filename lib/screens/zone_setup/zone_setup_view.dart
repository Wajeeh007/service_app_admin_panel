import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_google_maps.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_text_form_field.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/sidepanel.dart';
import 'package:service_app_admin_panel/utils/images_paths.dart';
import 'package:service_app_admin_panel/utils/validators.dart';
import 'package:service_app_admin_panel/screens/zone_setup/zone_setup_viewmodel.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import '../../utils/custom_widgets/custom_appbar.dart';

class ZoneSetupView extends StatelessWidget {
  ZoneSetupView({super.key});

  final ZoneSetupViewModel _viewModel = Get.put(ZoneSetupViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Row(
        children: [
          SidePanel(selectedItem: lang_key.zoneSetup.tr),
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: SingleChildScrollView(
                padding: basePaddingForScreens,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 15,
                  children: [
                    Text(
                      lang_key.zoneSetup.tr,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w600
                      ),
                    ),
                    ZoneSetupSection()
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// Zone Setup container and instructions
class ZoneSetupSection extends StatelessWidget {
  ZoneSetupSection({super.key});

  final ZoneSetupViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: primaryWhite,
          borderRadius: kContainerBorderRadius,
          border: kContainerBorderSide
      ),
      padding: EdgeInsets.all(15),
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lang_key.instructions.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  lang_key.zoneSetupInstructions.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey
                  ),
                ),
                Image.asset(ImagesPaths.zoneSetupExample)
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text(
                  lang_key.zoneName.tr,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600
                  ),
                ),
                Form(
                  key: _viewModel.formKey,
                  child: CustomTextFormField(
                    controller: _viewModel.zoneNameController,
                    validator: (value) => Validators.validateEmptyField(value),
                    hint: 'Ex: Toronto',
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: Stack(
                      children: [
                        GoogleMapWidget()
                        // GoogleMap(
                        //     gestureRecognizers: {
                        //       Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                        //     },
                        //   style: """[
                        //     {
                        //       "featureType": "poi",
                        //       "stylers": [
                        //         {
                        //           "visibility": "off"
                        //         }
                        //       ]
                        //     },
                        //     {
                        //       "featureType": "poi.business",
                        //       "stylers": [
                        //         {
                        //           "visibility": "off"
                        //         }
                        //       ]
                        //     },
                        //      {
                        //       "featureType": "poi.attraction",
                        //       "stylers": [
                        //         {
                        //           "visibility": "off"
                        //         }
                        //       ]
                        //     },
                        //      {
                        //       "featureType": "poi.government",
                        //       "stylers": [
                        //         {
                        //           "visibility": "off"
                        //         }
                        //       ]
                        //     },
                        //      {
                        //       "featureType": "poi.medical",
                        //       "stylers": [
                        //         {
                        //           "visibility": "off"
                        //         }
                        //       ]
                        //     },
                        //      {
                        //       "featureType": "poi.park",
                        //       "stylers": [
                        //         {
                        //           "visibility": "off"
                        //         }
                        //       ]
                        //     },
                        //      {
                        //       "featureType": "poi.place_of_worship",
                        //       "stylers": [
                        //         {
                        //           "visibility": "off"
                        //         }
                        //       ]
                        //     },
                        //      {
                        //       "featureType": "poi.school",
                        //       "stylers": [
                        //         {
                        //           "visibility": "off"
                        //         }
                        //       ]
                        //     },
                        //     {
                        //       "featureType": "poi.sports_complex",
                        //       "stylers": [
                        //         {
                        //           "visibility": "off"
                        //         }
                        //       ]
                        //     }
                        //   ]""",
                        //   buildingsEnabled: false,
                        //   mapType: MapType.normal,
                        //   // gestureRecognizers: ,
                        //   scrollGesturesEnabled: !_viewModel.isDrawing.value,
                        //     initialCameraPosition: initialCameraPosition,
                        //   onMapCreated: (controller) {
                        //       _viewModel.googleMapController = controller;
                        //       // _viewModel.googleMapController.
                        //   },
                        //   //   markers: {
                        //   //   Marker(
                        //   //       markerId: const MarkerId('1'),
                        //   //       position: const LatLng(43.6532, -79.3832),
                        //   //       visible: false)
                        //   // },
                        //   onTap: (position) {
                        //       if(_viewModel.isDrawing.isTrue) print(position);
                        //   }),
                        // Positioned(
                        //   top: 5,
                        //   right: 5,
                        //   child: MaterialButton(
                        //     onPressed: () => _viewModel.toggleMapControls(true),
                        //     color: _viewModel.isDrawing.isTrue ? secondaryGrey : primaryWhite,
                        //     elevation: 5,
                        //     minWidth: 30,
                        //     child: Icon(
                        //       Icons.polyline_outlined,
                        //       color: Colors.grey,
                        //       size: 15,
                        //     ),
                        //   ),
                        // ),
                        // Positioned(
                        //   top: 5,
                        //   right: 40,
                        //   child: MaterialButton(
                        //     onPressed: () => _viewModel.toggleMapControls(false),
                        //     color: _viewModel.isDrawing.isFalse ? secondaryGrey : primaryWhite,
                        //     elevation: 5,
                        //     minWidth: 30,
                        //     child: Icon(
                        //       Icons.back_hand_outlined,
                        //       color: Colors.grey,
                        //       size: 15,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                ),
              ],
            ),
          )
        ]
      ),
    );
  }
}
