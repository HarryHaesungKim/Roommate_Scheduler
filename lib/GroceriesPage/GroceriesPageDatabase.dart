import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:roommates/groceriesPage/groceriesPagedata.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
//Groceries
class GroceriesPageDatabaseHelper {
final _db = FirebaseFirestore.instance;


//add the groceries to the database
createGroceries(Groceries groceries) async {
  await _db.collection("Groceries").add(groceries.toJson()).then((value)
  =>
      _db.collection("Groceries").doc(value.id).update({"id": value.id.toString()})).whenComplete(() =>
      Get.snackbar("Success!",
          "Groceries has been created.")).
  catchError((error, stackTrace) {
    //something went wrong. tell user
    Get.snackbar("ERROR", "Whoops, something went wrong.");
  });


}
//delete the groceries to the database
deleteGroceries(Groceries groceries) async {
  _db.collection("Groceries").doc(groceries.id).delete().whenComplete(() =>
      Get.snackbar("Success!",
          "Groceries has been deleted.")).
  catchError((error, stackTrace) {
    //something went wrong. tell user
    Get.snackbar("ERROR", "Whoops, something went wrong.");
  });
}

getGroceries() async {
  List<Map<String, dynamic>> groceries = [];
  await _db.collection("Groceries").get().then(
          (querySnapshot) {
        for (var Grocerie in querySnapshot.docs)
        {
          if(!Grocerie.data().containsKey("dummy")) {
            groceries.add(Grocerie.data());
          }
        }
      }
  );
  return groceries;
}

payGroceries(Groceries groceries) async {

}

selectedGroceries(Groceries groceries) async {

}
}

