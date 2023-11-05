import 'package:firebase_auth/firebase_auth.dart';
import 'package:roommates/User/user_model.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserDatabaseHelper {
  final _db = FirebaseFirestore.instance;
  String? userID = FirebaseAuth.instance.currentUser?.uid;
//All users
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
  createUser( UserData userdatas) async {
    await _db.collection("Users").doc(userID).set(userdatas.toJson());
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
  Future<String> getUserThemeColor(String uID) async {
    final userRef = await _db.collection("Users").doc(uID).get();
    String themeColor = userRef['themeColor'];
    return themeColor;
  }
  Future<String> getUserThemeBrightness(String uID) async {
    final userRef = await _db.collection("Users").doc(uID).get();
    String themeBrightness = userRef['themeBrightness'];
    return themeBrightness;
  }
  Future<UserData> getUserDetails(String uID) async {
    final docRef = _db.collection("users").doc(uID);
    DocumentSnapshot doc = await docRef.get();
    final data = doc.data() as UserData;
    return data;
  }

}
