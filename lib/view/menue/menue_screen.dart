import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mao/controller/my_controller.dart';
import 'package:mao/models/app_user.dart';
import 'package:mao/utils/image_utility.dart';
import 'package:mao/utils/index_utils.dart';
import 'package:mao/view/menue/conditions_screen.dart';
import 'package:mao/view/menue/webview_screen.dart';
import 'package:mao/view/signin/pre_signin_screen.dart';
import 'package:mao/widgets/index_widgets.dart';
import 'package:sizer/sizer.dart';

class MeneScreen extends StatefulWidget {
  MeneScreen({Key? key}) : super(key: key);

  @override
  _MeneScreenState createState() => _MeneScreenState();
}

class _MeneScreenState extends State<MeneScreen> {
  final _userdata = GetStorage().read('currenuserdata');
  final ImagePickerUtility _imagePickerUtility = ImagePickerUtility();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  MyController _myController = Get.put(MyController());
  @override
  void initState() {
    //final _userdata = GetStorage().read('currenuserdata');
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(_myController.user.data!.email);
    // print(_myController.user.data!.image);
    // final _currentUser =
    //     context.read<AuthenticationRepository>().currentUsermodel;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.BACKGROUND_BLUE_HAZE,
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
                    AppStrings.MENU,
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
          // Obx(
          //   () =>
          Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(
              flex: 1,
            ),
            Container(
              width: 89.3.w,
              height: UserType.user == UserType.user ? 73.3.h : 75.h,
              // height: _currentUser!.userType == UserType.user ? 73.3.h : 75.h,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Spacer(
                    flex: 2,
                  ),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 32.2.w,
                        height: 32.2.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.CAMERA_BORDER,
                            width: 8,
                          ),
                        ),
                        child:
                            //  Obx(
                            //   () =>
                            Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                            ),
                            image: DecorationImage(
                              image: _imagePickerUtility.image != null &&
                                      _userdata == null
                                  //&&
                                  //_myController.user.data?.image
                                  // _userdata['data']['image'] == null
                                  ? (FileImage(
                                          _imagePickerUtility.image ?? File(''))
                                      as ImageProvider)
                                  : (NetworkImage(
                                          // Constants.imageUrl +
                                          _userdata != null
                                              ? _userdata['data']['image'] ??
                                                  'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png'
                                              : 'https://www.freeiconspng.com/thumbs/profile-icon-png/profile-icon-9.png')
                                      //       _myController.user.data!.image!)
                                      // 'https://media.istockphoto.com/photos/millennial-male-team-leader-organize-virtual-workshop-with-employees-picture-id1300972574?b=1&k=20&m=1300972574&s=170667a&w=0&h=2nBGC7tr0kWIU8zRQ3dMg-C5JLo9H2sNUuDjQ5mlYfo=' /*_currentUser.photoURL*/)
                                      as ImageProvider),
                              fit: BoxFit.cover,
                            ),
                          ),
                          //),
                        ),
                      ),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: IconButton(
                            onPressed: () async {
                              if (_userdata != null) {
                                var selectimageFile = await _imagePickerUtility
                                    .pickImageWithReturn(context);
                                print(
                                    "select image file **********1*****************");
                                // print(selectimageFile);
                                if (selectimageFile != null) {
                                  print(
                                      "select image file ***********2****************");
                                  _myController.setProfileImagePath(
                                      selectimageFile.path);
                                  _myController.UpdateProfile();
                                }
                                // _imagePickerUtility
                                //     .pickImage(context)
                                //     .whenComplete(() {
                                //   setState(() {});
                                //   if (_imagePickerUtility.image != null) {
                                //     CustomSnacksBar.showSnackBar(
                                //         context, 'Updating your photos');
                                //     // context
                                //     //     .read<AuthenticationRepository>()
                                //     //     .updateProfile(
                                //     //         photoToUpload:
                                //     //             _imagePickerUtility.image!.path)
                                //     //     .whenComplete(() {
                                //     //   setState(() {});
                                //     //   CustomSnacksBar.showSnackBar(context,
                                //     //       'Profile photo updated successfully');
                                //     // });
                                // } else {
                                //   CustomSnacksBar.showSnackBar(
                                //       context, 'No image selected');
                                // }
                                //});
                              } else {
                                _showMyDialog();
                              }
                            },
                            icon: Container(
                              width: 8.w,
                              height: 8.w,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 1,
                                  color: Colors.white,
                                ),
                              ),
                              child: ImageIcon(
                                AssetImage(
                                  AppAssets.EDIT_ICON,
                                ),
                                color: Colors.white,
                                size: 12,
                              ),
                            ),
                          )),
                    ],
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Text(
                    _userdata != null
                        ? _userdata['data']['username'] ?? ""
                        : "",
                    //'Name ',
                    //_currentUser.dispalyName,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Text(
                    // "Email",
                    _userdata != null ? _userdata['data']['email'] ?? "" : "",
                    // _currentUser.email,
                    style: Theme.of(context).textTheme.headline1!.copyWith(
                          color: AppColors.TEXT_GREY,
                        ),
                  ),
                  Spacer(flex: 1),
                  Expanded(
                    flex: 34,
                    child: GridView.count(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      physics: ClampingScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 37.6.w / 13.35.h,
                      mainAxisSpacing: 12,
                      children: [
                        // menuItemCards(
                        //     context: context,
                        //     title: AppStrings.CHANGE_PASSWORD_SMALL,
                        //     iconPath: AppAssets.LOCK_ICON,
                        //     onPressed: () {
                        //       // AppNavigation.navigateTo(
                        //       //     context,
                        //       //     BlocProvider<ChangePasswordCubit>(
                        //       //       create: (context) => ChangePasswordCubit(
                        //       //           authenticationRepository: context
                        //       //               .read<AuthenticationRepository>()),
                        //       //       child: ChangePasswordScreen(
                        //       //         isFromFrogetPassword: false,
                        //       //       ),
                        //       //     ));
                        //     }),
                        menuItemCards(
                            context: context,
                            title:
                                AppStrings.TERMS_AND_CONDITIONS_DIFFERENT_AND,
                            iconPath: AppAssets.TC_ICON,
                            onPressed: () {
                              AppNavigation.navigateTo(
                                context,
                                ConditionsScreen(
                                  title:
                                      AppStrings.TERMS_AND_CONDITIONS_ALL_CAPS,
                                  assetPath: 'assets/terms_and_conditions.html',
                                ),
                              );
                            }),
                        menuItemCards(
                            context: context,
                            title: AppStrings.PRIVACY_POLICY,
                            iconPath: AppAssets.INSURANCE,
                            onPressed: () {
                              AppNavigation.navigateTo(
                                  context,
                                  ConditionsScreen(
                                    title: AppStrings.PRIVACY_POLICY,
                                    assetPath: 'assets/privacy_policy.html',
                                  ));
                            }),
                        // if (_currentUser.userType == UserType.marketer)
                        //   menuItemCards(
                        //       context: context,
                        //       title: AppStrings.ALERTS,
                        //       iconPath: AppAssets.ALERT,
                        //       onPressed: () {
                        //       //   AppNavigation.navigateTo(
                        //       //       context, AlertScreen());
                        //        }),
                        // if (_currentUser.userType == UserType.user)
                        menuItemCards(
                            context: context,
                            title: AppStrings.PARK_WAIVER,
                            iconPath: AppAssets.PARK_WAIVER,
                            onPressed: () {
                              AppNavigation.navigateTo(
                                  context,
                                  InAppView("${AppStrings.parkLink}",
                                      AppStrings.PARK_WAIVER));
                              // AppNavigation.navigateTo(
                              //         context,ChatPage());
                            }),
                        // if (_currentUser.userType == UserType.user)
                        menuItemCards(
                            context: context,
                            title: AppStrings.SHOPIFY,
                            iconPath: AppAssets.SHOPIFY,
                            onPressed: () {
                              AppNavigation.navigateTo(
                                  context,
                                  InAppView("${AppStrings.spotifyLink}",
                                      AppStrings.SHOPIFY));
                            }),
                        menuItemCards(
                            context: context,
                            title: _userdata != null
                                ? AppStrings.LOGOUT
                                : AppStrings.SIGN_IN,
                            iconPath: AppAssets.LOGOUT,
                            onPressed: () async {
                              if (_userdata != null) {
                                showLoaderDialog(context);
                                var resp = await _myController.Logout();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => PreSignin()),
                                    (Route<dynamic> route) => false);
                                CustomSnacksBar.showSnackBar(
                                    context, resp['message']);
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PreSignin()));
                              }
                            }),
                      ],
                    ),
                  ),
                  Spacer(flex: 1),
                ],
              ),
            ),
            Spacer(
              flex: 1,
            ),
          ],
        ),
        //),
      ),
    );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget menuItemCards({
    required BuildContext context,
    required String title,
    required String iconPath,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12.0),
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          children: [
            Spacer(),
            ImageIcon(
              AssetImage(iconPath),
              color: Theme.of(context).primaryColor,
              size: 35,
            ),
            Spacer(),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText2!.copyWith(
                    color: AppColors.MENU_GREY,
                  ),
            ),
            Spacer(),
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
