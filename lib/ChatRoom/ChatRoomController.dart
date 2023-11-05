import 'package:get/get.dart';
import 'package:roommates/Task/database_demo.dart';

class ChatRoomController extends GetxController {
  //this will hold the data and update the ui
  final _db = Get.put(DBHelper());


  Future<void> createChatRoom(String senderID, List<String> receiverIDs, String title) async {
    await _db.createChatRoom(senderID, receiverIDs, title);
  }

  Future<List<String>> getGroupChatTitles(String uID) async {
    return await _db.getGroupChatTitles(uID);
  }

  Future<Map<String, String>> getGroupInfo(String uID) async {
    return await _db.getGroupChatInfo(uID);
  }

  List<String> getUserInChatID(String uID, String chatID) {
    return _db.getUsersInChatID(uID, chatID);
  }
}
