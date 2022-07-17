import 'package:flutter/material.dart';
import 'package:mao/services/validator.dart';
import 'package:mao/utils/index_utils.dart';
import 'package:mao/widgets/index_widgets.dart';

import 'package:sizer/sizer.dart';

class ForgotPassword extends StatelessWidget with EmailAndPasswordValidators {
  ForgotPassword({Key? key}) : super(key: key);
  final FocusNode _emailFocus = FocusNode();
  String _email = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.12),
          child: Container(
            constraints: BoxConstraints.expand(),
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  iconWidget(context),
                  Spacer(
                    flex: 7,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.13 * 0.3,
                      top: MediaQuery.of(context).size.height * 0.13 * 0.3,
                    ),
                    child: Text(
                      AppStrings.FORGOT_PASSWORD,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Spacer(
                    flex: 11,
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.0),
                bottomRight: Radius.circular(16.0),
              ),
            ),
          ),
        ),
        body:
            // BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
            //   listener: (context, state) {
            //     if (state.isSubmitting) {
            //       LoadingDialog.show(context);
            //     } else if (state.isFailure) {
            //       LoadingDialog.hide(context);
            //       CustomSnacksBar.showSnackBar(context, state.message!);
            //     } else if (state.isSuccess) {
            //       LoadingDialog.hide(context);
            //       PlatformAlertDialog(
            //         title: 'Alert',
            //         content:
            //             'Password Reset email is sent to your email verify the email using the link and return back to app for resetting your password.',
            //         defaultActionText: 'Ok',
            //       ).show(context);
            //     }
            //     // TODO: implement listener
            //   },
            //   builder: (context, state) {
            //     return
            SingleChildScrollView(
          child: Container(
            color: AppColors.BACKGROUND_BLUE_HAZE,
            width: MediaQuery.of(context).size.width,
            height: 100.h - MediaQuery.of(context).size.height * 0.2,
            child: Column(
              children: [
                Spacer(
                  flex: 1,
                ),
                Container(
                  height: 47.h,
                  width: MediaQuery.of(context).size.width * 0.8933,
                  decoration: BoxDecoration(
                    color: AppColors.BACKGROUND_BLUE_HAZE,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Spacer(
                            flex: 2,
                          ),
                          Image.asset(
                            AppAssets.LOGO,
                            height: 76,
                            width: MediaQuery.of(context).size.width * 0.776,
                          ),
                          Spacer(
                            flex: 2,
                          ),
                          TextFieldInput(
                            focusNode: _emailFocus,
                            prefixPath: AppAssets.EMAIL_RED,
                            hintText: AppStrings.EMAIL_ADDRESS,
                            inputType: TextInputType.emailAddress,
                            validator: (value) => (value?.isEmpty ?? true)
                                ? AppStrings.EMAIL_IS_REQUIRED
                                // : !state.isEmailValid
                                //     ? AppStrings.VALID_EMAIL_REQUIRED
                                    : null,
                            onChanged: (value) {
                              _email = value;
                            },
                            inputAction: TextInputAction.next,
                            formFieldSubmitted: (value) {
                              _emailFocus.unfocus();
                            },
                          ),
                          Spacer(
                            flex: 1,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              shape: StadiumBorder(),
                              fixedSize: Size(76.4.w, 7.h),
                              minimumSize: Size(76.4.w, 5.h),
                              elevation: 6,
                            ),
                            onPressed: () {},

                            //  !state.isSubmitting
                            //     ? () {
                            //         if (_formKey.currentState!.validate()) {
                            //           // context.read<ForgotPasswordBloc>().add(
                            //           //       Submitted(email: _email),
                            //           //     );
                            //         }
                            //       }
                            //     : null,
                            child: Text(AppStrings.RESET),
                          ),
                          Spacer(
                            flex: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(
                  flex: 6,
                ),
              ],
            ),
          ),
        ));
  }
}
