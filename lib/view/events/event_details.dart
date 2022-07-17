import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jiffy/jiffy.dart';
import 'package:linkfy_text/linkfy_text.dart';
import 'package:mao/controller/my_controller.dart';
import 'package:mao/models/event_model.dart';
import 'package:mao/utils/image_viewer.dart';
import 'package:mao/utils/index_utils.dart';
import 'package:mao/view/events/review_dialog_screen.dart';
import 'package:mao/view/signin/pre_signin_screen.dart';
import 'package:mao/widgets/carousel_sliver_appbar.dart';
import 'package:mao/widgets/custome_appbar_clipper.dart';
import 'package:mao/widgets/index_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';

class EventDetailsPage extends StatefulWidget {
  EventData eventDetails;
  EventDetailsPage({Key? key, required this.eventDetails}) : super(key: key);

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final _userdata = GetStorage().read('currenuserdata');
  MyController _myController = Get.put(MyController());
  List<String> imagelist = [
    'https://photos.bandsintown.com/thumb/11303397.jpeg',
    'https://photos.bandsintown.com/thumb/11303397.jpeg',
    'https://photos.bandsintown.com/thumb/11303397.jpeg'
  ];
  @override
  void initState() {
    //fetchimages();
    super.initState();
  }

  // void fetchimages() {
  //   imagelist = widget.eventDetails.images;
  //   //widget.eventDetails.images.map((e) => imagelist.add(e.url));
  //   setState(() {});
  // }

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

  @override
  Widget build(BuildContext context) {
    //print(imagelist);
    final datetime = StringBuffer();
    datetime
      ..write(Jiffy(widget.eventDetails.date).yMMMMd)
      ..write(' ')
      ..write(widget.eventDetails.time);
    return Scaffold(
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
                  iconWidget(context),
                  Spacer(
                    flex: 7,
                  ),
                  Text(
                    AppStrings.EVENT_DETAILS,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Spacer(
                    flex: 11,
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // SizedBox(
          //   height: Platform.isIOS ? 14.4.h : 19.h,
          // ),
          Expanded(
            child: CustomScrollView(slivers: [
              SliverPersistentHeader(
                delegate: CarouselSliver(
                    expandedHeight: 20.h,
                    photosPath: widget.eventDetails.images.length > 0
                        ? widget.eventDetails.images
                        : imagelist),
                pinned: false,
              ),
              SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                      delegate: SliverChildListDelegate(
                    [
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                        padding: EdgeInsets.all(12.0),
                        width: 70.3.w,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12.0),
                                topRight: Radius.circular(12.0)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ]),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    listItem(
                                        iconPath: AppAssets.CALENDAR_BLUE,
                                        text: widget.eventDetails.title,
                                        //widget.event.eventName,
                                        iconColor: AppColors.CALENDAR_BLUE,
                                        context: context),
                                    listItem(
                                        iconPath: AppAssets.MARKER,
                                        text: widget.eventDetails.address,
                                        //widget.event.eventAddress,
                                        iconColor: AppColors.RED,
                                        context: context),
                                    listItem(
                                        iconPath: AppAssets.CALENDAR_YELLOW,
                                        text: datetime.toString(),
                                        // DateFormat.yMMMMd('en_US')
                                        //     .add_jm()
                                        //     .format(widget.event.eventDateTime),
                                        iconColor: AppColors.CALENDAR_YELLOW,
                                        context: context),
                                  ],
                                ),
                                //icon
                                // IconButton(
                                //   onPressed: () {
                                //     print('hihih');
                                //   },
                                //   icon: Container(
                                //     width: 10.9.w,
                                //     height: 10.9.w,
                                //     decoration: BoxDecoration(
                                //         color: Theme.of(context).primaryColor,
                                //         shape: BoxShape.circle,
                                //         border: Border.all(
                                //           color: Theme.of(context).primaryColor,
                                //         )),
                                //     child: Icon(
                                //       FontAwesomeIcons.solidHeart,
                                //       color: Colors.white,
                                //       size: 4.w,
                                //     ),
                                //   ),
                                // ),
                                //: SizedBox.shrink(),
                              ],
                            ),
                            SizedBox(
                              height: 4.w,
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "Event Itinerary",
                                style: TextStyle(
                                    color: AppColors.RED,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            SizedBox(
                              height: 4.w,
                            ),
                            ListView.separated(
                              itemBuilder: (context, index) {
                                return ItineraryTile(
                                    true,
                                    //// _currentUser?.userType == UserType.user,
                                    false,
                                    index,
                                    widget.eventDetails);
                              },
                              itemCount: widget.eventDetails.sub.length,
                              //widget.event.itineraryListMap.length,
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Divider(color: Colors.grey[400]),
                                );
                              },
                              physics: NeverScrollableScrollPhysics(),
                            ),
                            SizedBox(
                              height: 4.w,
                            ),
                            Divider(color: Colors.grey[400]),
                            Container(
                              width: double.infinity,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: LinkifyText(
                                  widget.eventDetails.description,
                                  //widget.event.eventDescription,
                                  linkStyle: TextStyle(color: Colors.blue),
                                  linkTypes: [LinkType.url],
                                  onTap: (link) async {
                                    if (await canLaunch(link.value!)) {
                                      launch(link.value!);
                                    }
                                  },
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(
                                        color: AppColors.TEXT_GREY,
                                        height: 1.5,
                                      ),
                                ),
                              ),
                            ),
                            widget.eventDetails.comments.length > 0
                                ? Column(
                                    children: [
                                      ratingAndReviewHeader(),
                                      ...List.generate(
                                          widget.eventDetails.comments.length,
                                          (index) => ratingBox(widget
                                              .eventDetails
                                              .comments[index])), //ratingBox(),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      ratingAndReviewHeader(),
                                      //TODO
                                      Center(
                                        child: Text('No Result'),
                                      )
                                    ],
                                  ),
                            SizedBox(
                              height: 22.h,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ))),
            ]),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: false // state.isLoading
            ? null
            : () {
                if (_userdata != null) {
                  AppNavigation.showDialogGeneral(
                      context,
                      ReivewDialog(
                        event: widget.eventDetails,
                      ),
                      // BlocProvider<AddReviewCubit>.value(
                      //     value: context.read<AddReviewCubit>(),
                      //     child: ReivewDialog(
                      //       event: widget.event,
                      //     )),
                      true);
                  //AppNavigation.navigateTo(context, NotificationsScreen());
                } else {
                  _showMyDialog();
                }
                //_showMyDialog();

                // AppNavigation.showDialogGeneral(
                //     context,
                //     BlocProvider<AddReviewCubit>.value(
                //         value: context.read<AddReviewCubit>(),
                //         child: ReivewDialog(
                //           event: widget.event,
                //         )),
                //     true);
              },
        style: ElevatedButton.styleFrom(
            fixedSize: Size(76.5.w, 57),
            primary: Theme.of(context).primaryColor,
            shape: StadiumBorder()),
        child: Text(
          AppStrings.POST_REVIEW,
          style: Theme.of(context).textTheme.button,
        ),
      ),
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
        //mainAxisAlignment: MainAxisAlignment.start,
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
            width: 59.4.w,
            child: SelectableText(
              text,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          )
        ],
      ),
    );
  }

