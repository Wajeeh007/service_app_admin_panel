import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

import '../constants.dart';
import 'custom_material_button.dart';

class PagesInfoWidget extends StatelessWidget {
  const PagesInfoWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.isListEmpty
  });

  final RxInt currentPage;
  final int totalPages;
  final bool isListEmpty;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Row(
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
            currentPage.value.toString(),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        Text(
          '${lang_key.of.tr} ${totalPages.toString()}',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if(!isListEmpty) Row(
          spacing: 5,
          children: [
            _NextOrPreviousPageButton(isNext: false, currentPage: currentPage, totalPages: totalPages,),
            _NextOrPreviousPageButton(isNext: true, currentPage: currentPage, totalPages: totalPages),
          ],
        )
      ],
    ),
    );
  }
}

/// Next or Previous Page button
class _NextOrPreviousPageButton extends StatelessWidget {
  const _NextOrPreviousPageButton({
    required this.isNext,
    required this.currentPage,
    required this.totalPages
  });

  final bool isNext;
  final RxInt currentPage;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
      visible: isNext ? currentPage.value < totalPages : currentPage.value > 1,
      child: CustomMaterialButton(
        height: 40,
        borderRadius: BorderRadius.circular(6),
        buttonColor: Colors.grey.shade200,
        borderColor: Colors.transparent,
        width: 30,
        onPressed: () {
          if(isNext) {
            currentPage.value++;
          } else {
            currentPage.value--;
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