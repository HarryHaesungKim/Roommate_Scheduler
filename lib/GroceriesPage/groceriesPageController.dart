import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:roommates/groceriesPage/groceriesPagedata.dart';
import 'package:roommates/groceriesPage/GroceriesPageDatabase.dart';

import '../Group/groupController.dart';

class GroceriesPageController extends GetxController {
  //this will hold the data and update the ui
  final _db = Get.put(GroceriesPageDatabaseHelper());
  final RxList<Groceries>groceriesList = List<Groceries>.empty().obs;
  final _groupController = Get.put(groupController());
  String? uID = FirebaseAuth.instance.currentUser?.uid;

  @override
  Future<void> onReady() async {
    String groupID = await _groupController.getGroupIDFromUser(uID!);
    getGroceries(groupID);
    super.onReady();
  }

  // add data to table
  //second brackets means they are named optional parameters
  Future<void> addGroceries(groupID, {required Groceries groceries}) async {
    await _db.createGroceries(groupID, groceries);
  }

  // get all the data from table
  void getGroceries(String groupID) async {
    List<Map<String, dynamic>> groceries = await _db.getGroceries(groupID);
    groceriesList.assignAll(
        groceries.map((data) => new Groceries.fromJson(data)).toList());
  }

  // delete data from table
  void deleteGroceries(String groupID, Groceries groceries) async {
    await _db.deleteGroceries(groupID, groceries);
    getGroceries(groupID);
  }
}

