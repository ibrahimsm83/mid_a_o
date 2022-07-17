import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:mao/models/event_model.dart';
import 'package:mao/models/user_model.dart';
import 'package:mao/services/api.dart';
import 'package:mao/utils/index_utils.dart';
import 'package:mao/view/events/notification/event_notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkApi {
  //auth/logout
  static Future<UserModel?> Sociallogin(
      {required String access_token,
      required String provider,
      required String email,
      required String user_name,
      required String device_type,
      required String device_token}) async {
    try {
      var res = await Api.post(
        "/auth/social",
        body: {
          "email": email,
          "provider": provider,
          "user_name": user_name,
          "device_type": device_type,
          "device_token": device_token,
          "access_token": access_token,
        },
      );
      return UserModel.fromJson(res);
    } catch (error) {
      if (error is ApiErrorRepsonse) {
        // ScaffoldMessenger.of(MyApp.globalkey.currentState!.context)
        //     .showSnackBar(SnackBar(
        //   content: Text(error.message),
        // ));
      } else {
        // ignore: use_rethrow_when_possible
        throw error;
      }
    }
  }

  static Future Reviewpost(
      {required String eventid,
      required String rating,
      required String comment}) async {
    try {
      var res = await Api.postwithToken(
        "/events/review",
        body: {
          "rating": rating,
          "comment": comment,
          "event_id": eventid,
        },
      );
      if (res['status'] == 1) {
        print("Review added successfully");
        return res;
      } else {
        print("Review not added ");
        print(res);
      }
    } catch (error) {
      if (error is ApiErrorRepsonse) {
        // ScaffoldMessenger.of(MyApp.globalkey.currentState!.context)
        //     .showSnackBar(SnackBar(
        //   content: Text(error.message),
        // ));
      } else {
        // ignore: use_rethrow_when_possible
        throw error;
      }
    }
  }

//Logout api
  static Future Logout() async {
    try {
      var res = await Api.postwithToken(
        "/auth/logout",
        // body: {
        //   "rating": rating,
        //   "comment": comment,
        //   "event_id": eventid,
        // },
      );
      print(res);
      if (res['status'] == 1) {
        print("Logout successfully");
        return res;
      } else {
        print("error");
        print(res);
      }
    } catch (error) {
      if (error is ApiErrorRepsonse) {
        // ScaffoldMessenger.of(MyApp.globalkey.currentState!.context)
        //     .showSnackBar(SnackBar(
        //   content: Text(error.message),
        // ));
      } else {
        // ignore: use_rethrow_when_possible
        throw error;
      }
    }
  }

//get data
  var dio = Dio();
  static Future<EventModel?> eventList() async {
    final url = "${Constants.baseUrl}/events/index";
    print(url);
    try {
      final response = await Dio().get(url);

      if (response.statusCode == 200) {
        return EventModel.fromJson(response.data);
      } else {
        // print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode.toString();
      }
    } catch (error) {
      print(error);
    }
  }

  //ProfileImage
  //Complete Profile _Update Profile
  static Future<UserModel?> CompleteProfile({
    // required String name,
    //required String photoToUpload,
    required String imagepath,
  }) async {
    //final uploadedPath = await uploadImageToStorage(File(_tempPhotoToUpload));
    try {
      // Map<String, String> map = {"user_name": name};
      String fileName = imagepath.split('/').last;
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          imagepath, filename: fileName,
          //contentType:  MediaType("image", "jpeg")//important), may be error 400
        ),
        //"user_name": name,
      });
      var res = await Api.post(
        "/auth/update",
        body: formData,
        //  {
        //   "user_name": name,
        //   "image": photoToUpload,
        // },
      );
      print("Update image response*******************************");
      print(res);
      return UserModel.fromJson(res);

      //return userdata;
    } catch (error) {
      if (error is ApiErrorRepsonse) {
        // ScaffoldMessenger.of(MyApp.globalkey.currentState!.context)
        //     .showSnackBar(SnackBar(
        //   content: Text(error.message),
        // ));
      } else {
        // ignore: use_rethrow_when_possible
        throw error;
      }
    }
  }

  //end profileimage

//get Notifications
  static Future<EnentNotificationModel?> notificationList() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final url = "${Constants.baseUrl}/events/notifications";

    try {
      Response response = await Dio().get(url,
          options: Options(headers: {
            "Authorization": 'Bearer ${_prefs.getString(PreferencesKeys.token)}'
          }));

      if (response.statusCode == 200) {
        print("Notification response 200 ");
        log(response.data.toString());
        var res = EnentNotificationModel.fromJson(response.data);
        print("*********************res******************");
        print(res);
        return res;
      } else {
        // print('${response.statusCode} : ${response.data.toString()}');
        throw response.statusCode.toString();
      }
    } catch (error) {
      print(error);
    }
  }
//get data
  /*
  //ViewCattleList
  static Future eventList() async {
    print("event response 1");
    try {
      var res = await Api.get(
        "/events/index",
      );

      print(res);
      if (res['status'] == 1) {
        // return CattleListModel.fromJson(res);
      } else if (res['status'] == 0) {
        print(res['message']);
        // var dara = CattleListModel.fromJson(res);
        // return //;
        //return
        //{
        // "status": 0,
        // "message": "Cattle Not Found"
//}
        //return ;
      }
      // var cowListdata = CattleListModel.fromJson(res);
    } catch (error) {
      if (error is ApiErrorRepsonse) {
        // ScaffoldMessenger.of(MyApp.globalkey.currentState!.context)
        //     .showSnackBar(SnackBar(
        //   content: Text(error.message),
        //));
      } else {
        // ignore: use_rethrow_when_possible
        throw error;
      }
    }
  }
  */
}
