import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class notificationPage extends StatefulWidget {
  notificationPage({Key? key}) : super(key: key);

  @override
  State<notificationPage> createState() => _notificationPage();
}

class _notificationPage extends State<notificationPage> {
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  List<String> notificationTitles = ["Generic title 1", 'Generic title 2', "Generic title 3"];

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[700],
          title: const Text("Notifications"),
        ),

        body: Center(
            child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: [
                  SizedBox(
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,

                    child: ListView.separated(
                      padding: const EdgeInsets.all(8),

                      primary: true,
                      //itemCount: _notificationsController.notificationsList.length,
                      itemCount: 30,

                      itemBuilder: (context, index) {
                        return Container(
                            height: 50,
                            //color: Colors.amber[400],
                            alignment: Alignment.centerLeft,

                            decoration: BoxDecoration(
                              color: Colors.amber[400],
                              borderRadius: BorderRadius.all(Radius.circular(20))
                            ),

                            child: Align(
                              alignment: Alignment.centerLeft,
                                child: Text(
                                  textAlign: TextAlign.left,
                                  //notificationTitles[index],
                                  '$index',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.grey[100]
                                    ),
                                  ),
                                )
                            ),
                        );
                      },

                      // Separates the items. Invisible with a sized box rather than a divider.
                      separatorBuilder: (BuildContext context, int index) => const SizedBox ( height : 25),

                    ),
                  ),
                ],
              );
            })
        ),

      ),
    );

    // return Scaffold(
    //   backgroundColor:  Color.fromARGB(255, 227, 227, 227),
    //   body: Padding(
    //     padding: const EdgeInsets.only(bottom: 25),
    //     child: Align(
    //       alignment: Alignment.bottomCenter,
    //       child: Text('Notification Page',
    //         style: optionStyle,),
    //     ),
    //   ),
    // );
  }
}