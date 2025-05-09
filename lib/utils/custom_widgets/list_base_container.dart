import 'package:flutter/material.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/refresh_and_logs_button.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/search_field_and_button.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../images_paths.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

class ListBaseContainer extends StatelessWidget {
  const ListBaseContainer({
    super.key,
    this.formKey,
    this.controller,
    required this.listData,
    required this.columnsNames,
    this.hintText,
    this.expandFirstColumn = true,
    this.includeSearchField = true
  }) : assert((includeSearchField == false && (controller == null && formKey == null)) || (includeSearchField == true && (controller != null && formKey != null)), 'controller and formkey must be null, if search field is not included. And must be provided if search field is included.');

  final GlobalKey<FormState>? formKey;
  final TextEditingController? controller;
  final RxList<dynamic> listData;
  final List<String> columnsNames;
  final String? hintText;
  final bool expandFirstColumn;
  final bool includeSearchField;

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
              includeSearchField ? SearchFieldAndButton(
                formKey: formKey!,
                controller: controller!,
                hint: hintText,
              ) : SizedBox(),
              RefreshAndLogsButton(),
            ],
          ),
          _ListColumNames(columnNames: columnsNames, expandFirstColumn: expandFirstColumn,),
          Obx(() => Column(
            children: listData.isEmpty ? [
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

/// List Columns names section
class _ListColumNames extends StatelessWidget {
  const _ListColumNames({
    required this.columnNames,
    this.expandFirstColumn = true
  });

  final List<String> columnNames;
  final bool expandFirstColumn;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: EdgeInsets.only(left: 15),
      decoration: BoxDecoration(
          color: primaryBlue.withValues(alpha: 0.2),
          border: Border.all(color: Colors.transparent),
          borderRadius: kContainerBorderRadius
      ),
      child: Row(
        children: List.generate(
            columnNames.length,
            (index) {
              if(index == 0) {
                return _ListColumnNameText(text: columnNames[index], shouldExpand: expandFirstColumn,);
              }
              return _ListColumnNameText(text: columnNames[index]);

            }
        )
      ),
    );
  }
}

/// List column name text
class _ListColumnNameText extends StatelessWidget {
  const _ListColumnNameText({required this.text, this.shouldExpand = true});

  final String text;
  final bool shouldExpand;

  @override
  Widget build(BuildContext context) {
    return shouldExpand ? Expanded(
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: primaryBlue,
            fontWeight: FontWeight.w600
        ),
        textAlign: TextAlign.center,
      ),
    ) : Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: primaryBlue,
          fontWeight: FontWeight.w600
      ),
      textAlign: TextAlign.center,
    );
  }
}