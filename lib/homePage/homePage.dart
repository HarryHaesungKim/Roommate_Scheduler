
import 'package:flutter/material.dart';
import 'package:roommates/Task/taskController.dart';
import 'package:roommates/groceriesPage.dart';
import 'package:roommates/homePage/addTask.dart';
import 'package:roommates/homePage/messagingPage.dart';
import 'package:roommates/theme.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class homePage extends StatefulWidget {
  homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePage();
}

class _homePage extends State<homePage> {
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  final _taskController = Get.put(taskController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tasks",
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orange[700],
            title: const Text("Home"),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => messagingPage()),
                      );                    },
                    child: Icon(
                        Icons.send
                    ),
                  )
              ),
            ],

        ),

        body: const Center(
          child: MyStatefulWidget()
        ),
      ),
    );
  }
}

// Copy and pasted code from https://api.flutter.dev/flutter/material/Scrollbar-class.html
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: <Widget>[
              addTaskBar(),
              SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight - 100,
                  // This vertical scroll view has primary set to true, so it is
                  // using the PrimaryScrollController. On mobile platforms, the
                  // PrimaryScrollController automatically attaches to vertical
                  // ScrollViews, unlike on Desktop platforms, where the primary
                  // parameter is required.
                  child: Scrollbar(
                    //thumbVisibility: true,
                    thickness: 10,
                    child: ListView.builder(
                        primary: true,
                        itemCount: 20,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            // Spacing between elements:
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Container(
                                  height: 100,
                                  //padding: const EdgeInsets.all(2),

                                  color: index.isEven
                                      ? Colors.amberAccent
                                      : Colors.blueAccent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text('Random task $index'),
                                  )
                              ));

                        }),
                  )),
            ],
          );
        });
  }
  scrollList() {
    return Container(
        margin: EdgeInsets.only(bottom: 500, left: 20),
        child: Scrollbar(
          // This vertical scroll view has primary set to true, so it is
          // using the PrimaryScrollController. On mobile platforms, the
          // PrimaryScrollController automatically attaches to vertical
          // ScrollViews, unlike on Desktop platforms, where the primary
          // parameter is required.
          //thumbVisibility: true,
          thickness: 10,
          child: ListView.builder(
              primary: true,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  // Spacing between elements:
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Container(
                        height: 100,
                        //padding: const EdgeInsets.all(2),

                        color: index.isEven
                            ? Colors.amberAccent
                            : Colors.blueAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Random task $index'),
                        )
                    ));

              }),
        )
    );
  }
  addTaskBar() {
    return Container(
      margin: EdgeInsets.only(bottom: 12, top: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingTextStyle,
              ),
              SizedBox(height: 10,),
              Text(
                "Today",
                style: headingTextStyle,
              ),
            ],
          ),
          ElevatedButton(
            child: Text('+ Add Task',),
            // onPressed: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(builder: (context) => addTask()),
            //   );

            onPressed: () {
                //await Get.to(addTask());
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addTask()),
                );
              },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.orange[700]!),
            ),
          ),
        ],
      ),
    );
  }
}