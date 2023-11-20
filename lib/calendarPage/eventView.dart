
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roommates/calendarPage/event.dart';
import '../theme.dart';

class eventView extends StatelessWidget {
  final Event event;
  const eventView(this.event, {super.key});
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
          color: Colors.black87,
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children:[
                    Icon(
                      Icons.event,
                      color: Colors.grey[200],
                      size: 30,
                    ),
                     SizedBox(
                      width: _mediaQueryData.size.width/50,
                    ),
                    Flexible(
                      child: Text(
                      "Event: ${event.title!}",
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
                  event.note!,
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.black87.withOpacity(0.7),
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