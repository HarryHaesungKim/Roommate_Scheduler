import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:roommates/groceriesPage/groceriesPage.dart';
import 'package:roommates/groceriesPage/groceriesPagedata.dart';

import '../Group/groupController.dart';
import '../Task/input_field.dart';
import '../theme.dart';
import 'package:roommates/groceriesPage/groceriesPageController.dart';

import 'GroceriesPageDatabase.dart';

class addGroceries extends StatefulWidget {
  @override
  _AddGroceriesPageState createState() => _AddGroceriesPageState();

}

class _AddGroceriesPageState extends State<addGroceries> {
  final GroceriesPageController _groceriesPageController = Get.find<GroceriesPageController>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final List<TextEditingController> _splitcontrollers = [];
  final _groupController = Get.put(groupController());
  String? uID = FirebaseAuth.instance.currentUser?.uid;
  late List<String> peopleInGroup = [];
  late List<bool> addPeopleYesOrNo = List.filled(peopleInGroup.length, false);
  late List<String> peopleinGroupIDs = [];
  List<String> receiverids = [];
  List<String> receiverNames = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }
  DateTime _selectedDate = DateTime.now();
  String? _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();

  int _selectedColor = 0;

  int _selectedRemind = 5;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];
  String _selectedAssigness = "";
  List<String> AssigneesList = [
    "Harry Kim",
    "Jianwei Cheng",
    "Braden Morfin",
    "Qimeng Chao",
  ];
  String _selectedSplit = "Equal";
  List<String> splitList = [
    "Equal"
  ];

  @override
  void initState() {
    super.initState();
  }
  void buildGroupChatList() async {
    //user id
    String? uID = FirebaseAuth.instance.currentUser?.uid;
    peopleInGroup = await _groupController.getUsersInGroup(uID!);
    peopleinGroupIDs = await _groupController.getUserIDsInGroup(uID!);
  }

  @override
  Widget build(BuildContext context) {
    //Below shows the time like Sep 15, 2021
    buildGroupChatList();
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, now.minute, now.second);
    final format = DateFormat.jm();
    _amountController.text = "0";
    return Scaffold(
      //backgroundColor: context.theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: const Text("Add Groceries"),
      ),
      backgroundColor:  Color.fromARGB(255, 227, 227, 227),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputField(
                title: "Title",
                hint: "Enter title here.",
                controller: _titleController,
              ),
              InputField(
                  title: "Amount",
                  hint: "Enter Amount",
                  controller: _amountController),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: (Icon(
                    Icons.calendar_month_sharp,
                    color: Colors.grey,
                  )),
                  onPressed: () {
                    //_showDatePicker(context);
                    _getDateFromUser();
                  },
                ),
              ),
              InputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: Row(
                  children: [
                    DropdownButton<String>(
                      //value: _selectedRemind.toString(),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                        iconSize: 32,
                        elevation: 4,
                        style: subTitleTextStle,
                        underline: Container(height: 0),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedRemind = int.parse(newValue!);
                          });
                        },
                        items: remindList
                            .map<DropdownMenuItem<String>>((int value) {
                          return DropdownMenuItem<String>(
                            value: value.toString(),
                            child: Text(value.toString()),
                          );
                        }).toList()),
                    SizedBox(width: 6),
                  ],
                ),
              ),
              SizedBox(
                height: 18.0,
              ),
              Text(
                "Paid Name",
                style: titleTextStle,
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text('Selects Assigness'),
                    onPressed: () async{
                      await selectAssignessDialog(context);
                      setState(() {});
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.orange[700]!),
                    ),
                  ),
                ],
              ),
              Text(
                "Split",
                style: titleTextStle,
              ),
              SizedBox(
                height: 20.0,
              ),
              // InputField(
              //   title: "Split",
              //   hint: "$_selectedSplit",
              //   widget: Row(
              //     children: [
              //       DropdownButton<String>(
              //         //value: _selectedRemind.toString(),
              //           icon: Icon(
              //             Icons.keyboard_arrow_down,
              //             color: Colors.grey,
              //           ),
              //           iconSize: 32,
              //           elevation: 4,
              //           style: subTitleTextStle,
              //           underline: Container(height: 0),
              //           onChanged: (String? newValue) {
              //             setState(() {
              //               _selectedSplit = newValue!;
              //             });
              //           },
              //           items: splitList
              //               .map<DropdownMenuItem<String>>((String value) {
              //             return DropdownMenuItem<String>(
              //               value: value.toString(),
              //               child: Text(value.toString()),
              //             );
              //           }).toList()),
              //       SizedBox(width: 6),
              //     ],
              //   ),
              // ),
          Container(
            color: const Color.fromARGB(255, 227, 227, 227),
            child: SizedBox(
              width: double.maxFinite,
              height: 150,
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 5,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: receiverNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    _splitcontrollers.add(new TextEditingController());
                    _splitcontrollers[index].text = (double.parse(_amountController.text)/receiverNames.length).toPrecision(2).toString();
                    return Row(
                      children: <Widget>[
                        Expanded(child: Text(receiverNames[index]),),
                        Expanded(
                          child:TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              isDense: false,                      // Added this
                              contentPadding: EdgeInsets.all(3),
                            ),
                            inputFormatters: [PercentageTextInputFormatter()],
                            keyboardType: TextInputType.number,
                            controller: _splitcontrollers[index],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    child: Text('Create'),
                    onPressed: () {
                      _validateInputs();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.orange[700]!),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> selectAssignessDialog(BuildContext context) async {
    return await showDialog(context: context, builder: (context) {
      // Replaced textEditingController with _newChatNameController.
      // final TextEditingController textEditingController = TextEditingController();
      bool? isChecked = false;
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          title: const Text("Select who needs to be assigned"),
          content: Form(
              key: formKey,
              child: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Text
                    const Align(
                      alignment: Alignment.centerLeft,
                      // child: Text(
                      //   "Select Group Members",
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     fontSize: 18,
                      //   ),
                      // ),
                    ),

                    // Padding
                    const SizedBox(height: 20),

                    // Checklist
                    Container(
                      // Can change color.
                      color: const Color.fromARGB(255, 227, 227, 227),
                      child: SizedBox(
                        width: double.maxFinite,
                        height: 150,
                        child: Scrollbar(
                          thumbVisibility: true,
                          thickness: 5,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: peopleInGroup.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CheckboxListTile(
                                  value: addPeopleYesOrNo[index],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      addPeopleYesOrNo[index] = value!;
                                    });
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
          actions: <Widget>[
            TextButton(
              child: const Text("Okay"),
              onPressed: () async {
                receiverids = [];
                receiverNames = [];
                // If text input is empty or not valid or no group members are selected, don't let it proceed.
                // Switch over to ChatPage.
                if (formKey.currentState!.validate() &&
                    addPeopleYesOrNo.contains(true)) {
                  for (int i = 0; i < addPeopleYesOrNo.length; i++) {
                    if (addPeopleYesOrNo[i]) {
                      receiverids.add(peopleinGroupIDs[i]);
                      receiverNames.add(peopleInGroup[i]);
                    }
                  }
                  Navigator.of(context);
                  Navigator.pop(context);
                }
                // // TODO: Need some way to warn user that at least one checkbox needs to be checked.
              },
            ),
          ],
        );
      });
    });
  }

  _validateInputs() {
    if (_titleController.text.isNotEmpty && _amountController.text.isNotEmpty) {
      _splitBilling();
      Get.back();
    } else if (_titleController.text.isEmpty || _amountController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      print("SOMETHING ERROR");
    }
  }
  _splitBilling() async{
    double individualAmount = 0;
    for(int i = 0; i < receiverids.length; i++){
      individualAmount =(double.parse(_amountController.text)*double.parse(_splitcontrollers[i].text)*0.01);
      _addGrocerieToDB(receiverids[i], individualAmount.toPrecision(2), _splitcontrollers[i].text);
    }
  }

  _addGrocerieToDB(String assigness, double individualAmount, String splitamount) async {
    String groupID = await _groupController.getGroupIDFromUser(uID!);
    await _groceriesPageController.addGroceries(groupID,
      groceries: Groceries(
        // amount: double.parse(_amountController.text),
        amount: individualAmount,
        title: _titleController.text.toString(),
        date: DateFormat.yMd().format(_selectedDate),
        remind: _selectedRemind,
        paidName: assigness,
        split: splitamount,
      ),
    );

  }
  _colorChips() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        "Color",
        style: titleTextStle,
      ),
      SizedBox(
        height: 8,
      ),
      Wrap(
        children: List<Widget>.generate(
          3,
              (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                      ? pinkClr
                      : yellowClr,
                  child: index == _selectedColor
                      ? Center(
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 18,
                    ),
                  )
                      : Container(),
                ),
              ),
            );
          },
        ).toList(),
      ),
    ]);
  }


  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  // _getTimeFromUser({required bool isStartTime}) async {
  //   var _pickedTime = await _showTimePicker();
  //   print(_pickedTime.format(context));
  //   String? _formatedTime = _pickedTime.format(context);
  //   print(_formatedTime);
  //   if (_pickedTime == null)
  //     print("time canceld");
  //   else if (isStartTime)
  //     setState(() {
  //       _startTime = _formatedTime;
  //     });
  //   else if (!isStartTime) {
  //     setState(() {
  //       _endTime = _formatedTime;
  //     });
  //     //_compareTime();
  //   }
  // }

  _showTimePicker() async {
    return showTimePicker(
      initialTime: TimeOfDay(
          hour: int.parse(_startTime!.split(":")[0]),
          minute: int.parse(_startTime!.split(":")[1].split(" ")[0])),
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
    );
  }

  _getDateFromUser() async {
    final DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    }
  }
}