//Rating box
  Widget ratingBox(Comments? comments) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              foregroundImage: NetworkImage(
                comments!.userImage,
                // review.author.photoURL,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comments.userName,
                  // review.author.dispalyName,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                // Text(
                //   comments..difference(DateTime.now()).inDays <= 1
                //       ? AppStrings.TODAY
                //       : DateFormat.yMMMMd('en_US')
                //           .add_jm()
                //           .format(review.reviewDate),
                //   style: Theme.of(context).textTheme.subtitle2,
                // ),
              ],
            ),
            Spacer(),
            Row(
              children: [
                ImageIcon(
                  AssetImage(AppAssets.STAR_ICON),
                  color: AppColors.STAR_COLOR,
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  '(${comments.rating.round()}/5)',
                  style: Theme.of(context).textTheme.headline1,
                )
              ],
            )
          ],
        ),
        Container(
          width: double.infinity,
          child: Text(
            comments.comment,
            //review.writtenReview,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: AppColors.TEXT_GREY,
                  height: 1.5,
                ),
          ),
        ),
        Visibility(
          visible: comments.images.isNotEmpty, //review.photos.isNotEmpty,
          child: SizedBox(
            height: 60,
            child: Row(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SliderShowFullmages(
                                listImagesModel: [], //comments.images[0].url,
                                current: index)));
                      },
                      child: Container(
                        width: 45,
                        height: 60,
                        foregroundDecoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.RED,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(comments.images[index]),
                          ),
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) => SizedBox(
                      height: 8.0,
                    ),
                    itemCount: comments.images.length,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  //Reating and Review Header
  Column ratingAndReviewHeader()
  //BuildContext context, bool showRightIcons, Set<UserModel> ratingUsers)
  {
    return Column(
      children: [
        Divider(
          color: AppColors.DIVIDER_COLOR,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.RATING_AND_REVIEW,
              style: Theme.of(context).textTheme.headline2,
            ),
            Visibility(
              visible: true, //ratingUsers.length > 3,
              child: Row(
                children: [
                  // reviewUsersAvatarSmall()
                  RowSuper(
                    innerDistance: -5.0,
                    children: (2 > 3)
                        //(ratingUsers.length > 3)
                        ? [
                            reviewUsersAvatarSmall(),
                            reviewUsersAvatarSmall(),
                            reviewUsersAvatarSmall(),
                            // reviewUsersAvatarSmall(
                            //     ratingUsers.toList()[1].photoURL
                            //     ),
                            // reviewUsersAvatarSmall(
                            //     ratingUsers.toList()[2].photoURL
                            //     ),
                            // reviewUsersAvatarSmall(
                            //     ratingUsers.toList()[3].photoURL
                            //     ),
                          ]
                        : [],
                  ),
                  Visibility(
                    visible: true, //ratingUsers.length > 3,
                    child: Text(
                      ' ${3} and ' + AppStrings.REVIEW_USERS,
                      //' ${ratingUsers.length} and ' + AppStrings.REVIEW_USERS,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Divider(
          color: AppColors.DIVIDER_COLOR,
        ),
      ],
    );
  }

  Widget reviewUsersAvatarSmall({String? avatarPicture}) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          width: 2,
          color: Colors.white,
        ),
        image: DecorationImage(
            image: AssetImage(
              AppAssets.USER_IMAGE,
            ),
            fit: BoxFit.cover),
      ),
    );
  }
}

