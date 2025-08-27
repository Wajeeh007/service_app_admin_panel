import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../languages/translation_keys.dart' as lang_key;
import '../../../utils/constants.dart';
import '../../../utils/custom_widgets/custom_material_button.dart';
import '../../../utils/custom_widgets/loader_view.dart';
import '../../../utils/routes.dart';
import 'check_email_viewmodel.dart';

class CheckEmailView extends StatelessWidget {
  CheckEmailView({super.key});

  final CheckEmailViewModel _viewModel = Get.put(CheckEmailViewModel());

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
                          CupertinoIcons.envelope,
                          size: 35
                      ),
                    ),
                    Column(
                      spacing: 5,
                      children: [
                        Text(
                          lang_key.checkEmail.tr,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Obx(() => Text(
                            "${lang_key.checkEmailDesc.tr} ${_viewModel.email.value}",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: primaryGrey
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    Obx(() => Text(
                      _viewModel.remainingTime.value,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w300
                      ),
                    ),
                    ),
                    Obx(() => RichText(
                      text: TextSpan(
                        text: "${lang_key.didntReceiveEmail.tr} ",
                        style: Theme.of(context).textTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: lang_key.resendEmail.tr,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _viewModel.remainingTime.value == '00 : 00' ? primaryBlue : primaryGrey,
                            fontWeight: _viewModel.remainingTime.value == '00 : 00' ? FontWeight.bold : null
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () => _viewModel.resendEmail(),
                        )
                      ]
                      ),
                    )
                    //     Column(
                    //   children: [
                    //     Text(
                    //       lang_key.didntReceiveEmail.tr,
                    //       style: Theme.of(context).textTheme.bodySmall,
                    //     ),
                    //     CustomMaterialButton(
                    //       text: lang_key.resendEmail.tr,
                    //       onPressed: () => _viewModel.resendEmail(),
                    //       textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    //           color: primaryBlue,
                    //           decoration: TextDecoration.underline,
                    //           decorationColor: primaryBlue
                    //       ),
                    //     ),
                    //   ],
                    // )
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
