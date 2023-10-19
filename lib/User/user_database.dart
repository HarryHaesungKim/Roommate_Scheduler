import 'package:roommates/User/user_model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserDatabaseHelper {
  final _db = FirebaseFirestore.instance;

  getUserData(String groupID) async {
    List<Map<String, dynamic>> userdatas = [];
    await _db.collection("Group").doc(groupID).collection("users").get().then(
            (querySnapshot) {
          for (var users in querySnapshot.docs)
          {
            if(!users.data().containsKey("dummy")) {
              userdatas.add(users.data());
              print("Get Users.!!!!!!!!!!!!!!!!!");
            }
          }
        }
    );
    return userdatas;
  }
  Future<List<GeoPoint>> getUsersLocationInGroup(String uID) async {
    String gID = await getGroupID(uID);
    final groupref = await _db.collection("Group").doc(gID).get();
    var array = groupref.data()?['users'];
    List<String> usersIDs = List<String>.from(array);
    List<GeoPoint> userLocation = [];
    for (var user in usersIDs){
      final userRef = await _db.collection("Users").doc(user).get();
      userLocation.add(userRef.data()!['location']);
    }
    //print("Usernames are " + userNames.toString());
    return userLocation;
  }
  Future<String> getGroupID(String uID) async
  {

    final docref = await _db.collection('Users').doc(uID).get();
    String gID = docref.data()?['groupID'];
    return gID;
  }
  createUserData(String groupID, UserData userdatas) async {
    await _db.collection("Group").doc(groupID).collection("Users").add(userdatas.toJson()).then((value)
    =>
        _db.collection("Group").doc(groupID).collection("Users").doc(value.id).update({"id": value.id.toString()})).whenComplete(() =>
        Get.snackbar("Success!",
            "Groceries has been created.")).
    catchError((error, stackTrace) {
      //something went wrong. tell user
      Get.snackbar("ERROR", "Whoops, something went wrong.");
    });
  }

  UpdateUserData(UserData userData) async {
    //await _db.collection("Users").doc(userData.id).update(userData.toJson());

  }

  ///
  /// Given a userID this method returns the Username of that user
  ///
  Future<String> getUserName(String uID) async {
    final userRef = await _db.collection("Users").doc(uID).get();
    String userName = userRef['UserName'];
    return userName;
  }
}
