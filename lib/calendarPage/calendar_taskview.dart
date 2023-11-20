import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roommates/Task/TaskObject.dart';

import '../theme.dart';

class calendar_taskView extends StatelessWidget {
  final TaskObject task;
  const calendar_taskView(this.task, {super.key});
  static late MediaQueryData _mediaQueryData;

  @override
  Widget build(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    return Container(
      padding:
      EdgeInsets.symmetric(horizontal: (10 / 375.0) * _mediaQueryData.size.width),
      width: _mediaQueryData.size.width,
      child: Container(
        padding: const EdgeInsets.all(16),
        //  width: SizeConfig.screenWidth * 0.78,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getBGClr(task.color),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children:[
                    Icon(
                      Icons.task,
                      color: Colors.grey[200],
                      size: 30,
                    ),
                    SizedBox(
                      width: _mediaQueryData.size.width/100,
                    ),
                    Flexible(
                      child: Text(
                      "Task: ${task.title!}",
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    ),

                  ],

                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "${task.startTime} - ${task.endTime}",
                  style: GoogleFonts.lato(
                    textStyle:
                    TextStyle(fontSize: 13, color: Colors.grey[100]),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  task.note!,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 15, color: Colors.white),
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
          RotatedBox(
            quarterTurns: 3,
            child: Text(
              task.isCompleted == 1 ? "COMPLETED" : "TODO",
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
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