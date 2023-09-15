import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:roommates/calendarPage/event.dart';

class DBHelper_event {
  final _db = FirebaseFirestore.instance;
  //static final int _version = 1;
  //static final String _tableName = 'Event';
  createEvent(String groupID, Event event) async {

    await _db.collection("Group").doc(groupID).collection("Event").add(event.toJson()).then((value)
    =>
        _db.collection("Group").doc(groupID).collection("Event").doc(value.id).update({"id": value.id.toString()})).whenComplete(() =>
        Get.snackbar("Success!",
            "Event has been created.")).
    catchError((error, stackTrace) {
      //something went wrong. tell user
      Get.snackbar("ERROR", "Whoops, something went wrong.");
    });
  }

  ///
  ///  This method returns all the Event currently in the database
  ///
  getEvents(String groupID) async {
    List<Map<String, dynamic>> events = [];
    await _db.collection("Group").doc(groupID).collection("Event").get().then(
            (querySnapshot) {
          for (var event in querySnapshot.docs)
          {
            if(!event.data().containsKey("dummy")) {
              events.add(event.data());
            }
          }
        }
    );
    return events;
  }

  getUsers() async {


  }

  deleteEvent(String groupID, Event event) async {
    _db.collection("Group").doc(groupID).collection("Event").doc(event.id).delete().whenComplete(() =>
        Get.snackbar("Success!",
            "Event has been deleted.")).
    catchError((error, stackTrace) {
      //something went wrong. tell user
      Get.snackbar("ERROR", "Whoops, something went wrong.");
    });
  }
}