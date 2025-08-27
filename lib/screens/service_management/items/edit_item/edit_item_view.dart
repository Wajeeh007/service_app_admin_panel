import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/item_form_section.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import '../../../../utils/custom_widgets/section_heading_text.dart';
import 'edit_item_viewmodel.dart';

class EditItemView extends StatelessWidget {
  EditItemView({super.key});

  final EditItemViewModel _viewModel = Get.put(EditItemViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.itemsList.tr,
        children: [
          SectionHeadingText(headingText: lang_key.editItem.tr),
          ItemFormSection(
            isBeingEdited: true,
              onPressed: () => _viewModel.editItem(),
              formKey: _viewModel.formKey,
              nameController: _viewModel.itemNameController,
              priceController: _viewModel.itemPriceController,
              subServiceTypeController: _viewModel.subServiceTypeController,
              overlayPortalController: _viewModel.overlayPortalController,
              subServicesList: _viewModel.subServicesList,
              subServiceTypeSelectedId: _viewModel.subServiceTypeSelectedId,
              showDropDown: _viewModel.showSubServiceTypeDropDown,
              newImageToUpload: _viewModel.addedServiceImage,
            imageUrl: _viewModel.imageUrl,
          )
        ]
    );
  }
}
