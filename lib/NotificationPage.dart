import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationPage> {

  List<String> notificationTitles = ["Generic title 1", "Generic title 2", "Generic title 3"];
  List<DateTime> notificationTimes = [DateTime.now(), DateTime.now(), DateTime.now()];
  List<String> notificationBodies = ["Generic body 1 Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "Generic body 2", "Generic body 3"];

  Widget textWithStyle(input){
    return Text(
      textAlign: TextAlign.left,
      //notificationTitles[index],
      '$input',
      style: GoogleFonts.lato(
        textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: Colors.grey[100]
        ),
      )
    );
  }

  Widget notificationTile(title, time, body){
    return Container(

      // Stretch container to fit it's children.
      constraints: const BoxConstraints(
      maxHeight: double.infinity,),

      // Making it look pretty.
      decoration: BoxDecoration(
          color: Colors.teal[300],
          borderRadius: const BorderRadius.all(Radius.circular(20))
      ),

      // Padding on all sides.
      padding: const EdgeInsets.all(17),

      child: Column(
        children: [

          // Text for the title.
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
                textAlign: TextAlign.left,
                //notificationTitles[index],
                '$title',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                      color: Colors.white
                  ),
                )
            ),
          ),

          // Text for the time.
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
                textAlign: TextAlign.left,
                //notificationTitles[index],
                '$time',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      //fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.white
                  ),
                )
            ),
          ),

          // Spacing.
          const SizedBox(height: 4,),

          // Text for the body.
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
                textAlign: TextAlign.left,
                //notificationTitles[index],
                '$body',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                    //fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Colors.white
                  ),
                )
            ),
          ),

        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[700],
          title: const Text("Notifications"),

          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    // Pull up an alert dialog that allows Users to make an announcement to everyone in the group.
                  },
                  child: const Icon(
                    Icons.add_alert_outlined,
                    //size: 25,
                  ),
                )
            ),
          ],
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
                      itemCount: notificationTitles.length,

                      itemBuilder: (context, index) {
                        return notificationTile(notificationTitles[index], notificationTimes[index], notificationBodies[index]);
                      },

                      // Separates the items. Invisible with a sized box rather than a divider.
                      separatorBuilder: (BuildContext context, int index) => const SizedBox ( height : 10),

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