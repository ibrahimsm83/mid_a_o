import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mao/controller/my_controller.dart';
import 'package:mao/models/user_model.dart';
import 'package:mao/services/network.dart';
import 'package:mao/utils/index_utils.dart';
import 'package:mao/view/home/home_screen.dart';
import 'package:mao/widgets/custome_snacksbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class FirebaseAuthBloc {
  MyController _myController = Get.put(MyController());
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  UserCredential? _userCredential;

  User? _user;
  //SocialLoginBloc _socialLoginBloc = SocialLoginBloc();

  ///-------------------- Google Sign In -------------------- ///
  Future<void> signInWithGoogle(
      {required BuildContext context,
      required String socialType,
      required String devicetoke,
      required String deviceType}) async {
    try {
      log("Device Token:${devicetoke}");
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          // 'https://www.googleapis.com/auth/contacts.readonly',
        ],
      );

      GoogleSignInAccount? _googleSignInAccount = await _googleSignIn.signIn();

      if (_googleSignInAccount != null) {
        await _googleSignIn.signOut();
        _socialLoginMethod(
          context: context,
          deviceType: deviceType,
          email: _googleSignInAccount.email,
          device_token: devicetoke,
          socialToken: _googleSignInAccount.id,
          socialType: socialType,
          userName: _googleSignInAccount.displayName,
        );
      }
    } catch (error) {
      //log(error.toString());
      CustomSnacksBar.showSnackBar(context, error.toString());
      //AppDialogs.showToast(message: error.toString());
    }
  }
/*
  ///-------------------- Facebook Sign In -------------------- ///
  Future<void> signInWithFacebook(
      {required BuildContext context, required String socialType}) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );
      if (result.status == LoginStatus.success) {
        // log("Graph response body" + graphResponse.body.toString());
        Map<String, dynamic> facebookUserData =
            await FacebookAuth.instance.getUserData();

        await FacebookAuth.instance.logOut();

        if (facebookUserData != null) {
          _socialLoginMethod(
              context: context,
              userFullName: facebookUserData["name"],
              socialToken: facebookUserData["id"],
              socialType: socialType);
        }
      } else if (result.status == LoginStatus.failed) {
         CustomSnacksBar.showSnackBar(context, result.message.toString());
        //AppDialogs.showToast(message: result.message.toString());
        //print(result.message.toString());
      } else if (result.status == LoginStatus.cancelled) {
        CustomSnacksBar.showSnackBar(context, result.message.toString());
       // AppDialogs.showToast(message: result.message.toString());
        //print(result.message.toString());
      }
    } catch (error) {
      CustomSnacksBar.showSnackBar(context, error.toString());
      // print(error.toString());
      //AppDialogs.showToast(message: error.toString());
    }
  }
*/
  //-------------------- Apple Sign In -------------------- //

  Future<void> signInWithApple(
      {required BuildContext context,
      required String socialType,
      required String devicetoke,
      required String deviceType}) async {
    String _givenName, _familyName, _userFullName, _email;
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential != null) {
        print(credential);
        _givenName = credential.givenName ?? "";
        _familyName = credential.familyName ?? "";
        _userFullName = _givenName + " " + _familyName;
        _email = credential.email ?? "abc@gmail.com";

        _socialLoginMethod(
            context: context,
            email: _email,
            deviceType: deviceType,
            device_token: devicetoke,
            userName:
                _userFullName.trim().isNotEmpty ? _userFullName.trim() : "user",
            socialToken: credential.userIdentifier,
            socialType: socialType);
      }
    } catch (error) {
      CustomSnacksBar.showSnackBar(context, error.toString());
      //print(error.toString());
      //AppDialogs.showToast(message: error.toString());
    }
  }

