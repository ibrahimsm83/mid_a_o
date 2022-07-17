import 'package:flutter/material.dart';
import 'package:mao/services/validator.dart';
import 'package:mao/utils/index_utils.dart';
import 'package:mao/widgets/index_widgets.dart';

import 'package:sizer/sizer.dart';

class SignupScreen extends StatelessWidget with EmailAndPasswordValidators {
  SignupScreen({Key? key}) : super(key: key);
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _password;

  late String _email;

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
                    AppStrings.SIGN_UP_TITLE,
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
          // BlocConsumer<SignupBloc, SignupState>(
          //   listener: (context, state) {
          //     if (state.isSubmitting) {
          //       LoadingDialog.show(context);
          //     } else if (state.isSuccess) {
          //       LoadingDialog.hide(context);
          //     } else if (state.isFailure) {
          //       LoadingDialog.hide(context);
          //       CustomSnacksBar.showSnackBar(
          //           context, state.message ?? AppStrings.ERROR_TEXT);
          //     }
          //   },
          //   builder: (context, state) {
          //     return
          SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          color: AppColors.BACKGROUND_BLUE_HAZE,
          height: 100.h - MediaQuery.of(context).size.height * 0.2,
          child: Column(
            children: [
              Spacer(
                flex: 2,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.634,
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
                            // context
                            //     .read<SignupBloc>()
                            //     .add(EmailChanged(email: value));
                          },
                          inputAction: TextInputAction.next,
                          formFieldSubmitted: (value) {
                            _emailFocus.unfocus();
                            FocusScope.of(context).requestFocus(_passwordFocus);
                          },
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        TextFieldInput(
                          focusNode: _passwordFocus,
                          hintText: AppStrings.PASSWORD,
                          inputType: TextInputType.text,
                          prefixPath: AppAssets.PASSWORD_LOCK,
                          isPassword: true,
                          validator: (value) => (value?.isEmpty ?? false)
                              ? AppStrings.PASSWORD_IS_REQUIRED
                              // : !state.isPasswordValid
                              //     ? AppStrings.PASSWORD_INVALID_ERROR
                              : null,
                          onChanged: (value) {
                            // context
                            //     .read<SignupBloc>()
                            //     .add(PasswordChanged(password: value));
                            _password = value;
                          },
                          inputAction: TextInputAction.next,
                          formFieldSubmitted: (value) {
                            _passwordFocus.unfocus();
                            FocusScope.of(context)
                                .requestFocus(_confirmPasswordFocus);
                          },
                        ),
                        SizedBox(height: 12),
                        TextFieldInput(
                          focusNode: _confirmPasswordFocus,
                          hintText: AppStrings.CONFIRM_PASSWORD,
                          inputType: TextInputType.text,
                          prefixPath: AppAssets.PASSWORD_LOCK,
                          isPassword: true,
                          validator: (value) {},
                          // !state.isConfirmPasswordValid
                          //     ? AppStrings.PASSWORD_DONT_MATCH
                          //: null,
                          onChanged: (value) {
                            // context.read<SignupBloc>().add(
                            //       ConfirmPasswordChanged(
                            //         password: _password,
                            //         confirmPassword: value,
                            //       ),
                            //     );
                          },
                          inputAction: TextInputAction.next,
                          formFieldSubmitted: (value) {
                            _confirmPasswordFocus.unfocus();
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // context.read<SignupBloc>().add(Submitted(
                              //     email: _email, password: _password)
                              //     );
                              // AppNavigation.navigateTo(context,
                              //     VerificationScreen(
                              //   onResendCodePressed: () {
                              //     //TODO
                              //   },
                              // ));
                            }
                          },
                          child: Text(AppStrings.SIGN_UP_BUTTON),
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
      ),
      //},
      //),
    );
  }
}
