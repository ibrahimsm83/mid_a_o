import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mao/controller/my_controller.dart';
import 'package:mao/utils/index_utils.dart';
import 'package:mao/view/chat/chat_screen.dart';
import 'package:mao/view/events/event_screen.dart';
import 'package:mao/view/signin/pre_signin_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final String title;
  const HomeScreen({Key? key, this.title = AppStrings.EVENTS_SMALL})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _userdata = GetStorage().read('currenuserdata');
  String? _currentSelectedTab = AppStrings.EVENTS_SMALL;
  MyController _myController = Get.put(MyController());
  bool hideBottomNav = false;

  @override
  void initState() {
    //_myController.fetcheventListdata();
    if (widget.title != AppStrings.EVENTS_SMALL) {
      setState(() {
        _currentSelectedTab = AppStrings.NOTIFICATIONS;
      });
    }
    super.initState();
  }

  void onBottomTabTapped(String selectedTab) {
    setState(() {
      _currentSelectedTab = selectedTab;
    });
  }

  launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton:
            hideBottomNav ? Container() : bottomNavigation(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: _currentSelectedTab == AppStrings.EVENTS_SMALL
            ? EventsScreen()
            : Container());
  }

  Widget bottomNavigation(BuildContext context) {
    // final UserModel _currentUser =
    //     context.read<AuthenticationRepository>().currentUsermodel!;
    return Row(
      children: [
        Spacer(),
        bottomNavButton(
          context: context,
          iconsPath: AppAssets.CALENDAR_BLUE,
          title: AppStrings.EVENTS_SMALL,
          updateCurrentTab: onBottomTabTapped,
          currentSelectedTab: _currentSelectedTab,
        ),
        // Spacer(),
        // bottomNavButton(
        //   context: context,
        //   iconsPath: AppAssets.MARKER,
        //   title: AppStrings.GAMIFICATION,
        //   updateCurrentTab: onBottomTabTapped,
        //   currentSelectedTab: _currentSelectedTab,
        // ),
        Spacer(),
        bottomNavButton(
          context: context,
          iconsPath: AppAssets.CHAT,
          title: AppStrings.CHAT,
          updateCurrentTab: (v) async {
           
            if (_userdata != null) {
              //if (_myController.user.bearerToken != null) {
              AppNavigation.navigateTo(context, ChatPage());
            } else {
              _showMyDialog();
            }
            // getUsers().then((bool isblock) {
            //   if (isblock) {
            //     showLongToast("You're Blocked");
            //   } else {
            //     AppNavigation.navigateTo(context, ChatPage());
            //   }
            // });
          },
          currentSelectedTab: _currentSelectedTab,
        ),
        Spacer(),
        bottomNavButton(
          context: context,
          iconsPath: AppAssets.STREAMING,
          title: AppStrings.STREAMING,
          updateCurrentTab: (v) {
            launchURL("https://youtube.com/channel/UCbVSa980A32pGHjQGyYV7Xg");
          },
          currentSelectedTab: _currentSelectedTab,
        ),
        Spacer(),
      ],
    );
  }

  Widget bottomNavButton(
      {required String iconsPath,
      required String title,
      required BuildContext context,
      required String? currentSelectedTab,
      required ValueChanged<String> updateCurrentTab}) {
    bool _isSelected = currentSelectedTab == title;
    return InkWell(
      customBorder:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      hoverColor: Theme.of(context).primaryColor,
      splashColor: Theme.of(context).primaryColor,
      onTap: () {
        updateCurrentTab(title);
      },
      child: Container(
        width: 22.w,
        height: 70,
        decoration: BoxDecoration(
            color: _isSelected
                ? Theme.of(context).primaryColor
                : AppColors.BOTTOM_NAV_COLOR,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          children: [
            Spacer(
              flex: 4,
            ),
            Image.asset(
              iconsPath,
              color: _isSelected ? Colors.white : AppColors.TEXT_GREY,
              width: 30,
              height: 30,
            ),
            Spacer(
              flex: 2,
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: _isSelected ? Colors.white : AppColors.TEXT_GREY,
                  ),
            ),
            Spacer(
              flex: 4,
            )
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,

      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: const Text(
              'You have to Login to access this feature',
              //'AlertDialog Title',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('SignIn'),
              onPressed: () {
                AppNavigation.navigateTo(context, PreSignin());
              },
            ),
          ],
        );
      },
    );
  }
}
