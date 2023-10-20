import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:roommates/User/user_database.dart';
import 'package:roommates/User/user_model.dart';

import '../Group/groupController.dart';
class userController extends GetxController {
  final _userData = Get.put(UserDatabaseHelper());

  final RxList<UserData>userdataList = List<UserData>.empty().obs;
  final RxList<GeoPoint>userLocationList = List<GeoPoint>.empty().obs;
  final _groupController = Get.put(groupController());
  String? uID = FirebaseAuth.instance.currentUser?.uid;


  @override
  Future<void> onReady() async {
    String groupID = await _groupController.getGroupIDFromUser(uID!);
    getUserData(groupID);
    super.onReady();
  }



  void getUserData(String groupID) async {
    List<Map<String, dynamic>> userdata = await _userData.getUserData(groupID);
    userdataList.assignAll(
        userdata.map((data) => new UserData.formJson(data)).toList());
  }
  void getUserLocation(String uid) async {
    List<GeoPoint> userLocation= await _userData.getUsersLocationInGroup(uid);
    userLocationList.assignAll(
        userLocation);
  }
  updateUserData(UserData user) async{
    _userData.UpdateUserData(user);
  }

  ///
  /// Given a userID returns the username of that user
  ///
  Future<String> getUserName(String uID) async {
    return await _userData.getUserName(uID);
  }

}