import 'package:roommates/User/user_model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserDatabaseHelper {
  final _db = FirebaseFirestore.instance;

  getUserData() async {
    List<Map<String, dynamic>> userdatas = [];
    await _db.collection("Users").get().then(
            (querySnapshot) {
          for (var user in querySnapshot.docs)
          {
            if(!user.data().containsKey("dummy")) {
              userdatas.add(user.data());
            }
          }
        }
    );
    return userdatas;
  }

  UpdateUserData(UserData userData) async {
    //await _db.collection("Users").doc(userData.id).update(userData.toJson());

  }
}