class ItineraryTile extends StatefulWidget {
  ItineraryTile(
    this.notification,
    this.notificationEnabled,
    this.index,
    this.event,
  );
  // ItineraryTile(
  //     this.notification, this.notificationEnabled, this.index, this.event);
  bool notification;
  bool notificationEnabled;
  int index;
  EventData event;
  //Sub eventsub;

  @override
  _ItineraryTileState createState() => _ItineraryTileState();
}

class _ItineraryTileState extends State<ItineraryTile> {
  Random random = new Random();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> scheduleNotification() async {
    // print("scheduling time");
    // print(DateTime.now());
    print("date time--------");
    print(widget.event.sub[widget.index].dateTime);

    //2022-04-20
    //April 21, 2022 2:03 PM
    DateTime a = Jiffy(
            widget.event.sub[widget.index].dateTime, "MMMM dd, yyyy h:mm:ss a")
        .dateTime;

    // DateTime a =
    //     Jiffy("April 26, 2022 03:57:00 pm", "MMMM dd, yyyy h:mm:ss a").dateTime;
    print("initial timme*********1***********");

    print(a.toString());
    ////2022-05-12 09:44:00.000
    DateTime b = a.subtract(Duration(minutes: 30));
    //2022-05-12 09:14:00.000
    print("final timme***********2*********");
    print(b);
    var scheduledNotificationDateTime =
        // tz.TZDateTime.local(a.year, a.month, a.day, a.hour, a.minute, a.second);
        tz.TZDateTime.now(tz.local).add(b.difference(DateTime.now()));
    print("difference timme***********3*********");
    print(b.difference(DateTime.now()));
    //379:22:12.938996
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '${widget.event.id}',
      '${widget.event.title}',
      channelDescription: '${widget.event.description}',
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    //print("local notification testing***1");
    // await flutterLocalNotificationsPlugin.show(0, "title", "body",
    //     NotificationDetails(android: androidPlatformChannelSpecifics),
    //     payload: "data");
    // print("local notification testing***2");
    int notId = random.nextInt(10000);
    print("scheduling time 5");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("notId-${widget.event.id}-it${widget.index}", notId);
    print(widget.event.id);
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          notId,
          'Reminder for ${widget.event.sub[widget.index].title}',
          '${widget.event.sub[widget.index].date}',
          scheduledNotificationDateTime,
          platformChannelSpecifics,
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
      widget.notificationEnabled = true;

      prefs.setBool("${widget.event.id}-it${widget.index}", true);
    } catch (e) {
      print("error*****");
      CustomSnacksBar.showSnackBar(context, e.toString().split(":")[1]);
    }
    setState(() {});
  }

  Future<void> unscheduleNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? notId = prefs.getInt("notId-${widget.event.id}-it${widget.index}");
    await flutterLocalNotificationsPlugin.cancel(notId!);
    setState(() {
      widget.notificationEnabled = false;
    });
    prefs.setBool("${widget.event.id}-it${widget.index}", false);
  }

  void checkLocal() async {
    print("Widget notification testing 1");
    print(widget.notificationEnabled);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.notificationEnabled =
        prefs.getBool("${widget.event.id}-it${widget.index}") ?? false;

    print("${widget.event.id}-it${widget.index}");

    setState(() {});
  }

  @override
  void initState() {
    checkLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Image.asset(
                    AppAssets.CALENDAR_YELLOW,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    widget.event.sub[widget.index].title,
                    // widget.event.itineraryListMap[widget.index]
                    //     ["itineraryDescription"],
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Image.asset(
                    AppAssets.CALENDAR_YELLOW,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    widget.event.sub[widget.index].dateTime,
                    //"world",
                    // widget.event.itineraryListMap[widget.index]
                    //     ["itineraryDate"],
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              )
            ],
          ),
        ),
        Visibility(
            visible: widget.notification,
            child: InkWell(
              onTap: () async {
                if (widget.notificationEnabled != true) {
                  scheduleNotification();
                } else {
                  unscheduleNotification();
                }
              },
              child: Icon(Icons.notifications,
                  color: widget.notificationEnabled == true
                      ? AppColors.RED
                      : Colors.grey
                  //Colors.grey
                  ),
            )),
      ],
    );
  }
}
