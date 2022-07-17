import 'dart:developer';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mao/controller/my_controller.dart';
import 'package:mao/utils/index_utils.dart';
import 'package:mao/utils/navigation.dart';
import 'package:mao/view/chat/get_message_model.dart';
import 'package:mao/view/chat/message_model.dart';
import 'package:mao/view/chat/send_message_model.dart';
import 'package:mao/widgets/index_widgets.dart';
import 'package:mao/widgets/platform_dialog.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController textEditingController = TextEditingController();
  //final ScrollController listScrollController = ScrollController();
  final _controller = ScrollController();
  late IO.Socket socket;
  MyController chatCtrl = Get.put(MyController());
  String? imageaddress =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQuXLp9Z1BZnTa4tGiOcbGWTISjMlpOcGe0w&usqp=CAU';

  dynamic listMessage = [];
  dynamic blocklist = [];
  //bool isLoading = false;
  void showLongToast(String? message) {
    Fluttertoast.showToast(
      msg: message ?? "",
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 18.0,
    );
  }

  @override
  void initState() {
    //btokenprint();
    socketmethodcall();
    super.initState();
  }

  void socketmethodcall() {
    initSocket();
    connectSocket();
    _emitSocket();
  }
  // void btokenprint() async {
  //   SharedPreferences _prefs = await SharedPreferences.getInstance();
  //   print("btoken----------------");
  //   print(_prefs.getString(PreferencesKeys.token));
  // }
  // void onSendMessage(
  //   String content,
  // ) {
  //   if (content.trim().isNotEmpty) {
  //     textEditingController.clear();
  //     //sendMessage(content, currentUser);
  //     listScrollController.animateTo(0,
  //         duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: 'Nothing to send', backgroundColor: AppColors.MENU_GREY);
  //   }
  // }

  // void sendMessage(String content, ChatModelData currentUser) {

  //   print(DateTime.now().toUtc().toIso8601String());
  //   // DateTime dateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(DateTime.now().toIso8601String(), true);
  //   // print(dateTime.toIso8601String());
  //   // MessageModel messageChat = MessageModel(
  //   //   uid: currentUser.uid,
  //   //   createdAt: DateTime.now().toUtc().toIso8601String(),
  //   //   messageText: content,
  //   //   displayName: currentUser.dispalyName,
  //   //   photoURL: currentUser.photoURL,
  //   // );
  // }
