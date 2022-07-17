import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_viewer/image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:mao/controller/my_controller.dart';
import 'package:mao/utils/image_viewer.dart';
import 'package:mao/utils/index_utils.dart';
import 'package:mao/view/events/notification/event_notification_model.dart';
import 'package:mao/widgets/custome_appbar_clipper.dart';
import 'package:sizer/sizer.dart';

class NotificationsScreen extends StatefulWidget {
  NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  MyController _myController = Get.put(MyController());
  @override
  void initState() {
    // TODO: implement initState

    _myController.fetchEventNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.BACKGROUND_BLUE_HAZE,
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
                        // _currentUser.userType == UserType.user
                        AppNavigation.navigatorPop(context);
                        // : AppNavigation.navigateTo(context, MeneScreen());
                      },
                      icon: Icon(
                        // _currentUser.userType == UserType.user
                        Icons.arrow_back,
                        // : Icons.menu,
                        color: Colors.white,
                      )),
                  Spacer(
                    flex: 7,
                  ),
                  Text(
                    AppStrings.NOTIFICATIONS_ALL_CAPS,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Spacer(
                    flex: 7,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          Expanded(
            child: Obx((() {
              if (_myController.eventLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(color: AppColors.RED));
              } else {
                return _myController.eventNotifList.isEmpty
                    ? const Center(
                        child: Text(
                        "Record Not Found",
                        style: TextStyle(color: AppColors.RED),
                      ))
                    : Container(
                        alignment: Alignment.topCenter,
                        color: AppColors.BACKGROUND_BLUE_HAZE,
                        child: ListView.separated(
                          padding: EdgeInsets.fromLTRB(
                              16, Platform.isIOS ? 16.h : 19.h, 16.0, 20.h),
                          itemBuilder: (context, index) {
                            print(_myController.eventNotifList[index]);
                            return reviewCardWidget(
                                context, _myController.eventNotifList[index]
                                // snapshot.data![index],
                                );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 8,
                          ),
                          itemCount: _myController.eventNotifList.length,
                        ),
                      );
              }
            })),
          )
        ],
      ),
    );
  }

  Container reviewCardWidget(
    BuildContext context,
    Data? notifidata,
  ) {
    return Container(
      width: 89.3.w,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                foregroundImage: NetworkImage(notifidata!.data!.image ??
                        "https://photos.bandsintown.com/thumb/11303397.jpeg"
                    //'', //notification.authorImageURL,
                    ),
                radius: (11.5.w / 2),
              ),
              SizedBox(
                width: 8,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notifidata.data!.title ?? "",
                    // notification.authorName,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  GestureDetector(
                    onTap: () {
                      // print(notification.addedDateTime);
                      // print(DateTime.now()
                      //     .difference(notification.addedDateTime)
                      //     .inDays);
                    },
                    child: Text(
                      notifidata.data!.eventDate ??
                          "" /*+ ' ' + notifidata.data!.time!*/,
                      //"date and time",
                      // DateTime.now()
                      //             .difference(notification.addedDateTime)
                      //             .inDays <=
                      //         1
                      //     ? AppStrings.TODAY
                      //     : DateFormat.yMMMMd('en_US')
                      //         .add_jm()
                      //         .format(notification.addedDateTime),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(
              //     builder: (context) => SliderShowFullmages(
              //           listImagesModel: [notification.notificationPhoto],
              //           current: 0,
              //         )));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                notifidata.data!.image ??
                    "https://photos.bandsintown.com/thumb/11303397.jpeg",
                //notifidata?.data?.image??[].first.url ?? "",
                //notification.notificationPhoto,
                width: 84.w,
                height: 22.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
              child: Text(
                notifidata.data!.description ?? "",
                //notification.eventDescription,
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: AppColors.TEXT_GREY,
                      height: 1.7,
                    ),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
