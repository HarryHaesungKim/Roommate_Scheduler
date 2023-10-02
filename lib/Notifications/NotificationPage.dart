import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'NotificationObject.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationPage> {

  List<String> notificationTitles = ["Generic title 1", "Generic title 2", "Generic title 3"];
  List<DateTime> notificationTimes = [DateTime.now(), DateTime.now(), DateTime.now()];
  List<String> notificationBodies = ["Generic body 1 Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", "Generic body 2", "Generic body 3"];

  // Text controllers for creating a new announcement pop-up.
  final TextEditingController _newAnnouncementTitleController = TextEditingController();
  final TextEditingController _newAnnouncementBodyController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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

  Widget notificationTile(title, DateTime time, body){

    return InkWell(

      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      onTap: () {
        // print("tapped on container");
        // print(title);
        showDialog(context: context, builder: (context){
          return notificationTileDeleteAlertDialogue(context);
        });
      },

      child: Ink(

        // Stretch container to fit it's children.
        //constraints: const BoxConstraints(maxHeight: double.infinity,),

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
                  "@  ${TimeOfDay.fromDateTime(time).format(context)} on ${time.month}/${time.day}/${time.year}",
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
      ),

    );
  }

  Widget announcementAlertDialogue(BuildContext context){

    _newAnnouncementTitleController.clear();
    _newAnnouncementBodyController.clear();

    return AlertDialog(

      // Rounding corners of the dialogue.
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),

      title: const Text("Create Announcement"),
      content: Form(
          key: formKey,
          child: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                // Announcement title input.
                TextFormField(
                  controller: _newAnnouncementTitleController,
                  validator: (value) {
                    return value!.isNotEmpty ? null : "Invalid Field";
                  },
                  decoration: const InputDecoration(
                    hintText: "Enter title",
                    // isDense: false,
                    // contentPadding: EdgeInsets.symmetric(horizontal: 11, vertical: 0),
                    // errorText: "Need a title",
                  ),
                ),

                // Padding
                const SizedBox(height: 30),

                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: TextFormField(
                    minLines: 6, // any number you need (It works as the rows for the textarea)
                    keyboardType: TextInputType.multiline,
                    maxLines: null,

                    // Controller stuff.
                    controller: _newAnnouncementBodyController,
                    validator: (value) {
                      return value!.isNotEmpty ? null : "Invalid Field";
                    },

                    // Decorations
                    decoration: const InputDecoration(
                        hintText: "Enter message",
                        border: OutlineInputBorder(),
                    ),

                  ),
                ),

                // Padding
                const SizedBox(height: 30),

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
                          // TODO: Do cool firebase shit

                          createNotification(title: _newAnnouncementTitleController.text, body: _newAnnouncementBodyController.text);

                          if (formKey.currentState!.validate()){
                            Navigator.pop(context);
                          }
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
                          }
                      ),
                    ),
                  ],
                ),

              ],
            ),
          )),
    );
  }

  Widget notificationTileDeleteAlertDialogue(BuildContext context){

    return AlertDialog(

      // Rounding corners of the dialogue.
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))
      ),

      title: const Text("Delete notification?"),
      content: OverflowBar(
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
                // TODO: Do cool firebase shit

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
                }
            ),
          ),
        ],
      ),
    );
  }

  String? validatePassword(String value) {
    if (!(value.length > 5) && value.isNotEmpty) {
      return "Password should contain more than 5 characters";
    }
    return null;
  }

  Future createNotification({required String title, required String body}) async {
    // Reference to Document.

    final notification = FirebaseFirestore.instance.collection('Notifications').doc();

    final announcement = NotificationObject(
        id: notification.id,
        title: _newAnnouncementTitleController.text,
        body: _newAnnouncementBodyController.text,
        time: DateTime.now(),
        type: "announcement"
    );

    // Create document and write data to firebase.
    await notification.set(announcement.toJson());

  }

  Stream<List<NotificationObject>> readNotifications() => FirebaseFirestore.instance
      .collection('Notifications')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => NotificationObject.fromJson(doc.data())).toList());

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
                    // print("working");
                    showDialog(context: context, builder: (context){
                      return announcementAlertDialogue(context);
                    });
                  },
                  child: const Icon(
                    Icons.add_alert_outlined,
                    //size: 25,
                  ),
                )
            ),
          ],
        ),

        body: StreamBuilder<List<NotificationObject>>(
          stream: readNotifications(),
          builder: (context, snapshot){
            if (snapshot.hasError){
              return Text('Something went wrong! ${snapshot.data}');
            }
            else if (snapshot.hasData){
              final notifications = snapshot.data!;

              // Sorting by time.
              notifications.sort((a, b) => a.time.compareTo(b.time));

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
                            //itemCount: _notificationsController.notificationsList.length,
                            itemCount: notifications.length,

                            itemBuilder: (context, index) {
                              return notificationTile(notifications[index].title, notifications[index].time, notifications[index].body);
                            },

                            // Separates the items. Invisible with a sized box rather than a divider.
                            separatorBuilder: (BuildContext context, int index) => const SizedBox ( height : 10),

                          ),
                        ),
                      ],
                    );
                  })
              );

            }

            else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

          },
        )
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