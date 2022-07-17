import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mao/utils/index_utils.dart';
import 'package:mao/view/forgot_password/forgot_password_screen.dart';
import 'package:mao/view/sign_up_screen.dart';
import 'package:mao/widgets/index_widgets.dart';
import 'package:mao/services/validator.dart';

import 'package:sizer/sizer.dart';

class SigninScreen extends StatelessWidget with EmailAndPasswordValidators {
  SigninScreen({Key? key}) : super(key: key);
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;

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
                    AppStrings.SIGN_IN,
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
          // BlocConsumer<SigninBloc, SigninState>(
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
          color: AppColors.BACKGROUND_BLUE_HAZE,
          width: MediaQuery.of(context).size.width,
          height: 100.h - MediaQuery.of(context).size.height * 0.2,
          child: Column(
            children: [
              Spacer(
                flex: 2,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5899,
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
                          flex: 1,
                        ),
                        Image.asset(
                          AppAssets.LOGO,
                          height: 76,
                          width: MediaQuery.of(context).size.width * 0.776,
                        ),
                        Spacer(
                          flex: 1,
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
                            // context
                            //     .read<SigninBloc>()
                            //     .add(EmailChanged(email: value));
                            _email = value;
                          },
                          inputFormatters: [emailInputFormatter],
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
                            //     .read<SigninBloc>()
                            //     .add(PasswordChanged(password: value));
                            _password = value;
                          },
                          inputAction: TextInputAction.next,
                          formFieldSubmitted: (value) {
                            _emailFocus.unfocus();
                            FocusScope.of(context).requestFocus(_passwordFocus);
                          },
                        ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              AppNavigation.navigateTo(
                                  context, ForgotPassword());
                              // AppNavigation.navigateTo(
                              //     context,
                              //     BlocProvider(
                              //       create: (context) => fp.ForgotPasswordBloc(
                              //           authenticationRepository:
                              //               context.read<
                              //                   AuthenticationRepository>()),
                              //       child: ForgotPassword(),
                              //     ));
                            },
                            child: Text(
                              AppStrings.FORGOT_PASSWORD_BUTTON,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
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
                            /*
                                if (context
                                    .read<SigninBloc>()
                                    .state
                                    .isSignInFormValid) {
                                  context.read<SigninBloc>().add(
                                      SigninButtonPressed(
                                          email: _email, password: _password));
                                } else {
                                  CustomSnacksBar.showSnackBar(context,
                                      'Please correct the form before submitting');
                                }
*/
                            // if (_formKey.currentState!.validate()) {
                            //   if (_email == 'marketer@getnada.com') {
                            //     if (_password == 'Abcd@1234') {
                            //       Marketer.instance.updateMarketerStatus();
                            //       AppNavigation.navigateTo(
                            //           context, HomeScreen());
                            //     } else {
                            //       CustomSnacksBar.showSnackBar(context,
                            //           AppStrings.INCORRECT_PASSWORD);
                            //     }
                            //   } else if (_email == 'user@getnada.com') {
                            //     if (_password == 'Abcd@1234') {
                            //       AppNavigation.navigateTo(
                            //           context, HomeScreen());
                            //     } else {
                            //       CustomSnacksBar.showSnackBar(context,
                            //           AppStrings.INCORRECT_PASSWORD);
                            //     }
                            //   } else {
                            //     CustomSnacksBar.showSnackBar(context,
                            //         AppStrings.INCORRECT_CREDENTIALS);
                            //   }
                            // }
                          },
                          child: Text(AppStrings.SIGN_IN),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(
                flex: 6,
              ),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                    text: AppStrings.NO_ACCOUNT + " ",
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  TextSpan(
                      text: AppStrings.SIGN_UP,
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(color: AppColors.RED),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          //SignupScreen
                          AppNavigation.navigateTo(context, SignupScreen());
                          // AppNavigation.navigateTo(
                          //     context,
                          //     BlocProvider(
                          //       create: (_) => signup.SignupBloc(
                          //           authenticationRepository: context
                          //               .read<AuthenticationRepository>()),
                          //       child: SignupScreen(),
                          //     ));
                        })
                ]),
              ),
              Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      ),
    );
    //);
  }
}
