import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mao/models/event_model.dart';
import 'package:mao/models/user_model.dart';
import 'package:mao/services/network.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyController extends GetxController {
  //profile pic
  var isProfilePicPathSet = false.obs;
  //Rx<File>
  Rx<String> profilePicPath = ''.obs;

  void setProfileImagePath(String imagepath) {
    print("se profile image 1");
    print(profilePicPath);
    profilePicPath.value = imagepath.toString();
    print("se profile image 2");
    isProfilePicPathSet.value = true;
    print("se profile image 3");
    update();
    print("se profile image 4");
    print(profilePicPath);
  }

  void UpdateProfile() async {
    print("update function call 1");
    if (isProfilePicPathSet.value == false) {
      print("Please select Profile pic");
    } else {
      print("update function call 2");
      print(profilePicPath.value);
      var response =
          await NetworkApi.CompleteProfile(imagepath: profilePicPath.value);
      if (response?.status == 0) {
        print("not response complete profile");
      } else if (response?.data != null && response?.status == 1) {
        print("controller response ***********");
        // print(response!.data.length);
        user = response!;
        GetStorage().write("currenuserdata", response.toJson());
      }
      print("update function call");
    }
  }

//user
  final Rx<UserModel> _user = UserModel().obs;
  set user(UserModel user) => _user.value = user;
  UserModel get user => _user.value;
  //Event NotificationList
  var eventLoading = true.obs;

  RxList eventNotifList = [].obs;
//chat message list
  RxList chatMessages = [].obs;
  //Event logoutList
  var logoutloading = true.obs;

//event
  var eventList = <EventData>[].obs;
  var isLoading = true.obs;
  void fetcheventListdata() async {
    try {
      isLoading(true);
      var response = await NetworkApi.eventList();
      if (response?.status == 0) {
        print("not response  Event List");
      } else if (response?.data != null && response?.status == 1) {
        print("controller response ***********");
        // print(response!.data.length);
        eventList.assignAll(response!.data);
      }
    } finally {
      isLoading(false);
    }
  }

  //Event Notification model data
  void fetchEventNotification() async {
    try {
      eventLoading(false);
      var response = await NetworkApi.notificationList();
      if (response?.status == 0) {
        print("not response notification");
      } else if (response?.data != null && response?.status == 1) {
        print(" response 200 notification");
        eventNotifList.assignAll(response!.data!);
        print("Notification data response done ");
        //print(eventList.first.id);
      }
    } finally {
      eventLoading(false);
    }
  }
  //Logout

  Future Logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      logoutloading(false);
      var response = await NetworkApi.Logout();
      //var response = await NetworkApi.notificationList();
      if (response['status'] == 0) {
        // print(" Logout api error");
      } else if (response != null && response['status'] == 1) {
        //print(" response 200 Logout");
        GetStorage().remove('currenuserdata');
        await preferences.clear();
        // print("Logout response done ");
        return response;
        //print(eventList.first.id);
      }
    } finally {
      logoutloading(false);
    }
  }
}
