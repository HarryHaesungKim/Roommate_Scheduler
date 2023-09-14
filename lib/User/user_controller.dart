import 'package:get/get.dart';
import 'package:roommates/User/user_database.dart';
import 'package:roommates/User/user_model.dart';
class userController extends GetxController {
  final _userData = Get.put(UserDatabaseHelper());


  @override
  void onReady() {
    getUserDatas();
    super.onReady();
  }

  final RxList<UserData> userdataList = List<UserData>.empty().obs;


  void getUserDatas() async {
    List<Map<String, dynamic>> userdatas = await _userData.getUserData();
    userdataList.assignAll(
        userdatas.map((data) => new UserData.formJson(data)).toList());
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