/*
  ////////////////////////// Phone Sign In //////////////////////////////////
  Future<void> signInWithPhone(
      {required BuildContext context,
      required String phoneNumber,
      required VoidCallback setProgressBar,
      required VoidCallback cancelProgressBar}) async {
    try {
      setProgressBar();
      FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: Duration(seconds: 60),
          verificationCompleted: (AuthCredential authCredential) async {
            print("verification completed");
          },
          verificationFailed: (FirebaseAuthException authException) {
            if (authException.code == AppStrings.INVALID_PHONE_NUMBER) {
              cancelProgressBar();
               CustomSnacksBar.showSnackBar(context, error.toString());
              // AppDialogs.showToast(
              //     message: AppStrings.INVALID_PHONE_NUMBER_MESSAGE);
            } else {
              cancelProgressBar();
              AppDialogs.showToast(message: authException.message);
            }
            //print(authException.message);
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            //log("Verification Id:${verificationId}");
            cancelProgressBar();

            AppNavigation.navigateTo(
                context, AppRouteName.VERIFY_OTP_SCREEN_ROUTE,
                arguments: OtpArguments(
                    checkOtpType: AppStrings.PHONE_OTP_CHECK_TEXT,
                    phoneNumber: phoneNumber,
                    verificationId: verificationId));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            log("Timeout Verification id:${verificationId.toString()}");
          });
    } catch (error) {
      log("error");
      cancelProgressBar();
      AppDialogs.showToast(message: error.toString());
    }
  }

  Future<void> verifyPhoneCode(
      {required BuildContext context,
      String? socialType,
      required String verificationId,
      required String verificationCode}) async {
    try {
      print("Verify Phone Code Starts");

      AuthCredential _credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: verificationCode);

      _userCredential = await _firebaseAuth.signInWithCredential(_credential);

      _user = _userCredential?.user;

      if (_user != null) {
        await _firebaseUserSignOut();

        // API Call Here
        _socialLoginMethod(
          context: context,
          userFullName: null,
          socialToken: _user?.uid,
          socialType: socialType,
        );
      }
    } catch (error) {
      AppDialogs.showToast(message: error.toString());
    }
  }

  Future<void> resendPhoneCode(
      {required BuildContext context,
      required String phoneNumber,
      required ValueChanged<String?> getVerificationId,
      required VoidCallback setProgressBar,
      required VoidCallback cancelProgressBar}) async {
    setProgressBar();
    try {
      _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: Duration(seconds: 60),
          verificationCompleted: (AuthCredential authCredential) async {},
          verificationFailed: (FirebaseAuthException authException) {
            cancelProgressBar();
            AppDialogs.showToast(message: authException.message);
            //print(authException.message);
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            cancelProgressBar();
            getVerificationId(verificationId);
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            log(verificationId.toString());
          });
    } catch (error) {
      cancelProgressBar();
      AppDialogs.showToast(message: error.toString());
    }
  }
*/
  ///-------------------- Sign Out -------------------- ///
  Future<void> _firebaseUserSignOut() async {
    await _firebaseAuth.signOut();
  }

  void _socialLoginMethod({
    required BuildContext context,
    String? deviceType,
    String? socialToken,
    String? device_token,
    String? socialType,
    String? userName,
    String? email,
  }) async {
    print("**************55******");
    print("-------------------2---------------------");
    print(socialToken);
    print(socialType);
    print(userName);
    print(email);
    // Sociallogin
    UserModel? res = await NetworkApi.Sociallogin(
        access_token: socialToken!,
        device_type: deviceType!,
        device_token: device_token ?? "",
        provider: socialType!,
        user_name: userName ?? "",
        email: email ?? "");
    if (res != null) {
      if (res.status == 1) {
        print("response data added successfully");
        _myController.user = res;
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        GetStorage().write("currenuserdata", res.toJson());
        await _prefs.setString(PreferencesKeys.token, res.bearerToken ?? "");

        print("data-------2445424---");
        print(res.message);
        print(res.data);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        print("data----no---2445424---");
        print(res.message);
      }
    }
    // context: context,
    // userFullName: userFullName,
    // userSocialToken: socialToken ?? "",
    // userSocialType: socialType ?? "",
    // setProgressBar: () {
    //   progressAlertDialog(context: context);
    // });
  }

  static void progressAlertDialog({required BuildContext context}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.RED,
              ),
            ),
          );
        });
  }
}
