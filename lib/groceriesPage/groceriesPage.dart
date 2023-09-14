import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roommates/groceriesPage/groceriesPagedata.dart';
import 'package:roommates/groceriesPage/addGroceries.dart';
import 'package:roommates/groceriesPage/topCard.dart';
import 'package:roommates/groceriesPage/groceriesPageController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:roommates/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'groceriesView.dart';
import 'package:roommates/User/user_model.dart';
// @dart=2.9
class groceriesPage extends StatefulWidget {
  groceriesPage({Key? key}) : super(key: key);

  @override
  State<groceriesPage> createState() => _groceriesPage();
}

class _groceriesPage extends State<groceriesPage> {
  String username = "";
  String password = "";
  String email = "";
  String balance = "";
  String income = "";
  String expense = "";
  Future getCurrentBalance() async {
    String? user = FirebaseAuth.instance.currentUser?.uid;
    if (user != null) {
      DocumentSnapshot db = await FirebaseFirestore.instance.collection("Users")
          .doc(user)
          .get();
      Map<String, dynamic> list = db.data() as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          username = list['UserName'];
          password = list['Password'];
          email = list['Email'];
          balance = list['Balance'];
          income = list['Income'];
          expense = list['Expense'];
        });
      }
    }
  }
  Future updateUserData(double newBanlance) async {
    String? userID = FirebaseAuth.instance.currentUser?.uid;
    final user = UserData(
      email: username,
      password: password,
      username: email,
      balance:newBanlance.toString(),
      income: income,
      expense: expense,
    );
    await FirebaseFirestore.instance.collection("Users").doc(userID).update(user.toJson());
  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    getCurrentBalance();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[700],
          title: const Text("Groceries"),

        ),

        body: Column(
          // child: MyStatefulWidget()

          children: [
            SizedBox(
              height: 12,
            ),
            TopNeuCard(
              balance: balance,
              income: income,
              expense: expense,
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
                child: MyStatefulWidget()
            ),
          ],
        ),
      ),
    );
  }
}// Copy and pasted code from https://api.flutter.dev/flutter/material/Scrollbar-class.html
// Slightly modified.

// Worth viewing: https://flutterforyou.com/how-to-add-space-between-listview-items-in-flutter/

// Need to implement list tile: https://api.flutter.dev/flutter/material/ListTile-class.html

// Might be fun for messagingPage: https://docs.flutter.dev/cookbook/animation/page-route-animation

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final ScrollController _firstController = ScrollController();
  final _groceriesPageController = Get.put(GroceriesPageController());
  static late MediaQueryData _mediaQueryData;
  String username = "";
  String password = "";
  String email = "";
  String balance = "";
  String income = "";
  String expense = "";
  Future updateUserData(double newBanlance,double amount) async {
    String? userID = FirebaseAuth.instance.currentUser?.uid;
    final user = UserData(
      email: username,
      password: password,
      username: email,
      balance:newBanlance.toString(),
      income: income,
      expense: amount.toString(),
    );
    await FirebaseFirestore.instance.collection("Users").doc(userID).update(user.toJson());
  }
  Future getCurrentBalance() async {
    String? user = FirebaseAuth.instance.currentUser?.uid;
    if (user != null) {
      DocumentSnapshot db = await FirebaseFirestore.instance.collection("Users")
          .doc(user)
          .get();
      Map<String, dynamic> list = db.data() as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          username = list['UserName'];
          password = list['Password'];
          email = list['Email'];
          balance = list['Balance'];
          income = list['Income'];
          expense = list['Expense'];
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    _groceriesPageController.getGroceries();
    _mediaQueryData = MediaQuery.of(context);
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children:[
              SizedBox(
                  width: constraints.maxWidth - constraints.maxWidth * 0.05,
                  height: constraints.maxHeight - constraints.maxHeight * 0.2,
                  child: Obx(() {
                    //thumbVisibility: true,
                    //thickness: 10,
                    return ListView.builder(
                        primary: true,
                        itemCount: _groceriesPageController.groceriesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          Groceries groceries = _groceriesPageController.groceriesList[index];
                          var title = groceries.title;

                          return Padding(

                            // Spacing between elements:
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),

                            child: Container(
                              //color: Color(coloDB!),
                              // color: index.isEven
                              //     ? Colors.amberAccent
                              //     : Colors.blueAccent,
                                child: InkWell(
                                  child:
                                  groceriesView(groceries),
                                  onTap: () {
                                    showBottomSheet(context, groceries);
                                  },
                                )

                            ),
                          );
                        }

                    );
                  })

              ),
              addTaskBar(),
            ],
          );
        });
  }
  addTaskBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 12, top: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Add task button
          FloatingActionButton(
            backgroundColor: Colors.orange[700],
            onPressed:  () async {
              await Get.to(addGroceries());
              _groceriesPageController.getGroceries();
            },
            child: Icon(
              Icons.add,
            ),
          ),
        ],
      ),
    );
  }
  showBottomSheet(BuildContext context,  Groceries groceries) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(top: 4),
        // height: groceries.isCompleted == 1
        //     ? _mediaQueryData.size.height * 0.24
        //     : _mediaQueryData.size.height * 0.32,
        height: _mediaQueryData.size.height * 0.32,
        width: _mediaQueryData.size.width,
        color: Get.isDarkMode ? darkHeaderClr : Colors.white,
        child: Column(children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          ),
          Spacer(),
          _buildBottomSheetButton(
              label: "Pay Groceries",
              onTap: () {
                //Undo
                getCurrentBalance();
                updateUserData(double.parse(balance) - (groceries.amount as double),groceries.amount as double);

                _groceriesPageController.deleteGroceries(groceries);
                Get.back();
              },
              clr: Colors.blue[300]),
          SizedBox(
            height: 20,
          ),
          _buildBottomSheetButton(
              label: "Delete Groceries",
              onTap: () {
                _groceriesPageController.deleteGroceries(groceries);
                Get.back();
              },
              clr: Colors.red[300]),
          SizedBox(
            height: 20,
          ),
          _buildBottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              isClose: true),
          SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }
  _buildBottomSheetButton(
      {required String label, Function? onTap, Color? clr, bool isClose = false}) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: _mediaQueryData.size.width! * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose
                ? Get.isDarkMode
                ? Colors.grey[600]!
                : Colors.grey[300]!
                : clr!,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
            child: Text(
              label,
              style: isClose
                  ? titleTextStle
                  : titleTextStle.copyWith(color: Colors.white),
            )),
      ),
    );
  }
}
