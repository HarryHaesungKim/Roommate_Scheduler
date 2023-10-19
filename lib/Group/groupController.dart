import 'package:get/get.dart';
import 'package:roommates/Task/database_demo.dart';
import 'package:roommates/Task/task.dart';
import 'package:roommates/Task/database_demo.dart';
import 'package:roommates/Group/groupModel.dart';

class groupController extends GetxController {
  //this will hold the data and update the ui
  final _db = Get.put(DBHelper());

  @override
  void onReady() {
    super.onReady();
  }

  final List<String> userList = List<String>.empty().obs;

  /// Returns whether a [groupID] already exists
  ///
  ///
  Future<bool> doesGroupExist(String groupID) async {
    return await _db.groupIDExists(groupID);
  }

  /// Adds the user from [userID] into group [groupID]
  ///
  ///
  Future<void> addUserToGroup(String groupID, String uID) async {
    await _db.addUserToGroup(groupID, uID);
  }

  /// Creates a group with [group] and first user being [uID]
  ///
  ///
  Future<void> createGroup(GroupModel group, String uID) async {
    await _db.createGroup(group, uID);
  }

  /// Returns the list of usersNames in the group [uID] is in
  ///
  ///
  Future<List<String>> getUsersInGroup(String uID) async
  {
    return await _db.getUsersInGroupID(uID);
  }

  /// Returns the list of userIDs of users in the group that [uID] is in
  ///
  ///
  Future<List<String>> getUserIDsInGroup(String uID) async
  {
    return await  _db.getUsersIDsInGroup(uID);
  }

  /// Returns the groupID of the group that a user [uID] is in
  ///
  ///
  Future<String> getGroupIDFromUser(String uID) async {
    return await _db.getGroupID(uID);
  }

  /// Removes user from the current group they are in given their [uID]
  ///
  ///
  Future<void> removeUser(String uID) async {
    return await _db.removeUserFromGroup(uID);
  }

  /// Returns whether not user [uID] is in a group or not
  ///
  ///
  Future<bool> isUserInGroup(String uID) async {
    return await _db.isUserInGroup(uID);
  }

  /// Returns whether user [uID] is an admin user in their group
  Future<bool> isUserAdmin(String uID) async {
    return await _db.isUserAdmin(uID);
  }

  /// Returns list of all members in user [uID] who are not admins
  Future<List<String>> getNonAdminUserNames(String uID) async {
    return await _db.getNonAdminUsers(uID);
  }

  /// Returns list of all admin users in user [uID]'s group
  Future<List<String>> getAdminUsers(String uID) async {
    return await _db.getAdminUsers(uID);
  }

}
