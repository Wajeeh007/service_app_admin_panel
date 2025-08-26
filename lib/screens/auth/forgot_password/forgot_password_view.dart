import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app_admin_panel/screens/auth/forgot_password/forgot_password_viewmodel.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_material_button.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/custom_text_form_field.dart';
import 'package:service_app_admin_panel/utils/custom_widgets/loader_view.dart';
import 'package:service_app_admin_panel/utils/routes.dart';
import 'package:service_app_admin_panel/utils/validators.dart';

import '../../../languages/translation_keys.dart' as lang_key;

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({super.key});

  final ForgotPasswordViewModel _viewModel = Get.put(ForgotPasswordViewModel());

  @override
  Widget build(BuildContext context) {
    return LoaderView(
        child: Scaffold(
          backgroundColor: primaryWhite,
          body: Padding(
              padding: EdgeInsets.only(top: 25),
            child: Center(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width < 800 ? MediaQuery.sizeOf(context).width * 0.6 : MediaQuery.sizeOf(context).width * 0.4,
                child: Column(
                  spacing: 15,
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: kContainerBorderRadius,
                        border: Border.all(color: primaryGrey.withValues(alpha: 0.5), width: 1)
                      ),
                      child: Icon(
                        Icons.key_rounded,
                        size: 35
                      ),
                    ),
                    Column(
                      spacing: 5,
                      children: [
                        Text(
                          lang_key.forgotPassword.tr,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          lang_key.forgotPasswordDesc.tr,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: primaryGrey
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    Form(
                      key: _viewModel.formKey,
                      child: CustomTextFormField(
                        hint: 'abc@example.com',
                        controller: _viewModel.emailController,
                        title: lang_key.email.tr,
                        titleColor: primaryBlack,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => Validators.validateEmail(value),
                      ),
                    ),
                    CustomMaterialButton(
                      onPressed: () => _viewModel.forgotPassword(),
                      text: lang_key.resetPassword.tr,
                    ),
                    InkWell(
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                      hoverColor: Colors.transparent,
                      onTap: () => Get.offNamed(Routes.login),
                      child: Row(
                        spacing: 15,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.arrow_back, size: 25, color: primaryGrey,),
                          Text(
                            lang_key.backToLogin.tr,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: primaryGrey
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}
