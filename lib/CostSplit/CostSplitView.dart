

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roommates/CostSplit/CostSplitController.dart';
import 'package:roommates/CostSplit/CostSplitObject.dart';

import '../Group/groupController.dart';

import 'dart:math' as math;

class CostSplitView extends StatefulWidget {
  const CostSplitView({Key? key}) : super(key: key);

  @override
  State<CostSplitView> createState() => _CostSplitViewPage();
}

class _CostSplitViewPage extends State<CostSplitView> {

  //user id
  String? uID = FirebaseAuth.instance.currentUser?.uid;

  // GroupID
  String currGroupID = '';

  // Controllers
  final groupController groupCon = groupController();
  final CostSplitController costSplitCon = CostSplitController();

  // Global key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text controller for adding new title for the payment pop-up.
  final TextEditingController _newPaymentTitleController = TextEditingController();
  final TextEditingController _newPaymentDescriptionController = TextEditingController();
  final TextEditingController _newPaymentAmountController = TextEditingController();

  // Lists
  late List<String> peopleInGroup = [];
  late List<String> peopleInGroupIDs = [];
  late List<bool> addPeopleYesOrNo = [];

  // Future data
  late Future<String> futureGroupID;
  late Future<List<String>> futurePeopleInGroup;
  late Future<List<String>> futurePeopleInGroupIDs;

  // Regular Expression for amount
  final alphanumeric = RegExp(r'^(\d{1, 3}(\, \d{3})*|(\d+))(\.\d{2})?$');

