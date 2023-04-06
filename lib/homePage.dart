
import 'package:flutter/material.dart';

class homePage extends StatefulWidget {
  homePage({Key? key}) : super(key: key);

  @override
  State<homePage> createState() => _homePage();
}

class _homePage extends State<homePage> {
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Tasks",
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orange[700],
            title: const Text("Home")
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
          return Row(
            children: <Widget>[
              SizedBox(
                  width: constraints.maxWidth,
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
                                  child: Text('Scrollable 2 : Index $index'),
                                )
                              ));

                        }),
                  )),
            ],
          );
        });
  }
}