//chat start

  void initSocket() {
    socket = IO.io(
        //"https://server.appsstaging.com:3094/"
        Constants.WEB_SOCKET,
        <String, dynamic>{
          'transports': ['websocket'],
          'autoConnect': false,
        });
  }

  void connectSocket() {
    // print("connect*******user id*******");
    // print(chatCtrl.user.data!.id);
    //init socket here

    socket.connect();
    socket.onConnect((_) {
      print("connect*********2*****");
    });
    //insert upcoming messages into local messages list
    socket.on("get_messages", (message) {
      print("messages***********5****************");
      print(message);
      // if (message["data"].length == 1) {
      //   chatCtrl.chatMessages.insert(0, message["data"][0]);
      // } else {
      //   chatCtrl.chatMessages.addAll(message["data"]);
      //   chatCtrl.chatMessages.value =
      chatCtrl.chatMessages.value.reversed.toList();
      // }

      // chatCtrl.chatMessages.addAll(message["data"]);
      listMessage.addAll(message["data"]);
      listMessage = listMessage.reversed.toList();
      setState(() {});
      // chatCtrl.chatMessages.value =
      //     chatCtrl.chatMessages.value.reversed.toList();
      //animate scroll while new massge come
      // setState(() {
      //   _controller.animateTo(
      //     _controller.position.minScrollExtent,
      //     duration: Duration(milliseconds: 500),
      //     curve: Curves.easeIn,
      //   );
      // });
    });

    socket.on("sent_message", (message) {
      print(message);
      // chatCtrl.chatMessages.add(message);

      // listMessage.isNotEmpty
      //     ? listMessage.insert(0, message["data"][0])
      //     : listMessage.add(message["data"][0]);
      if (listMessage.isNotEmpty) {
        listMessage.insert(0, message["data"][0]);
        print(message['data']);

        blocklist = message['block_list'];
        print("55554444444444444--------------------");
        print(blocklist);
      } else {
        listMessage.add(message["data"][0]);
      }
      setState(() {});
    });
//block user
    socket.on("block_user", (message) {
      print("block user --------------------ibrahim");
      print(message);
      // _emitSocket();
      //socketmethodcall();
      setState(() {});
    });
    socket.onConnectTimeout((data) {
      print(data);
    });
    socket.onError((data) {
      print(data);
    });
  }

  void _emitSocket() {
    //emit method call here to get message thread.
    socket.emit("get_messages", {
      /*"chat_id": widget.chatId, */
      "sender_id": chatCtrl.user.data!.id
    });
    print("*************3**************");
  }

  //emit block socket
  void _emitSocketblockuser(int? senderid) {
    //emit method call here to get message thread.
    socket.emit("block_user", {
      "reporter_id": chatCtrl.user.data!.id,
      "block_id": senderid,
      "message_id": 0,
      "type": "user"
    });
  }

  void _sendMessage() {
    String messageText = textEditingController.text.trim();
    //textEditingController.text = '';
    if (messageText.isNotEmpty) {
      var messagePost = {
        //"chat_id": widget.chatId,
        "sender_id": chatCtrl.user.data!.id,
        "message": messageText,
      };
      socket.emit("send_message", messagePost);
      textEditingController.clear();
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

//socket end
  CustomPopupMenuController _popcontroller = CustomPopupMenuController();
  // MyController _myController = Get.put(MyController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.12),
        child: Container(
          padding: EdgeInsets.only(bottom: 20),
          constraints: BoxConstraints.expand(),
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            child: GestureDetector(
              onTap: () => AppNavigation.navigatorPop(context),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        AppNavigation.navigatorPop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  Spacer(
                    flex: 5,
                  ),
                  Text(
                    AppStrings.CHAT.toUpperCase(),
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Spacer(
                    flex: 7,
                  ),
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
      body: Column(
        children: [
          Expanded(
              child: listMessage.isEmpty
                  ? Center(
                      child: CircularProgressIndicator(color: AppColors.RED))
                  :

                  //print(chatCtrl.chatMessages[0]);
                  // chatCtrl.eventList.isEmpty
                  //     ? const Center(
                  //         child: Text(
                  //         "Record Not Found",
                  //         style: TextStyle(color: AppColors.RED),
                  //       ))
                  //chatCtrl.chatMessages.length > 0
                  //:
                  ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.all(10),
                      itemBuilder: (context, index) => buildItem(
                        index,
                        GetMessageModelData.fromJson(listMessage[index]),
                      ),
                      itemCount: listMessage.length,
                      reverse: true,
                      //controller: _controller,
                    )
              // : Center(
              //     child: Text("No message here yet..."),
              //   );

              // return
              ),
          Container(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextField(
                        onSubmitted: (value) {
                          final filter = ProfanityFilter();
                          if (filter.hasProfanity(value) == true) {
                            log("contains profanity");
                            PlatformAlertDialog(
                              title: 'Alert',
                              content:
                                  "A warning has been added to your account as your submission has triggered the profanity filter. Such language may result in account suspension. If you think it's a mistake please contact support.",
                              defaultActionText: 'Ok',
                            ).show(context);
                            textEditingController.clear();
                          } else {
                            _sendMessage();
                            // onSendMessage(
                            //     textEditingController.text, currentUser!);
                          }
                          _sendMessage();
                          // onSendMessage(
                          //   textEditingController.text,
                          // );
                        },
                        style: TextStyle(color: AppColors.RED, fontSize: 15),
                        controller: textEditingController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: AppColors.MENU_GREY),
                        ),
                      ),
                    ),
                  ),
                ),
                // Button send message
                Material(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        //
                        final filter = ProfanityFilter();
                        if (filter.hasProfanity(textEditingController.text) ==
                            true) {
                          log("contains profanity");
                          PlatformAlertDialog(
                            title: 'Alert',
                            content:
                                "A warning has been added to your account as your submission has triggered the profanity filter. Such language may result in account suspension. If you think it's a mistake please contact support.",
                            defaultActionText: 'Ok',
                          ).show(context);
                          textEditingController.clear();
                        } else {
                          _sendMessage();
                        }
                      },
                      color: AppColors.RED,
                    ),
                  ),
                  color: Colors.white,
                ),
              ],
            ),
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: AppColors.MENU_GREY, width: 0.5)),
                color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget buildItem(int index, GetMessageModelData? getMessageModel) {
    if (getMessageModel!.senderId == chatCtrl.user.data!.id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomPopupMenu(
                arrowColor: AppColors.STAR_COLOR,
                menuBuilder: () {
                  // if (currentUser.userType == UserType.marketer)
                  //   return Container(
                  //     padding: EdgeInsets.symmetric(horizontal: 15),
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(25),
                  //       color: AppColors.STAR_COLOR,
                  //     ),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         IconButton(
                  //           onPressed: () {
                  //             FirebaseFirestore.instance
                  //                 .collection("chatroom")
                  //                 .doc(getMessageModel.docId)
                  //                 .delete();
                  //           },
                  //           icon: Icon(
                  //             Icons.delete,
                  //             color: AppColors.BACKGROUND_BLUE_HAZE,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  return Container();
                },
                barrierColor: Colors.transparent,
                pressType: PressType.longPress,
                child: Container(
                  child: Text(
                    getMessageModel.message!,
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  width: 200,
                  decoration: BoxDecoration(
                      color: AppColors.MENU_GREY,
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              Container(
                child: Text(
                  //DateFormat('yyyy-MM-dd kk:mm').
                  DateFormat.yMMMMd('en_US').add_jm().format(
                      DateTime.parse(getMessageModel.createdAt!).toLocal()),
                  // DateFormat.yMMMMd('en_US').add_jm().
                  style: TextStyle(
                      color: AppColors.MENU_GREY,
                      fontSize: 12,
                      fontStyle: FontStyle.italic),
                ),
                margin: EdgeInsets.only(right: 0, bottom: 20, top: 8),
              )
            ],
          )
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // print(blocklist.contains(getMessageModel.senderId));
      // print("Receiver Message");
      // Left (peer message)
      return blocklist.contains(getMessageModel.senderId)
          ? SizedBox()
          : CustomPopupMenu(
              arrowColor: AppColors.STAR_COLOR,
              menuBuilder: () {
                print("long pressed");
                // if (currentUser.userType == UserType.marketer)
                //   return Container(
                //     padding: EdgeInsets.symmetric(horizontal: 15),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(25),
                //       color: AppColors.STAR_COLOR,
                //     ),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         IconButton(
                //           onPressed: () {
                //             FirebaseFirestore.instance
                //                 .collection("chatroom")
                //                 .doc(getMessageModel.docId)
                //                 .delete();
                //           },
                //           icon: Icon(
                //             Icons.delete,
                //             color: AppColors.BACKGROUND_BLUE_HAZE,
                //           ),
                //         ),
                //       ],
                //     ),
                //   );
                return Container(
                    // child: Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Text("block"),
                    // ),
                    );
                //---ibr
                // if (currentUser.userType == UserType.user)
                //   return Container(
                //     padding: EdgeInsets.symmetric(horizontal: 15),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(25),
                //       color: AppColors.STAR_COLOR,
                //     ),
                //     child: Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         getMessageModel.report ?? false
                //             ? SizedBox()
                //             : Row(
                //                 children: [
                //                   IconButton(
                //                     onPressed: () {
                //                       FirebaseFirestore.instance
                //                           .collection("chatroom")
                //                           .doc(getMessageModel.docId)
                //                           .update({
                //                         "report": true,
                //                         "reporterId": currentUser.uid,
                //                         "reporterUserName": currentUser.dispalyName
                //                       });
                //                     },
                //                     icon: Icon(
                //                       Icons.report,
                //                       color: AppColors.BACKGROUND_BLUE_HAZE,
                //                     ),
                //                   ),
                //                   SizedBox(width: 5.0),
                //                   InkWell(
                //                     onTap: () async {
                //                       print("block icon tap");
                //                       FirebaseFirestore.instance
                //                           .collection("users")
                //                           .doc(getMessageModel.uid)
                //                           .update({"isblocked": true});
                //                       //block and report
                //                       FirebaseFirestore.instance
                //                           .collection("chatroom")
                //                           .doc(getMessageModel.docId)
                //                           .update({
                //                         "report": true,
                //                         "reporterId": currentUser.uid,
                //                         "reporterUserName": currentUser.dispalyName
                //                       });
                //                       showLongToast("User Blocked Successfully");
                //                     },
                //                     child: Icon(Icons.block, color: Colors.white),
                //                   ),
                //                 ],
                //               ),
                //       ],
                //     ),
                //   );
                // return Container();
                //---end ibr
              },
              barrierColor: Colors.transparent,
              pressType: PressType.longPress,
              verticalMargin: -10,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                print("taped");
                                // Navigator.of(context).push(MaterialPageRoute(
                                //     builder: (context) => SliderShowFullmages(
                                //         listImagesModel: [getMessageModel.photoURL!],
                                //         current: index)));
                              },
                              child: Material(
                                child: getMessageModel.image != null
                                    ? Image.network(
                                        getMessageModel.image!,
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent? loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.RED,
                                              value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null &&
                                                      loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder:
                                            (context, object, stackTrace) {
                                          return Icon(
                                            Icons.account_circle,
                                            size: 35,
                                            color: AppColors.MENU_GREY,
                                          );
                                        },
                                        width: 35,
                                        height: 35,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                            ),
                            Container(
                              child: Text(
                                getMessageModel.message ?? "",
                                style: TextStyle(color: Colors.white),
                              ),
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              width: 200,
                              decoration: BoxDecoration(
                                  color: AppColors.RED,
                                  borderRadius: BorderRadius.circular(8)),
                              margin: EdgeInsets.only(left: 10),
                            ),
                          ],
                        ),
                        CustomPopupMenu(
                          // controller: _popcontroller,
                          arrowColor: AppColors.STAR_COLOR,
                          menuBuilder: () {
                            return Container(
                              width: 200,
                              decoration: BoxDecoration(
                                  color: AppColors.STAR_COLOR,
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("Do you want to Block user"),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              _emitSocketblockuser(
                                                  getMessageModel.senderId);
                                              CustomSnacksBar.showSnackBar(
                                                  context,
                                                  "User Blocked Successfully");
                                            },
                                            child: Text("Yes",
                                                style:
                                                    TextStyle(fontSize: 14.0))),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          barrierColor: Colors.transparent,
                          pressType: PressType.singleClick,
                          child: Container(
                            child: Icon(Icons.more_vert,
                                color: AppColors.MENU_GREY),
                          ),
                        ),
                        //  CustomPopupMenu(
                        //    menuBuilder: () {

                        //    },
                        //    child: Container(
                        //       child: Icon(Icons.more_vert, color: AppColors.MENU_GREY),
                        //     ),
                        //  ),

                        /*
                    //report icon
                    // currentUser.userType == UserType.marketer
                    //     ? InkWell(
                    //         onTap: () async {
                    //           checkUsersBlockorNot(getMessageModel.uid.toString())
                    //               .then((bool isblock) {
                    //             if (isblock) {
                    //               _showMyDialog(
                    //                   text: "UnBlock",
                    //                   reporterName:
                    //                       getMessageModel.reporterUserName,
                    //                   onTap: () {
                    //                     FirebaseFirestore.instance
                    //                         .collection("users")
                    //                         .doc(getMessageModel.uid)
                    //                         .update({"isblocked": false});
                    //                     Navigator.pop(context);
                    //                     showLongToast(
                    //                         "User UnBlocked Successfully");
                    //                   });
                    //             } else {
                    //               _showMyDialog(
                    //                   reporterName:
                    //                       getMessageModel.reporterUserName,
                    //                   text: "Block",
                    //                   onTap: () {
                    //                     FirebaseFirestore.instance
                    //                         .collection("users")
                    //                         .doc(getMessageModel.uid)
                    //                         .update({"isblocked": true});
                    //                     Navigator.pop(context);
                    //                     showLongToast(
                    //                         "User Blocked Successfully");
                    //                   });
                    //             }
                    //           });
                    //         },
                            //child: 
                            Icon(
                              getMessageModel.report ?? false ? Icons.report : null,
                              size: 35,
                              color: AppColors.MENU_GREY,
                            ),
                          )
                        : Icon(
                            getMessageModel.report ?? false ? Icons.report : null,
                            size: 35,
                            color: AppColors.MENU_GREY,
                          ),
                          */
                      ],
                    ),
                    Container(
                      child: Text(
                        //  DateTime.now().toString(),
                        DateFormat.yMMMMd('en_US').add_jm().format(
                            DateTime.parse(getMessageModel.createdAt!)
                                .toLocal()),
                        // getMessageModel.!,
                        // DateFormat.yMMMMd('en_US')
                        //     .add_jm()
                        //     .format(datetime.toLocal()),
                        style: TextStyle(
                            color: AppColors.MENU_GREY,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                      margin: EdgeInsets.only(left: 50, top: 5, bottom: 5),
                    )
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                margin: EdgeInsets.only(bottom: 10),
              ),
            );
    }
  }
}
