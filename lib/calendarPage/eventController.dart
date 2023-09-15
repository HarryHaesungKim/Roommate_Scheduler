import 'dart:ffi';

import 'package:get/get.dart';
import 'package:roommates/calendarPage/event.dart';

import 'database_event.dart';

class eventController extends GetxController {
  //this will hold the data and update the ui
  final _db = Get.put(DBHelper_event());
  final RxList<Event> eventList = List<Event>.empty().obs;
  // final RxMap<String?, List<Event>> eventsMap = RxMap<String?, List<Event>>();
  final RxMap<String?, List<int>> eventsMap = RxMap<String?,List<int>>();

  @override
  void onReady() {
    getEvents();
    super.onReady();
  }


  // add data to table
  //second brackets means they are named optional parameters
  Future<void> addEvent({required Event event}) async {
    await _db.createEvent(event);
  }

  // get all the data from table
  void getEvents() async {
    List<Map<String, dynamic>> events = await _db.getEvents();
    eventList.assignAll(events.map((data) => new Event.fromJson(data)).toList());
    eventsMap.clear();
    for(int i = 0; i < eventList.length; i++){
      if (eventsMap.containsKey(eventList[i].date)) {
        // if(eventsMap[eventList[i].date]! .contains(eventList[i])==true){
        //   eventsMap[eventList[i].date]?.add(eventList[i]);
        // }
        if(eventsMap[eventList[i].date]?.contains(i)==false){
          eventsMap[eventList[i].date]?.add(i);
        }
      }
      else{
        eventsMap.addAll({
          eventList[i].date: [i]
        });
      }
    }
  }

  // delete data from table
  void deleteEvent(Event event) async {
    await _db.deleteEvent(event);
    getEvents();
  }
}