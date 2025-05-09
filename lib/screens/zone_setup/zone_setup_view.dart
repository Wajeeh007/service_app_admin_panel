import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_google_maps.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_material_button.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_text_form_field.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_base_container.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';
import 'package:service_app_admin_panel/utils/images_paths.dart';
import 'package:service_app_admin_panel/utils/validators.dart';
import 'package:service_app_admin_panel/screens/zone_setup/zone_setup_viewmodel.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

class ZoneSetupView extends StatelessWidget {
  ZoneSetupView({super.key});

  final ZoneSetupViewModel _viewModel = Get.put(ZoneSetupViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        selectedSidePanelItem: lang_key.zoneSetup.tr,
        children: [
          SectionHeadingText(headingText: lang_key.zoneSetup.tr),
          _ZoneSetupSection(),
          SectionHeadingText(headingText: lang_key.zoneList.tr),
          ListBaseContainer(
            hintText: lang_key.searchZone.tr,
            formKey: _viewModel.zoneSearchFormKey,
            controller: _viewModel.zoneNameController,
            listData: _viewModel.zoneList,
            columnsNames: [
              'SL',
              lang_key.zoneName.tr,
              lang_key.orderVolume.tr,
              lang_key.status.tr,
              lang_key.actions.tr
            ],
          )
        ],
    );
  }
}

/// Zone Setup container and instructions
class _ZoneSetupSection extends StatelessWidget {
  _ZoneSetupSection();

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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        spacing: 10,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.grey,
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
                      key: _viewModel.zoneNameFormKey,
                      child: CustomTextFormField(
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        controller: _viewModel.zoneNameController,
                        validator: (value) => Validators.validateEmptyField(value),
                        hint: 'Ex: Toronto',
                      ),
                    ),
                    GoogleMapWidget(),

                  ],
                ),
              ),
            ]
          ),
          CustomMaterialButton(
            width: 100,
            onPressed: () {
              if(_viewModel.zoneNameFormKey.currentState!.validate()) {

              }
            },
            text: lang_key.save.tr,
          )
        ],
      ),
    );
  }
}
