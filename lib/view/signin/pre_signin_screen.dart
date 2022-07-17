import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mao/services/social_login.dart';
import 'package:mao/utils/app_assets.dart';
import 'package:mao/utils/app_colors.dart';
import 'package:mao/utils/app_strings.dart';
import 'package:mao/utils/navigation.dart';
import 'package:mao/view/events/event_screen.dart';
import 'package:mao/view/home/home_screen.dart';

import 'dart:io' show Platform;

import 'package:sizer/sizer.dart';

import '../term_condition_dialog/tc_dialog_screen.dart';

class PreSignin extends StatefulWidget {
  const PreSignin({Key? key}) : super(key: key);

  @override
  State<PreSignin> createState() => _PreSigninState();
}

class _PreSigninState extends State<PreSignin> {
  String? devicetoken;
  @override
  void initState() {
    // TODO: implement initState
    getdevicetoken();
    super.initState();
  }

  void getdevicetoken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    setState(() {
      if (token != null && token.isNotEmpty) devicetoken = token;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.13),
        child: Container(
          constraints: BoxConstraints.expand(),
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.13 * 0.3,
                  left: 5.0,
                  right: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      AppNavigation.navigateReplacement(context, HomeScreen());
                    },
                    child: Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    AppStrings.PRE_SIGN_IN,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(height: 1.0),
                ],
              ),
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
      body: Container(
        color: AppColors.BACKGROUND_BLUE_HAZE,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(
              flex: 1,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.5899,
              width: MediaQuery.of(context).size.width * 0.8933,
              decoration: BoxDecoration(
                color: Colors.white,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(
                    flex: 6,
                  ),
                  Image.asset(
                    AppAssets.LOGO,
                    height: 76,
                    width: MediaQuery.of(context).size.width * 0.776,
                  ),
                  Spacer(
                    flex: 4,
                  ),
                  /*
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      shape: StadiumBorder(),
                      fixedSize: Size(76.w, 7.h),
                      minimumSize: Size(76.w, 37),
                    ),
                    icon: ImageIcon(
                      AssetImage(AppAssets.EMAIL_ICON),
                      color: Colors.white,
                    ),
                    label: Text(
                      AppStrings.SIGN_IN_WITH_EMAIL,
                      style: Theme.of(context).textTheme.button,
                    ),
                    onPressed: () {
                      AppNavigation.showDialogGeneral(context, TCDialog(), true)
                          .then((value) {
                        if (value != null) {
                          if (value) {
                            print("sign in screen ");
                            AppNavigation.navigateTo(context, SigninScreen());
                            // AppNavigation.navigateTo(
                            //     context,
                            //     BlocProvider(
                            //       create: (context) => SigninBloc(
                            //           authenticationRepository: context
                            //               .read<AuthenticationRepository>()),
                            //       child: SigninScreen(),
                            //     ));
                          }
                        }
                      });
                    },
                  ),

                  */
                  Platform.isIOS
                      ? Spacer(
                          flex: 1,
                        )
                      : SizedBox.shrink(),
                  Spacer(
                    flex: 1,
                  ),
                  Visibility(
                    visible: Platform.isIOS,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).primaryColor,
                        shape: StadiumBorder(),
                        fixedSize: Size(76.w, 7.h),
                        minimumSize: Size(76.w, 37),
                      ),
                      icon: ImageIcon(
                        AssetImage(AppAssets.APPLE_ICON),
                        color: Colors.white,
                      ),
                      label: Text(
                        AppStrings.SIGN_IN_WITH_APPLE,
                        style: Theme.of(context).textTheme.button,
                      ),
                      onPressed: () {
                        AppNavigation.showDialogGeneral(
                                context, TCDialog(), true)
                            .then((value) {
                          if (value != null) {
                            if (value) {
                              FirebaseAuthBloc loginauth = FirebaseAuthBloc();
                              loginauth.signInWithApple(
                                context: context,
                                socialType: "apple",
                                devicetoke: devicetoken ?? "",
                                deviceType: Platform.isIOS ? "ios" : "android",
                              );
                              // context
                              //     .read<SigninBloc>()
                              //     .add(SigninWithApplePressed());
                            }
                          }
                        });
                      },
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  /*
                  // Platform.isIOS
                  //     ? Spacer(
                  //         flex: 1,
                  //       )
                  //     : SizedBox.shrink(),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      shape: StadiumBorder(),
                      fixedSize: Size(76.w, 7.h),
                      minimumSize: Size(76.w, 37),
                    ),
                    icon: ImageIcon(
                      AssetImage(AppAssets.FACEBOOK_ICON),
                      color: Colors.white,
                    ),
                    label: Text(
                      AppStrings.SIGN_IN_WITH_FACEBOOK,
                      style: Theme.of(context).textTheme.button,
                    ),
                    onPressed: () {
                      AppNavigation.showDialogGeneral(context, TCDialog(), true)
                          .then((value) {
                        if (value != null) {
                          if (value) {
                            AppNavigation.navigateTo(context, HomeScreen());
                            // context
                            //     .read<SigninBloc>()
                            //     .add(SigninWithFacebookPressed());
                          }
                        }
                      });
                    },
                  ),
                */
                  Spacer(
                    flex: 1,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      shape: StadiumBorder(),
                      fixedSize: Size(76.w, 7.h),
                      minimumSize: Size(76.w, 37),
                    ),
                    icon: ImageIcon(
                      AssetImage(AppAssets.GOOGLE_ICON),
                      color: Colors.white,
                    ),
                    label: Text(
                      AppStrings.SIGN_IN_WITH_GOOGLE,
                      style: Theme.of(context).textTheme.button,
                    ),
                    onPressed: () {
                      AppNavigation.showDialogGeneral(context, TCDialog(), true)
                          .then((value) {
                        if (value != null) {
                          print(devicetoken);
                          if (value) {
                            FirebaseAuthBloc loginauth = FirebaseAuthBloc();
                            print("device token");
                            print(devicetoken);
                            loginauth.signInWithGoogle(
                              context: context,
                              socialType: "google",
                              devicetoke: devicetoken ?? "",
                              deviceType: Platform.isIOS ? "ios" : "android",
                            );
                            //EventsScreen
                            // AppNavigation.navigateTo(context, HomeScreen());
                            // context
                            //     .read<SigninBloc>()
                            //     .add(SigninWithGooglePressed());
                          }
                        }
                      });
                    },
                  ),
                  Spacer(
                    flex: 6,
                  ),
                ],
              ),
            ),
            Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}
