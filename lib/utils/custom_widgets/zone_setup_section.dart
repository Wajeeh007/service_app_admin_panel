import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import 'package:service_app_admin_panel/languages/translation_keys.dart' as lang_key;

import '../images_paths.dart';
import '../validators.dart';
import 'custom_google_maps.dart';
import 'custom_material_button.dart';
import 'custom_text_form_field.dart';
import 'heading_in_container_text.dart';

class ZoneSetupSection extends StatelessWidget {
  const ZoneSetupSection({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descController,
    this.isBeingEdited = false,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descController;
  final bool isBeingEdited;

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
                      HeadingInContainerText(text: lang_key.instructions.tr),
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
                      HeadingInContainerText(text: lang_key.zoneName.tr),
                      Form(
                        key: formKey,
                        child: Column(
                          spacing: 10,
                          children: [
                            CustomTextFormField(
                              autoValidateMode: AutovalidateMode.onUserInteraction,
                              controller: nameController,
                              validator: (value) => Validators.validateEmptyField(value),
                              hint: 'Ex: Toronto',
                            ),

                            CustomTextFormField(
                              title: lang_key.description.tr,
                              autoValidateMode: AutovalidateMode.onUserInteraction,
                              controller: descController,
                              validator: (value) => Validators.validateEmptyField(value),
                              hint: lang_key.typeHere.tr,
                              maxLines: 4,
                            ),
                          ],
                        ),
                      ),
                      GoogleMapWidget(isBeingEdited: isBeingEdited,),
                    ],
                  ),
                ),
              ]
          ),
          CustomMaterialButton(
            width: 100,
            onPressed: () {
              if(formKey.currentState!.validate()) {

              }
            },
            text: lang_key.save.tr,
          )
        ],
      ),
    );
  }
}