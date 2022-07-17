import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as web;
import 'package:mao/utils/app_colors.dart';
import 'package:mao/view/splash_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  HttpOverrides.global = new MyHttpOverrides();
  //MyLocation.instance.determinePosition();
  await Firebase.initializeApp();
  if (Platform.isAndroid) {
    await web.AndroidInAppWebViewController.setWebContentsDebuggingEnabled(
        true);

    var swAvailable = await web.AndroidWebViewFeature.isFeatureSupported(
        web.AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable =
        await web.AndroidWebViewFeature.isFeatureSupported(
            web.AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      web.AndroidServiceWorkerController serviceWorkerController =
          web.AndroidServiceWorkerController.instance();

      serviceWorkerController.serviceWorkerClient =
          web.AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          print(request);
          return null;
        },
      );
    }
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mid America Outdoors',
        theme: ThemeData(
            primaryColor: AppColors.RED,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            textTheme: TextTheme(
              button: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              bodyText1: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black,
              ),
              bodyText2: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              subtitle1: TextStyle(
                color: AppColors.TEXT_GREY,
                fontSize: 10,
                fontWeight: FontWeight.w400,
              ),
              subtitle2: TextStyle(
                color: AppColors.TEXT_GREY,
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),

              headline2: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
              headline1: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
              //TITLE TEXT STYLE
              headline6: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            primarySwatch: Colors.red,
            fontFamily: 'Roboto'),
        home: const SplashScreen(),
      );
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
