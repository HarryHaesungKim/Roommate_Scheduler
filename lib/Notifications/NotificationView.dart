import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roommates/Task/task.dart';

import '../theme.dart';

class NotificationView extends StatelessWidget {
  final Task notification;
  const NotificationView(this.notification, {super.key});
  static late MediaQueryData _mediaQueryData;

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    return Container(
      padding:
      EdgeInsets.symmetric(horizontal: (20 / 375.0) * _mediaQueryData.size.width),
      width: _mediaQueryData.size.width,
      margin: EdgeInsets.only(bottom: (12 / 375.0) * _mediaQueryData.size.width),
      child: Container(
        padding: const EdgeInsets.all(16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(notification.color),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  notification.title!,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),

                const SizedBox(
                  height: 12,
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.alarm,
                      color: Colors.grey[200],
                      size: 18,
                    ),
                    const SizedBox(width: 4),

                    // Text(
                    //   "${notification.startTime} - ${notification.endTime}",
                    //   style: GoogleFonts.lato(
                    //     textStyle:
                    //     TextStyle(fontSize: 13, color: Colors.grey[100]),
                    //   ),
                    // ),

                    // Spacing
                    const SizedBox(width: 12),

                    Text(
                      "${notification.date}",
                      style: GoogleFonts.lato(
                        textStyle:
                        TextStyle(fontSize: 13, color: Colors.grey[100]),
                      ),
                    ),

                  ],
                ),

                // Spacing
                const SizedBox(height: 12),


                Text(
                  notification.note!,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 15, color: Colors.grey[100]),
                  ),
                ),


              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),

          // RotatedBox(
          //   quarterTurns: 3,
          //   child: Text(
          //     notification.isCompleted == 1 ? "COMPLETED" : "TODO",
          //     style: GoogleFonts.lato(
          //       textStyle: TextStyle(
          //           fontSize: 10,
          //           fontWeight: FontWeight.bold,
          //           color: Colors.white),
          //     ),
          //   ),
          // ),

        ]),
      ),
    );
  }

  _getBGClr(int? no) {
    switch (no) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      default:
        return bluishClr;
    }
  }
}