  // Scroll Controller?
  final ScrollController _controllerOne = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futurePeopleInGroup = groupCon.getUsersInGroup(uID!);
    futurePeopleInGroupIDs = groupCon.getUserIDsInGroup(uID!);
    futureGroupID = groupCon.getGroupIDFromUser(uID!);
  }

  // Getting the payments from firebase.
  Stream<List<CostSplitObject>> readPayments() {

    // // Get list of users in the same group. Waits until we have the data.
    // final futureData = await Future.wait([groupCon.getGroupIDFromUser(currUser!)]);

    return FirebaseFirestore.instance
        .collection('Group').doc(currGroupID).collection('Payments')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => CostSplitObject.fromJson(doc.data()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // throw UnimplementedError();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[700],
          title: const Text("Cost Split"),
        ),

        body: FutureBuilder(

          future: futureGroupID,

          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            // return StreamBuilder(
            //   Stream:
            //     builder: builder
            // );

            // return const SizedBox();

            return FutureBuilder(
                future: futureGroupID,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                  // If there's an error.
                  if(snapshot.hasError){
                    return Text("Something went wrong! ${snapshot.error}");
                  }

                  // If there's no error and the snapshot has data.
                  else if(snapshot.hasData){

                    currGroupID = snapshot.data;

                    return StreamBuilder(
                        stream: readPayments(),
                        builder: (context, snapshot){

                          if (snapshot.hasError){
                            return Text('Something went wrong! ${snapshot.error}');
                          }

                          else if (snapshot.hasData) {
                            final payments = snapshot.data!;
                            return Center(
                              child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      width: constraints.maxWidth,
                                      height: constraints.maxHeight,
                                      child: ListView.separated(
                                        padding: const EdgeInsets.all(8),

                                        primary: true,
                                        itemCount: payments.length,

                                        itemBuilder: (context, index) {
                                          return Text(payments[index].title);
                                        },

                                        // Separates the items. Invisible with a sized box rather than a divider.
                                        separatorBuilder: (BuildContext context, int index) => const SizedBox ( height : 10),

                                      ),
                                    ),
                                  ],
                                );
                              }

                              ),
                            );

                          }

                          else{
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                    );
                  }

                  else{
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                }
            );
          },

        ),

        // floatingActionButton: FloatingActionButton(
        //     backgroundColor: Colors.orange[700],
        //     onPressed: () async {
        //       showDialog(context: context, builder: (context){
        //         return addPaymentDialogue(context);
        //       });
        //     },child: const Icon(Icons.add_alert_outlined)
        // ),

        // Button to add a new chat.
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange[700],
            onPressed: () async {
              // show a dialog for user to input event name
              await addPaymentDialogue(context);
        }, child: const Icon(Icons.add)),

      ),

    );
  }

  Future<void> addPaymentDialogue(BuildContext context) async {

    //buildGroupChatList();

    return await showDialog(context: context, builder: (context) {
      // Replaced textEditingController with _newChatNameController.
      // final TextEditingController textEditingController = TextEditingController();
      bool? isChecked = false;

      // Clears input field upon every pop-up.
      _newPaymentTitleController.clear();
      _newPaymentDescriptionController.clear();
      _newPaymentAmountController.clear();

      return FutureBuilder(
          future: Future.wait([futurePeopleInGroup, futurePeopleInGroupIDs]),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

            // If there's an error.
            if(snapshot.hasError){
              return Text("Something went wrong! ${snapshot.error}");
            }

            // If there's no error and the snapshot has data.
            else if(snapshot.hasData){

              // Setting the group members and their IDs.
              peopleInGroup = snapshot.data[0];
              peopleInGroupIDs = snapshot.data[1];

              // TODO: Remove current user from this list. Makes no sense to owe yourself.

              // Filling this list so that it knows how many people are in the group for the length.
              addPeopleYesOrNo = List.filled(peopleInGroup.length, true);

              return StatefulBuilder(builder: (context, setState) {

                return AlertDialog(
                  title: const Text("Add New Payment"),
                  content: SingleChildScrollView(
                    child: Form(
                        key: formKey,
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              // Payment title input.
                              TextFormField(
                                controller: _newPaymentTitleController,
                                validator: (value) {
                                  return value!.isNotEmpty ? null : "Invalid Field";
                                },
                                decoration: const InputDecoration(
                                    hintText: "Enter payment title"),
                              ),

                              // Padding
                              const SizedBox(height: 25),

                              // Payment description field.
                              Container(
                                constraints: const BoxConstraints(maxHeight: 150),
                                child: TextFormField(
                                  minLines: 2, // any number you need (It works as the rows for the textarea)
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,

                                  // Controller stuff.
                                  controller: _newPaymentDescriptionController,
                                  // validator: (value) {
                                  //   return value!.isNotEmpty ? null : "Invalid Field";
                                  // },

                                  // Decorations
                                  decoration: const InputDecoration(
                                    hintText: "Enter description (optional)",
                                    border: OutlineInputBorder(),
                                  ),

                                ),
                              ),

                              // Padding
                              const SizedBox(height: 30),

                              // Text
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Enter Payment Amount",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),

                              // Enter Amount
                               TextFormField(
                                 controller: _newPaymentAmountController,
                                 validator: (value) {
                                   return (alphanumeric.hasMatch(value!) && value!.isNotEmpty) ? null : "Invalid Field";
                                 },
                                 decoration: const InputDecoration(
                                   hintText: "Enter your number",
                                   prefixIcon:Text("\$ "),
                                   prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
                                 ),
                                 inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],
                                 keyboardType: TextInputType.number,
                              ),

                              // Padding
                              const SizedBox(height: 30),

                              // Text
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Select Group Members",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),

                              // Padding
                              const SizedBox(height: 20),



                              // Group Member Checklist
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    color: const Color.fromRGBO(0, 0, 0, 0.0),
                                ),
                                // Can change color.
                                // color: const Color.fromRGBO(0, 0, 0, 0.0),
                                child: SizedBox(
                                  width: double.maxFinite,
                                  height: 150,
                                  child: Scrollbar(
                                    controller: _controllerOne,
                                    thumbVisibility: true,
                                    thickness: 5,
                                    child: ListView.builder(
                                      controller: _controllerOne,
                                      shrinkWrap: true,
                                      itemCount: peopleInGroup.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return CheckboxListTile(
                                            value: addPeopleYesOrNo[index],
                                            onChanged: (bool? value) {
                                              setState(() {
                                                addPeopleYesOrNo[index] = value!;
                                              });
                                              //addPeopleYesOrNo[index] = value!;
                                            },
                                            title: Text(peopleInGroup[index])
                                        );
                                      },
                                    ),
                                  ),

                                ),
                              ),

                            ],
                          ),
                        )),
                  ),

                  actions: <Widget>[
                    TextButton(
                      child: const Text("Okay"),
                      onPressed: () {
                        // TODO: Send the payment info to Firebase and refresh the UI.

                        if (formKey.currentState!.validate() &&
                            _newPaymentTitleController.text.isNotEmpty &&
                            _newPaymentAmountController.text.isNotEmpty &&
                            addPeopleYesOrNo.contains(true)) {

                          List<String> peepsWhoNeedToPay = [];

                          for (int i = 0; i < addPeopleYesOrNo.length; i++) {
                            if (addPeopleYesOrNo[i]) {
                              peepsWhoNeedToPay.add(peopleInGroupIDs[i]);
                            }
                          }

                          // Sending the information to Firebase.
                          costSplitCon.createPayment(title: _newPaymentTitleController.text, description: _newPaymentDescriptionController.text, amount: _newPaymentAmountController.text, whoNeedsToPay: peepsWhoNeedToPay);

                          // Close the alert dialog.
                          Navigator.pop(context);

                        }


                      },
                    ),
                  ],
                );

              });

            }
            // Loading.
            else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }




      });
    });
  }

}

// Got from: https://stackoverflow.com/questions/54454983/allow-only-two-decimal-number-in-flutter-input

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
    return newValue;
  }
}