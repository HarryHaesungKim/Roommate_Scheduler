import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roommates/CostSplit/CostSplitController.dart';
import 'package:roommates/CostSplit/CostSplitObject.dart';

import '../Group/groupController.dart';

import 'dart:math' as math;

import '../themeData.dart';

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
  final TextEditingController _newPaymentTitleController =
  TextEditingController();
  final TextEditingController _newPaymentDescriptionController =
  TextEditingController();
  final TextEditingController _newPaymentAmountController =
  TextEditingController();

  // Lists
  late List<String> peopleInGroup = [];
  late List<String> peopleInGroupIDs = [];
  late List<bool> addPeopleYesOrNo = [];

  // Future data
  late Future<String> futureGroupID;
  late Future<List<String>> futurePeopleInGroup;
  late Future<List<String>> futurePeopleInGroupIDs;

  // Regular Expression for amount
  final alphanumeric = RegExp(r'^(\d{1, 3}(\d{3})*|(\d+))(\.\d{2})?$');

  // Scroll Controller?
  final ScrollController _controllerOne = ScrollController();

  // Map of members IDs and username.
  late Map<String, String> iDNameMap = {};
  static late MediaQueryData _mediaQueryData;

  @override
  void initState() {
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
        .collection('Group')
        .doc(currGroupID)
        .collection('Payments')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CostSplitObject.fromJson(doc.data()))
        .toList());
  }

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    return FutureBuilder(
        future: Future.wait(
            [futureGroupID, futurePeopleInGroup, futurePeopleInGroupIDs]),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // If there's an error.
          if (snapshot.hasError) {
            return Text("Something went wrong! ${snapshot.error}");
          }

          // If there's no error and the snapshot has data.
          else if (snapshot.hasData) {
            currGroupID = snapshot.data[0];

            // Setting the group members and their IDs.
            peopleInGroup = snapshot.data[1];
            peopleInGroupIDs = snapshot.data[2];

            // Mapping IDs to UserNames (since they are done in order).
            for (var i = 0; i < peopleInGroupIDs.length; i++) {
              iDNameMap[peopleInGroupIDs[i]] = peopleInGroup[i];
            }

            // peopleInGroup.remove(iDNameMap[uID]);
            // peopleInGroupIDs.remove(uID);

            //print(iDNameMap);

            return StreamBuilder(
                stream: readPayments(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong! ${snapshot.error}');
                  }
                  else if (snapshot.hasData) {
                    final payments = snapshot.data!;
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(uID)
                            .snapshots(),
                        builder: (context, snapshot2) {
                          if (snapshot2.hasError) {
                            return Text('Something went wrong! ${snapshot2
                                .data}');
                          }
                          else if (snapshot2.hasData) {
                            final UserData = snapshot2.data!;
                            payments.sort((a, b) => b.time.compareTo(a.time));

                            // Calculate how much you owe or are owed.
                            var youOwe = 0.0;
                            var youAreOwed = 0.0;

                            for (var payment in payments) {
                              if (payment.creator == uID) {
                                youAreOwed +=
                                    double.parse(payment.howMuchDoesEachPersonOwe) *
                                        (payment.whoNeedsToPay.length -
                                            payment.whoHasPaid.length);
                              } else if (payment.creator != uID &&
                                  payment.whoHasPaid.contains(uID)) {
                                // Do nothing.
                              } else {
                                youOwe +=
                                    double.parse(payment.howMuchDoesEachPersonOwe);
                              }
                            }
                            return MaterialApp(
                                theme: showOption(UserData['themeBrightness']),
                                home: Scaffold(
                                  appBar: AppBar(
                                    backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),
                                    title: const Text("Split Pay"),
                                  ),
                                  floatingActionButton: FloatingActionButton(
                                      backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),
                                      onPressed: () async {
                                        // show a dialog for user to input event name
                                        await addPaymentDialogue(context);
                                      },
                                      child: const Icon(Icons.add)),
                                  body: Center(
                                    child: LayoutBuilder(builder:
                                        (BuildContext context, BoxConstraints constraints) {
                                      // Button to add a new chat.
                                      return Column(
                                        children: [
                                          // Padding(
                                          //   padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
                                          //   child:
                                          // ),
                                          Container(
                                            color: Colors.transparent,
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.fromLTRB(35, 10, 25, 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                children: [

                                                  // // The username.
                                                  // Align(
                                                  //   alignment: Alignment.centerLeft,
                                                  //   child: Text(
                                                  //       overflow: TextOverflow.ellipsis,
                                                  //       textAlign: TextAlign.left,
                                                  //       "${iDNameMap[uID]!},",
                                                  //       style: GoogleFonts.lato(
                                                  //           textStyle: const TextStyle(
                                                  //               fontWeight: FontWeight.bold,
                                                  //               fontSize: 30,
                                                  //               color: Colors.black))),
                                                  // ),
                                                  //
                                                  // // Spacing.
                                                  // const SizedBox(
                                                  //   width: 10,
                                                  // ),

                                                  // Text for you owe.
                                                  Align(
                                                    alignment: Alignment.center,
                                                  child:FittedBox(
                                                    fit: BoxFit.fitWidth,
                                                    child: Text(
                                                        overflow: TextOverflow.ellipsis,
                                                        //maxLines: 1,
                                                        textAlign: TextAlign.center,
                                                        //notificationTitles[index],
                                                        "You owe:\n\$${youOwe.toStringAsFixed(2)}",
                                                        style: GoogleFonts.lato(
                                                          textStyle: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: _mediaQueryData.size.width/15,
                                                              color: Colors.red),
                                                        )),
                                                  )
                                                  ),

                                                  // Spacing.
                                                  const SizedBox(
                                                    width: 15,
                                                  ),

                                                  // Text for you are owed.
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child:FittedBox(
                                                        fit: BoxFit.cover,
                                                      child: Text(
                                                          overflow: TextOverflow.ellipsis,
                                                          //maxLines: 1,
                                                          textAlign: TextAlign.center,
                                                          //notificationTitles[index],
                                                          "You are owed:\n\$${youAreOwed.toStringAsFixed(2)}",
                                                          style: GoogleFonts.lato(
                                                            textStyle: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: _mediaQueryData.size.width/15,
                                                                color: Colors.green),
                                                          )),
                                                    )

                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),

                                          SizedBox(
                                            width: constraints.maxWidth,
                                            height: constraints.maxHeight - 26 - 26 - 26 - 9,
                                            child: ListView.separated(
                                              padding:
                                              const EdgeInsets.fromLTRB(20, 10, 20, 20),

                                              primary: true,
                                              itemCount: payments.length,

                                              itemBuilder: (context, index) {
                                                if (index == payments.length - 1) {
                                                  return Column(
                                                    children: [
                                                      paymentTile(payments[index]),
                                                      const SizedBox(
                                                        height: 68,
                                                      )
                                                    ],
                                                  );
                                                }

                                                return paymentTile(payments[index]);
                                              },

                                              // Separates the items. Invisible with a sized box rather than a divider.
                                              separatorBuilder:
                                                  (BuildContext context, int index) =>
                                              const SizedBox(height: 10),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ));
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                    );

                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Future<void> addPaymentDialogue(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          // Clears input field upon every pop-up.
          _newPaymentTitleController.clear();
          _newPaymentDescriptionController.clear();
          _newPaymentAmountController.clear();

          // Filling this list so that it knows how many people are in the group for the length.
          addPeopleYesOrNo = List.filled(peopleInGroup.length, true);

          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              // Rounding corners of the dialogue.
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),

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
                              minLines: 2,
                              // any number you need (It works as the rows for the textarea)
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
                              return (alphanumeric.hasMatch(value!) &&
                                  value.isNotEmpty)
                                  ? null
                                  : "Invalid Field";
                            },
                            decoration: const InputDecoration(
                              hintText: "Enter your number",
                              prefixIcon: Text("\$ "),
                              prefixIconConstraints:
                              BoxConstraints(minWidth: 0, minHeight: 0),
                            ),
                            inputFormatters: [
                              DecimalTextInputFormatter(decimalRange: 2)
                            ],
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CheckboxListTile(
                                        value: addPeopleYesOrNo[index],
                                        onChanged: (bool? value) {
                                          setState(() {
                                            addPeopleYesOrNo[index] = value!;
                                          });
                                          //addPeopleYesOrNo[index] = value!;
                                        },
                                        title: Text(peopleInGroup[index]));
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
                      costSplitCon.createPayment(
                          title: _newPaymentTitleController.text,
                          description: _newPaymentDescriptionController.text,
                          amount: _newPaymentAmountController.text,
                          whoNeedsToPay: peepsWhoNeedToPay);

                      // Close the alert dialog.
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  Widget paymentTile(CostSplitObject payment) {
    // var tileColor = Colors.teal[300];

    var tileColor = Colors.teal[300];

    if (payment.creator == uID &&
        payment.whoNeedsToPay.length == payment.whoHasPaid.length) {
      tileColor = Colors.green[400];
    } else if (payment.creator != uID && payment.whoHasPaid.contains(uID)) {
      tileColor = Colors.green[400];
    } else if (payment.creator != uID) {
      tileColor = Colors.red[400];
    }

    String? creatorName = 'You';
    String? creatorNameWithPresentTenseVerb = 'You are';

    if (payment.creator != uID) {
      creatorName = "${iDNameMap[payment.creator]}";
      creatorNameWithPresentTenseVerb = "${iDNameMap[payment.creator]} is";
    }

    return InkWell(
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onTap: () {
        // print("tapped on container");
        // print(title);
        showDialog(
            context: context,
            builder: (context) {
              return paymentTileMoreInfo(creatorName,
                  creatorNameWithPresentTenseVerb, payment, tileColor!);
            });
      },
      child: Ink(
        // Stretch container to fit it's children.
        //constraints: const BoxConstraints(maxHeight: double.infinity,),

        // Making it look pretty.
        decoration: BoxDecoration(
            color: tileColor,
            borderRadius: const BorderRadius.all(Radius.circular(20))),

        // Padding on all sides.
        padding: const EdgeInsets.all(17),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text for the title.
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        overflow: TextOverflow.ellipsis,
                        //maxLines: 1,
                        textAlign: TextAlign.left,
                        //notificationTitles[index],
                        payment.title,
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Colors.white),
                        )),
                  ),

                  // Spacing.
                  const SizedBox(
                    height: 2,
                  ),

                  // Text for the time.
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        textAlign: TextAlign.left,
                        //notificationTitles[index],
                        "@ ${TimeOfDay.fromDateTime(payment.time).format(context)} on ${payment.time.month}/${payment.time.day}/${payment.time.year}",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            //fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white),
                        )),
                  ),

                  // Spacing.
                  const SizedBox(
                    height: 2,
                  ),

                  // Text for the body.
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        textAlign: TextAlign.left,
                        //notificationTitles[index],
                        "$creatorName paid \$${double.parse(payment.amount).toStringAsFixed(2)}",
                        style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                            //fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.white),
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 2,
            ),
            Align(
              alignment: Alignment.center,
              child: doYouOweOrAreYouOwed(payment),
            ),
          ],
        ),
      ),
    );
  }

  Widget doYouOweOrAreYouOwed(CostSplitObject payment) {
    if (payment.creator == uID) {
      if (payment.whoHasPaid.length < payment.whoNeedsToPay.length) {
        return Text(
            textAlign: TextAlign.center,
            //notificationTitles[index],
            "You are\nowed\n\$${(double.parse(payment.amount) - (double.parse(payment.howMuchDoesEachPersonOwe) * (payment.whoHasPaid.length))).toStringAsFixed(2)}",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.white),
            ));
      } else {
        return Text(
            textAlign: TextAlign.center,
            //notificationTitles[index],
            "Everyone\nhas\npaid!",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.white),
            ));
      }
    } else {
      if (payment.whoHasPaid.contains(uID)) {
        return Text(
            textAlign: TextAlign.center,
            //notificationTitles[index],
            "You are\ngood!",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.white),
            ));
      } else {
        return Text(
            textAlign: TextAlign.center,
            //notificationTitles[index],
            "You owe\n${iDNameMap[payment.creator]}\n\$${double.parse(payment.howMuchDoesEachPersonOwe).toStringAsFixed(2)}",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.white),
            ));
      }
    }
  }

  Widget paymentTileMoreInfo(creatorName, creatorNameWithPresentTenseVerb,
      CostSplitObject payment, Color tileColor) {
    // var creatorIsOwed = (payment.whoNeedsToPay.length - payment.whoHasPaid.length) * double.parse(payment.howMuchDoesEachPersonOwe);

    List<String> peopleApartOfPayment = [];
    for (var id in payment.whoNeedsToPay) {
      peopleApartOfPayment.add("-${iDNameMap[id]!}");
    }

    // You are the creator of this payment and thus cannot settle it.
    return AlertDialog(
      // Setting the background color.
      backgroundColor: tileColor,

      // Rounding corners of the dialogue.
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),

      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text for the title.
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
                textAlign: TextAlign.left,
                //notificationTitles[index],
                payment.title,
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white),
                )),
          ),

          // Spacing.
          const SizedBox(
            height: 4,
          ),

          // Text for the time.
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
                textAlign: TextAlign.left,
                //notificationTitles[index],
                "@ ${TimeOfDay.fromDateTime(payment.time).format(context)} on ${payment.time.month}/${payment.time.day}/${payment.time.year}",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    //fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                )),
          ),

          // Spacing.
          const SizedBox(
            height: 4,
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
                textAlign: TextAlign.left,
                //notificationTitles[index],
                "Description: ${payment.description}",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    //fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                )),
          ),

          // Spacing.
          const SizedBox(
            height: 4,
          ),

          // Text for the body.
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
                textAlign: TextAlign.left,
                //notificationTitles[index],
                "$creatorName paid \$${double.parse(payment.amount).toStringAsFixed(2)}",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    //fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                )),
          ),

          // Spacing.
          const SizedBox(
            height: 4,
          ),

          // Text for the body.
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
                textAlign: TextAlign.left,
                //notificationTitles[index],
                "Everyone owes ${iDNameMap[payment.creator]}: \$${double.parse(payment.howMuchDoesEachPersonOwe).toStringAsFixed(2)}",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    //fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white),
                )),
          ),

          // Spacing.
          const SizedBox(
            height: 4,
          ),

          // People apart of payment.
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  textAlign: TextAlign.left,
                  //notificationTitles[index],
                  "Those who still need to pay:\n${peopleApartOfPayment.join('\n')}",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      //fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ))),

          const SizedBox(
            height: 4,
          ),

          // Text for the body.
          Align(
            alignment: Alignment.centerLeft,
            child: whoHasPaidText(payment),
          ),

          // Spacing.
          const SizedBox(
            height: 16,
          ),

          creatorVsNotCreatorVsSettled(payment),
        ],
      ),
    );
  }

  Widget whoHasPaidText(CostSplitObject payment) {
    List<String> whoHasPaidNameList = [];

    for (var id in payment.whoHasPaid) {
      whoHasPaidNameList.add("-${iDNameMap[id]!}");
    }

    if (payment.whoHasPaid.isEmpty) {
      return Text(
          textAlign: TextAlign.left,
          //notificationTitles[index],
          "No one has paid yet.",
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              //fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white),
          ));
    } else {
      return Text(
          textAlign: TextAlign.left,
          //notificationTitles[index],
          "People who have paid:\n${whoHasPaidNameList.join('\n')}",
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              //fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white),
          ));
    }
  }

  Widget completeVsNotCompletePayment(CostSplitObject payment) {
    if (payment.whoHasPaid.length == payment.whoNeedsToPay.length) {
      return Align(
        alignment: Alignment.center,
        child: Text(
            textAlign: TextAlign.center,
            //notificationTitles[index],
            "Complete Payment!",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            )),
      );
    } else {
      return Align(
        alignment: Alignment.center,
        child: Text(
            textAlign: TextAlign.center,
            //notificationTitles[index],
            "Incomplete Payments.",
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.white),
            )),
      );
    }
  }

  Widget creatorVsNotCreatorVsSettled(CostSplitObject payment) {
    if (payment.creator == uID) {
      return Column(
        children: [
          completeVsNotCompletePayment(payment),

          const SizedBox(
            height: 10,
          ),

          // People apart of payment.
          Align(
              alignment: Alignment.center,
              child: Text(
                  textAlign: TextAlign.left,
                  //notificationTitles[index],
                  "Delete this payment?",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ))),

          const SizedBox(
            height: 20,
          ),

          OverflowBar(
            alignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                height: 40,
                width: 100,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    //padding: const EdgeInsets.all(16.0),
                    //textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text('Yes'),
                  onPressed: () {
                    // print("Is this working?");

                    // Mark payment as paid
                    costSplitCon.deletePayment(payment);

                    // Exit the alert dialog.
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: 40,
                width: 100,
                child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red.shade600,
                      //padding: const EdgeInsets.all(16.0),
                      //textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ],
      );
    } else if (payment.whoHasPaid.contains(uID)) {
      return Column(
        children: [
          // Text for the title.
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
                textAlign: TextAlign.center,
                //notificationTitles[index],
                "This payment is settled.",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white),
                )),
          ),

          const SizedBox(
            height: 10,
          ),

          // People apart of payment.
          Align(
              alignment: Alignment.center,
              child: Text(
                  textAlign: TextAlign.left,
                  //notificationTitles[index],
                  "Unsettle this payment?",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ))),

          const SizedBox(
            height: 20,
          ),

          OverflowBar(
            alignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                height: 40,
                width: 100,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    //padding: const EdgeInsets.all(16.0),
                    //textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text('Okay'),
                  onPressed: () {
                    // print("Is this working?");

                    // Mark payment as paid
                    costSplitCon.unsettlePayment(payment);

                    // Exit the alert dialog.
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: 40,
                width: 100,
                child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red.shade600,
                      //padding: const EdgeInsets.all(16.0),
                      //textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          // Text for the title.
          Align(
            alignment: Alignment.center,
            child: Text(
                textAlign: TextAlign.center,
                //notificationTitles[index],
                "Settle this payment?",
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.white),
                )),
          ),

          const SizedBox(
            height: 16,
          ),

          OverflowBar(
            alignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                height: 40,
                width: 100,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    //padding: const EdgeInsets.all(16.0),
                    //textStyle: const TextStyle(fontSize: 20),
                  ),
                  child: const Text('Okay'),
                  onPressed: () {
                    // print("Is this working?");

                    // Mark payment as paid
                    costSplitCon.settlePayment(payment);

                    // Exit the alert dialog.
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(
                height: 40,
                width: 100,
                child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red.shade600,
                      //padding: const EdgeInsets.all(16.0),
                      //textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ),
            ],
          ),
        ],
      );
    }
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
  }
}