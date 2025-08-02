import 'package:flutter/material.dart';
import 'package:service_app_admin_panel/helpers/determine_list_height.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/list_text.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/no_data_found.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/refresh_and_logs_button.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/search_field_and_button.dart';
import 'package:get/get.dart';

import '../constants.dart';

class ListBaseContainer extends StatelessWidget {
  const ListBaseContainer({
    super.key,
    this.controller,
    required this.listData,
    required this.columnsNames,
    required this.onRefresh,
    this.hintText,
    this.expandFirstColumn = true,
    this.includeSearchField = true,
    this.fieldWidth = 200,
    this.entryChildren,
    this.onSearch,
    this.itemSize
  }) : assert((
      includeSearchField == false && (controller == null && onSearch == null)) || (includeSearchField == true && (controller != null && onSearch != null)), 'controller and onSearch must be null, if search field is not included. And must be provided if search field is included.');

  final TextEditingController? controller;
  final RxList<dynamic> listData;
  final List<String> columnsNames;
  final String? hintText;
  final bool expandFirstColumn;
  final bool includeSearchField;
  final double fieldWidth;
  final List<Widget>? entryChildren;
  final void Function(String?)? onSearch;
  final VoidCallback onRefresh;
  final double? itemSize;

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
                fieldWidth: fieldWidth,
                controller: controller!,
                hint: hintText,
                onChanged: onSearch,
              ) : SizedBox(),
              RefreshAndLogsButton(onRefresh: onRefresh,),
            ],
          ),
          _ListColumNames(columnNames: columnsNames, expandFirstColumn: expandFirstColumn,),
          Column(
            children: listData.isEmpty ? [
              NoDataFound(),
            ] : entryChildren!
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
      child: ListText(text: text, textColor: primaryBlue,),
    ) : ListText(text: text, textColor: primaryBlue,);
  }
}