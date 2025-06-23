
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/item_form_section.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/screens_base_widget.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:service_app_admin_panel/utils/custom_widgets/section_heading_text.dart';

import '../../../../helpers/show_confirmation_dialog.dart';
import '../../../../utils/custom_widgets/custom_cached_network_image.dart';
import '../../../../utils/custom_widgets/custom_switch.dart';
import '../../../../utils/custom_widgets/list_actions_buttons.dart';
import '../../../../utils/custom_widgets/list_base_container.dart';
import '../../../../utils/custom_widgets/list_entry_item.dart';
import '../../../../utils/routes.dart';
import 'items_list_viewmodel.dart';

class ItemsListView extends StatelessWidget {
  ItemsListView({super.key});

  final ItemsListViewModel _viewModel = Get.put(ItemsListViewModel());

  @override
  Widget build(BuildContext context) {
    return ScreensBaseWidget(
        scrollController: _viewModel.scrollController,
        selectedSidePanelItem: lang_key.itemsList.tr,
        children: [
          SectionHeadingText(headingText: lang_key.addItemDetails.tr),
          ItemFormSection(
              onPressed: () => _viewModel.addNewItem(),
              formKey: _viewModel.itemAdditionFormKey,
              nameController: _viewModel.itemNameController,
              priceController: _viewModel.itemPriceController,
              subServiceTypeController: _viewModel.subServiceTypeController,
              overlayPortalController: _viewModel.overlayPortalController,
              subServicesList: _viewModel.subServicesList,
              subServiceTypeSelectedId: _viewModel.subServiceTypeSelectedId,
              showDropDown: _viewModel.showSubServiceTypeDropDown,
              newImageToUpload: _viewModel.addedItemImage
          ),
          Obx(() => ListBaseContainer(
                onSearch: (value) => _viewModel.searchTableForServiceItem(value),
                onRefresh: () => _viewModel.fetchServiceItems(),
                controller: _viewModel.searchController,
                listData: _viewModel.visibleItemsList,
                hintText: lang_key.searchItem.tr,
                expandFirstColumn: false,
                columnsNames: [
                  'SL',
                  lang_key.image.tr,
                  lang_key.name.tr,
                  lang_key.subService.tr,
                  lang_key.price.tr,
                  lang_key.status.tr,
                  lang_key.actions.tr
                ],
              entryChildren: List.generate(_viewModel.visibleItemsList.length, (index) {
                return Padding(
                  padding: listEntryPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ListEntryItem(text: (index + 1).toString(), shouldExpand: false,),
                      ListEntryItem(
                          child: Container(
                            padding: EdgeInsets.only(left: 8),
                            width: 50,
                            height: 40,
                            child: CustomNetworkImage(
                              imageUrl: _viewModel.visibleItemsList[index].image!,
                              boxFit: BoxFit.fitHeight,
                            ),
                          )
                      ),
                      ListEntryItem(text: _viewModel.visibleItemsList[index].name,),
                      ListEntryItem(text: _viewModel.visibleItemsList[index].subServiceName,),
                      ListEntryItem(text: "\$${_viewModel.visibleItemsList[index].price}",),
                      ListEntryItem(
                        child: CustomSwitch(
                          switchValue: _viewModel.visibleItemsList[index].status!,
                          onChanged: (value) => _viewModel.changeItemStatus(_viewModel.visibleItemsList[index].id!),
                        ),
                      ),
                      ListEntryItem(
                        child: ListActionsButtons(
                          includeDelete: true,
                          includeEdit: true,
                          includeView: false,
                          onDeletePressed: () => showConfirmationDialog(onPressed: () => _viewModel.deleteItem(_viewModel.visibleItemsList[index].id!)),
                          onEditPressed: () => Get.toNamed(Routes.editItem, arguments: {'serviceItemDetails': _viewModel.visibleItemsList[index], 'subServicesList': _viewModel.subServicesList}),
                        ),
                      )
                    ],
                  ),
                );
              }),
            ),
          ),
        ]
    );
  }
}