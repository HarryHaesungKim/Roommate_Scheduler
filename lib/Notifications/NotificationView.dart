import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../themeData.dart';
import 'NotificationObject.dart';
import 'NotificationController.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationView> {

  // The current user
  String? currUser = FirebaseAuth.instance.currentUser?.uid;

  // Controller
  final NotificationController notifCon = NotificationController();

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


  Widget notificationTile(title, DateTime time, body, type, id, creator){

    var tileColor = Colors.teal[300];

    if(type == "announcement"){
      tileColor = Colors.redAccent[200];
    }
    else if (type == "task"){
      tileColor = Colors.orangeAccent[200];
    }

    return InkWell(

      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),

      onTap: () {
        // print("tapped on container");
        // print(title);
        showDialog(context: context, builder: (context){
          return notificationTileDeleteAlertDialogue(context, id);
        });
      },

      child: Ink(

        // Stretch container to fit it's children.
        //constraints: const BoxConstraints(maxHeight: double.infinity,),

        // Making it look pretty.
        decoration: BoxDecoration(
            color: tileColor,
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

            // // Spacing.
            // const SizedBox(height: 4,),

            // Text for the time.
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  textAlign: TextAlign.left,
                  //notificationTitles[index],
                  "@ ${TimeOfDay.fromDateTime(time).format(context)} on ${time.month}/${time.day}/${time.year}",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      //fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white
                    ),
                  )
              ),
            ),

            // // Spacing.
            // const SizedBox(height: 4,),

            // Text for the creator.
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  textAlign: TextAlign.left,
                  //notificationTitles[index],
                  "From: $creator",
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      //fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white
                    ),
                  )
              ),
            ),

            // Spacing.
            const SizedBox(height: 2,),

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

  // Pulls up an alert dialog to create an announcement.
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
                          if (formKey.currentState!.validate()){
                            notifCon.createNotification(title: _newAnnouncementTitleController.text, body: _newAnnouncementBodyController.text, type: "announcement");
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

  // Pulls up an alert dialog to delete an announcement.
  Widget notificationTileDeleteAlertDialogue(BuildContext context, notificationId){

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
                // As of this moment, all announcements are shared, and if one user
                // deletes a notification, it deletes it from firebase and
                // no one can see it.

                final docUser = FirebaseFirestore.instance
                    .collection('Users')
                    .doc(currUser)
                    .collection('Notifications')
                .doc(notificationId);
                docUser.delete();

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
                }
            ),
          ),
        ],
      ),
    );
  }

  // Getting the notifications from firebase.
  Stream<List<NotificationObject>> readNotifications() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(currUser)
        .collection('Notifications')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => NotificationObject.fromJson(doc.data()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
        return StreamBuilder<List<NotificationObject>>(
          stream: readNotifications(),
          builder: (context, snapshot){
            if (snapshot.hasError){
              return Text('Something went wrong! ${snapshot.data}');
            }
            else if (snapshot.hasData){
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(currUser)
                      .snapshots(),
                  builder: (context, snapshot2){
                    if (snapshot.hasError){
                      return Text('Something went wrong! ${snapshot.data}');
                    }
                    else if (snapshot2.hasData){
                      final notifications = snapshot.data!;
                      final UserData = snapshot2.data!;
                      // Sorting by time.
                      notifications.sort((a, b) => b.time.compareTo(a.time));
                      return MaterialApp(
                          theme: showOption(UserData['themeBrightness']),
                          home: Scaffold(
                            appBar: AppBar(
                              backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),
                              title: const Text("Notifications Log"),
                              actions: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {

                                    // Pulls up an alert dialogue that asks if you want to clear all notifications.
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {

                                        // set up the buttons
                                        Widget cancelButton = TextButton(
                                          child: const Text("Cancel"),
                                          onPressed:  () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                        Widget deleteAllButton = TextButton(
                                          child: const Text("Delete All"),
                                          onPressed:  () async {

                                            // Exit the alert dialog.
                                            Navigator.pop(context);

                                            // delete the entire collection.
                                            final instance = FirebaseFirestore.instance;
                                            final batch = instance.batch();
                                            var collection = instance.collection('Users').doc(currUser).collection('Notifications');
                                            var snapshots = await collection.get();
                                            for (var doc in snapshots.docs) {
                                              batch.delete(doc.reference);
                                            }
                                            await batch.commit();

                                          },
                                        );

                                        return AlertDialog(
                                          scrollable: true,
                                          title: const Text("Delete all notifications?"),
                                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                                          actions: [
                                            deleteAllButton,
                                            cancelButton,
                                          ],
                                        );
                                      },
                                    );

                                  },
                                )
                              ],
                            ),
                            floatingActionButton: FloatingActionButton(
                                backgroundColor: setAppBarColor(UserData['themeColor'], UserData['themeBrightness']),
                                onPressed: () async {
                                  showDialog(context: context, builder: (context){
                                    return announcementAlertDialogue(context);
                                  });
                                },child: const Icon(Icons.add_alert_outlined)
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
                                          itemCount: notifications.length,

                                          itemBuilder: (context, index) {

                                            // Extra padding at the top (for aesthetic purposes).
                                            if (index == 0) {
                                              return Padding(

                                                  padding: const EdgeInsets.fromLTRB(
                                                      10, 5, 10, 0),

                                                  // The task tiles.
                                                  child: notificationTile(
                                                      notifications[index].title,
                                                      notifications[index].time,
                                                      notifications[index].body,
                                                      notifications[index].type,
                                                      notifications[index].id,
                                                      notifications[index].creator)
                                              );
                                            }

                                            // Adding extra padding at the last item for the button (so that it doesn't overlap).
                                            else if (index == notifications.length - 1) {
                                              return Padding(

                                                  padding: const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 75),

                                                  // The task tiles.
                                                  child: notificationTile(
                                                      notifications[index].title,
                                                      notifications[index].time,
                                                      notifications[index].body,
                                                      notifications[index].type,
                                                      notifications[index].id,
                                                      notifications[index].creator)
                                              );
                                            }

                                            else {
                                              return Padding(

                                                // Spacing between elements:
                                                  padding: const EdgeInsets.fromLTRB(
                                                      10, 0, 10, 0),

                                                  // The task tiles.
                                                  child: notificationTile(
                                                      notifications[index].title,
                                                      notifications[index].time,
                                                      notifications[index].body,
                                                      notifications[index].type,
                                                      notifications[index].id,
                                                      notifications[index].creator));
                                            }
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
                    }
                    else{
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
              );

            }

            // Loading.
            else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
  }
}