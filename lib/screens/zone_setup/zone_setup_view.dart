import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_google_maps.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_material_button.dart';
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
                    _ZoneSetupSection(),
                    Text(
                      lang_key.zoneList.tr,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w600
                      ),

                    ),
                    _ZoneListContainer()
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

/// Zones List container
class _ZoneListContainer extends StatelessWidget {
  _ZoneListContainer();

  final ZoneSetupViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: primaryWhite,
          borderRadius: kContainerBorderRadius,
          border: kContainerBorderSide
      ),
      padding: EdgeInsets.all(20),
      child: Column(
        spacing: 15,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SearchFieldAndButton(),
              _NextPageLogAndRefreshButton(),
            ],
          ),
          _ListColumNames(),
          Obx(() => Column(
            children: _viewModel.zoneList.isEmpty ? [
              Image.asset(ImagesPaths.noData, height: 60,),
              Text(
                lang_key.noDataAvailable.tr,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: primaryGrey
                ),
              )
            ] : [],
          )
          )
        ],
      ),
    );
  }
}

/// Zone List search field and button
class _SearchFieldAndButton extends StatelessWidget {
  _SearchFieldAndButton();

  final ZoneSetupViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: 10,
      children: [
        SizedBox(
          width: 200,
          child: Form(
              key: _viewModel.zoneSearchFormKey,
              child: CustomTextFormField(
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 22,
                  // color: ,
                ),
                controller: _viewModel.zoneSearchController,
                validator: (value) => Validators.validateEmptyField(value),
                hint: lang_key.searchZone.tr,
              )
          ),
        ),
        CustomMaterialButton(
          onPressed: () {},
          text: lang_key.search.tr,
          width: 100,
        )
      ],
    );
  }
}

/// Zone List next page and refresh button
class _NextPageLogAndRefreshButton extends StatelessWidget {
  _NextPageLogAndRefreshButton();

  final ZoneSetupViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 15,
      children: [
        _RefreshAndLogsButton(),
        Obx(() => Row(
            spacing: 8,
            children: [
              Text(
                lang_key.page.tr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(
                    color: primaryGrey,
                    width: 1,
                  ),
                ),
                padding: EdgeInsets.all(3),
                child: Text(
                  _viewModel.currentPage.value.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              Text(
                '${lang_key.of.tr} ${_viewModel.totalPages.value.toString()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if(_viewModel.zoneList.isNotEmpty) Row(
                spacing: 5,
                children: [
                  _NextOrPreviousPageButton(isNext: false),
                  _NextOrPreviousPageButton(isNext: true),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

/// Refresh and Logs button
class _RefreshAndLogsButton extends StatelessWidget {
  const _RefreshAndLogsButton();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Tooltip(
          waitDuration: Duration(milliseconds: 800),
          message: 'Refresh List',
          child: CustomMaterialButton(
            onPressed: () {},
            width: 50,
            borderColor: primaryBlue,
            buttonColor: primaryWhite,
            child: Icon(
              Icons.sync,
              color: primaryBlue,
            ),
          ),
        ),
        Tooltip(
          waitDuration: Duration(milliseconds: 800),
          message: 'Check Logs',
          child: CustomMaterialButton(
            onPressed: () {},
            width: 50,
            borderColor: primaryBlue,
            buttonColor: primaryWhite,
            child: Icon(
              CupertinoIcons.clock,
              color: primaryBlue,
            ),
          ),
        ),
      ],
    );
  }
}

/// Next or Previous Page button
class _NextOrPreviousPageButton extends StatelessWidget {
  _NextOrPreviousPageButton({
    required this.isNext,
  });

  final bool isNext;

  final ZoneSetupViewModel _viewModel = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
        visible: isNext ? _viewModel.currentPage.value < _viewModel.totalPages.value : _viewModel.currentPage.value > 1,
        child: CustomMaterialButton(
          height: 40,
          borderRadius: BorderRadius.circular(6),
          buttonColor: Colors.grey.shade200,
          borderColor: Colors.transparent,
          width: 30,
            onPressed: () {
              if(isNext) {
                _viewModel.currentPage.value++;
              } else {
                _viewModel.currentPage.value--;
              }
            },
          child: Icon(
            isNext ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_rounded,
            size: 15,
          ),
        ),
      ),
    );
  }
}

/// List Columns names section
class _ListColumNames extends StatelessWidget {
  const _ListColumNames();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: primaryBlue.withValues(alpha: 0.2),
        border: Border.all(color: Colors.transparent),
        borderRadius: kContainerBorderRadius
      ),
      child: Row(
        children: [
          _ListColumnNameText(text: 'SL'),
          _ListColumnNameText(text: lang_key.zoneName.tr),
          _ListColumnNameText(text: lang_key.orderVolume.tr),
          _ListColumnNameText(text: lang_key.status.tr),
          _ListColumnNameText(text: lang_key.actions.tr),
        ],
      ),
    );
  }
}

/// List column name text
class _ListColumnNameText extends StatelessWidget {
  const _ListColumnNameText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: primaryBlue,
          fontWeight: FontWeight.w600
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
