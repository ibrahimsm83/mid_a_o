import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mao/controller/my_controller.dart';
import 'package:mao/models/event_model.dart';
import 'package:mao/services/network.dart';
import 'package:mao/utils/index_utils.dart';
import 'package:mao/view/chat/chat_screen.dart';
import 'package:mao/view/events/event_details.dart';
import 'package:mao/view/events/notification/notification_screen.dart';
import 'package:mao/view/menue/menue_screen.dart';
import 'package:mao/view/signin/pre_signin_screen.dart';
import 'package:mao/widgets/custome_appbar_clipper.dart';
import 'package:sizer/sizer.dart';
import 'package:slide_countdown/slide_countdown.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final _userdata = GetStorage().read('currenuserdata');
  MyController _myController = Get.put(MyController());
  @override
  void initState() {
    fetchEventNotificnList();
    print("event init statw");

    super.initState();
  }

  void fetchEventNotificnList() {
    if (_userdata != null) {
      print("Notification Api call because user found");
      _myController.fetchEventNotification();
    } else {
      print("Notification Api not call because user not login");
    }
    // var edata = await NetworkApi.eventList();
    // print(edata!.data.first);
    //print("hello***");
  }

  @override
  Widget build(BuildContext context) {
    // _myController.fetcheventListdata();
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight * 1.7),
        child: ClipPath(
          clipper: AppBarClipper(),
          child: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.only(bottom: 20),
            alignment: Alignment.center,
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        AppNavigation.navigateTo(context, MeneScreen());
                      },
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                      )),
                  Spacer(
                    flex: 7,
                  ),
                  Text(
                    AppStrings.EVENTS,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Spacer(
                    flex: 7,
                  ),

                  // Visibility(
                  //   visible: _currentUser.userType == UserType.marketer,
                  //   // replacement: SizedBox(
                  //   //   width: 34,
                  //   // ),
                  //   child: IconButton(
                  //       onPressed: () {
                  //         // AppNavigation.navigateTo(
                  //         //   context,
                  //         //   MultiBlocProvider(
                  //         //     providers: [
                  //         //       BlocProvider<AddEventCubit>(
                  //         //         create: (context) => AddEventCubit(),
                  //         //       ),
                  //         //     ],
                  //         //     child: AddEventScreen(),
                  //         //   ),
                  //         // );

                  //         // BlocProvider<AddEventCubit>(

                  //         //   create: (context) =>

                  //         //   AddEventCubit(),
                  //         //   child:

                  //         // ));

                  //         // child:                                 AddEventScreen(),
                  //       },
                  //       icon: Icon(
                  //         Icons.add,
                  //         color: Colors.white,
                  //         size: 24,
                  //       )),
                  // ),
                  // if(_currentUser.userType == UserType.user)
                  IconButton(
                      onPressed: () {
                        if (_userdata != null) {
                          AppNavigation.navigateTo(
                              context, NotificationsScreen());
                        } else {
                          _showMyDialog();
                        }
                        // _showMyDialog
                      },
                      icon: Icon(
                        Icons.notifications,
                        color: Colors.white,
                        size: 24,
                      ))
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      body: Column(children: [
        SizedBox(
          height: Platform.isIOS
              ? (MediaQuery.of(context).size.height * 0.15 -
                  MediaQuery.of(context).size.height * 0.13 * 0.3)
              : 15.h,
        ),
        Expanded(
          child: Obx(
            (() {
              if (_myController.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(color: AppColors.RED));
              } else {
                return _myController.eventList.isEmpty
                    ? const Center(
                        child: Text(
                        "Record Not Found",
                        style: TextStyle(color: AppColors.RED),
                      ))
                    : Container(
                        alignment: Alignment.topCenter,
                        color: AppColors.BACKGROUND_BLUE_HAZE,
                        child: ListView.separated(
                          padding: EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 32.0, bottom: 18.h),
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 8);
                          },
                          itemCount: _myController.eventList.length,
                          itemBuilder: (context, index) => eventCardWidget(
                              context,
                              eventdata: _myController.eventList[index]),
                        ),
                      );
              } //else end
            }),
          ),
        ),
      ]),
    );
  }

  Widget eventCardWidget(
    BuildContext context, {
    required EventData eventdata,
  }) {
//   2022-04-21 14:05:00.000
// I/flutter (27857): *********event date time**********
// I/flutter (27857): 2022-03-18 18:00:00.000
// I/flutter (27857): *********event date time**********
// I/flutter (27857): 2022-02-26 19:00:00.000
    // print("*********event date time**********");
    // print("2022-02-26 19:00:00.000");
    // print("*********event Print date **********");
    //const defaultDuration = Duration(days: 2, hours: 2, minutes: 30);
    // DateTime counterdate =
    //     DateTime.parse(eventdata.date + ' ' + eventdata.time);
    // print("date event");
    // print(eventdata.date);
    DateTime counterdate =
        DateTime.parse(eventdata.date + ' ' + eventdata.time);
    // print("********* counterdate date Print date **********");
    // print(counterdate);
    var formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(counterdate);
    // print("********* Formate **********");
    // //print(DateTime.now());
    // print(formattedDate);
    // print("********difference*********");
    // print(DateTime.parse(formattedDate).difference(DateTime.now()));

    final datetime = StringBuffer();
    datetime
      ..write(Jiffy(eventdata.date).yMMMMd)
      ..write(' ')
      ..write(eventdata.time);
    // BuildContext context, Event event, UserModel currentUser) {
    return InkWell(
      onTap: () {
        AppNavigation.navigateTo(
            context, EventDetailsPage(eventDetails: eventdata));
      },
      child: Container(
        width: 89.3.w,
        padding: EdgeInsets.all(10.0),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: eventdata.image != null
                  ? CachedNetworkImage(
                      imageUrl: eventdata.image!,
                      width: double.infinity,
                      height: 22.h,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    )
                  : SizedBox(
                      height: 22.h,
                      width: double.infinity,
                      child: Center(child: Text("Image Not Found")),
                    ),
            ),
            SizedBox(height: 4.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    listItem(
                        iconPath: AppAssets.CALENDAR_BLUE,
                        text: eventdata.title,
                        // text: event.eventName,
                        iconColor: AppColors.CALENDAR_BLUE,
                        context: context),
                    listItem(
                        iconPath: AppAssets.MARKER,
                        text: eventdata.address,
                        //"event Address",
                        //text: event.eventAddress,
                        iconColor: AppColors.RED,
                        context: context),
                    listItem(
                        iconPath: AppAssets.CALENDAR_YELLOW,
                        text: datetime.toString(),
                        //Jiffy(eventdata.date).yMMMMd + " " + eventdata.time,
                        //eventdata.date.split(' ')[0],
                        // DateFormat.yMMMMd('en_US')
                        //     .add_jm().format(eventdata.date),
                        // .format(DateTime.now()),
                        //.format(event.eventDateTime),
                        iconColor: AppColors.CALENDAR_YELLOW,
                        context: context),
                  ],
                ),
                // currentUser.userType == UserType.user
                //     ?
                IconButton(
                  onPressed: () {
                    // print('hihih');
                    // if (){
                    // // (currentUser.likedEventsId
                    // //     .contains(event.eventID))

                    //   print('like event');
                    //   // context
                    //   //     .read<AuthenticationRepository>()
                    //   //     .removeLikedEvent(event.eventID!);
                    //  else {
                    //   print('unlike event');
                    //   // context
                    //   //     .read<AuthenticationRepository>()
                    //   //     .addLikedEvent(event.eventID!);
                    // }
                    // setState(() {});
                  },
                  icon: Container(
                    width: 10.9.w,
                    height: 10.9.w,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        // color: context
                        //         .read<AuthenticationRepository>()
                        //         .currentUsermodel!
                        //         .likedEventsId
                        //         .contains(event.eventID)
                        //     ? Colors.white
                        //     : Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          // color: context
                          //         .read<AuthenticationRepository>()
                          //         .currentUsermodel!
                          //         .likedEventsId
                          //         .contains(event.eventID)
                          //     ? Theme.of(context).primaryColor
                          //     : Colors.white,
                        )),
                    child: Icon(
                      FontAwesomeIcons.solidHeart,
                      color: Colors.white,
                      // color: context
                      //         .read<AuthenticationRepository>()
                      //         .currentUsermodel!
                      //         .likedEventsId
                      //         .contains(event.eventID)
                      //     ? Theme.of(context).primaryColor
                      //     : Colors.white,
                      size: 4.w,
                    ),
                  ),
                )
                //: Container(),
              ],
            ),
            Visibility(
              visible: !DateTime.parse(formattedDate)
                  .difference(DateTime.now())
                  .isNegative,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SlideCountdown(
                  slideDirection: SlideDirection.up,
                  fade: true,
                  duration:
                      DateTime.parse(formattedDate).difference(DateTime.now()),
                  icon: Icon(Icons.alarm_rounded, color: Colors.white),
                  durationTitle: DurationTitle.en(),
                  decoration: BoxDecoration(
                    color: AppColors.RED,
                    borderRadius: const BorderRadius.all(Radius.circular(3)),
                  ),
                  // slideDirection: SlideDirection.up,
                  separatorType: SeparatorType.title,
                  onDone: () {
                    print('Countdown done!');
                  },
                ),
              ),
            ),
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

  Widget listItem(
      {required String iconPath,
      required String text,
      required Color iconColor,
      required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ImageIcon(
            AssetImage(
              iconPath,
            ),
            color: iconColor,
            size: 16,
          ),
          SizedBox(
            width: 16,
          ),
          Container(
            width: 61.w,
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          )
        ],
      ),
    );
  }
}
