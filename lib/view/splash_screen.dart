import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mao/controller/my_controller.dart';
import 'package:mao/models/user_model.dart';
import 'package:mao/services/firebase_messaging_service.dart';
import 'package:mao/utils/app_assets.dart';
import 'package:mao/utils/app_strings.dart';
import 'package:mao/view/home/home_screen.dart';
import 'package:mao/view/signin/pre_signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  MyController myController = Get.put(MyController());
  @override
  void initState() {
    init();
    // Timer(
    //     const Duration(seconds: 3),
    //     () => Navigator.of(context).pushReplacement(
    //         MaterialPageRoute(builder: (BuildContext context) => PreSignin())));
    super.initState();
  }

  Future<Timer> init() async {
    myController.fetcheventListdata();
    return Timer(const Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    final _userdata = GetStorage().read('currenuserdata');
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await FirebaseMessagingService().initializeNotificationSettings();
    FirebaseMessagingService().foregroundNotification();
    FirebaseMessagingService().backgroundTapNotification();

    if (this.mounted) {
      if (PreferencesKeys.token.isNotEmpty && _userdata != null) {
        myController.user = UserModel.fromJson(_userdata);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen()));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => const HomeScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // final UserModel _currentUser =
    // context.read<AuthenticationRepository>().currentUsermodel!;
    //
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    //   print('On Message Opened notification recieved');
    //   if (message.data["type"] == "alert" && _currentUser.userType == UserType.marketer) {
    //
    //     AppNavigation.navigateTo(context, AlertScreen());
    //   }
    //   // else {
    //   //   _notificationController.add(message);
    //   // }
    // });

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppAssets.BACKGROUND,
          fit: BoxFit.fill,
        ),
        Align(
          alignment: Alignment.center,
          child: Image.asset(AppAssets.LOGO),
        ),
      ],
    );
  }
}
