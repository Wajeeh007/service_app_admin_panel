import 'package:flutter/material.dart';

import '../constants.dart';
import '../images_paths.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;
import 'package:get/get.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(ImagesPaths.noData, height: 60,),
        Text(
          lang_key.noDataAvailable.tr,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: primaryGrey
          ),
        )
      ],
    );
  }
}