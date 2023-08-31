import 'package:get/get.dart';
import 'package:roommates/GroceriesPage/groceriesPagedata.dart';
import 'package:roommates/GroceriesPage/GroceriesPageDatabase.dart';

class GroceriesPageController extends GetxController {
  //this will hold the data and update the ui
  final _db = Get.put(GroceriesPageDatabaseHelper());
  final RxList<Groceries>groceriesList = List<Groceries>.empty().obs;

  @override
  void onReady() {
    getGroceries();
    super.onReady();
  }

  // add data to table
  //second brackets means they are named optional parameters
  Future<void> addGroceries({required Groceries groceries}) async {
    await _db.createGroceries(groceries);
  }

  // get all the data from table
  void getGroceries() async {
    List<Map<String, dynamic>> groceries = await _db.getGroceries();
    groceriesList.assignAll(
        groceries.map((data) => new Groceries.fromJson(data)).toList());
  }

  // delete data from table
  void deleteGroceries(Groceries groceries) async {
    await _db.deleteGroceries(groceries);
    getGroceries();
  }
}

