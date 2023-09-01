import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:roommates/groceriesPage/groceriesPagedata.dart';

import '../theme.dart';

class groceriesView extends StatelessWidget {
  final Groceries groceries;
  groceriesView(this.groceries);
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
        padding: EdgeInsets.all(16),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      groceries.title!,
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(width: _mediaQueryData.size.width*0.2),
                    Text(
                      "${groceries.date}",
                      style: GoogleFonts.lato(
                        textStyle:
                        TextStyle(fontSize: 13, color: Colors.grey[100]),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    SizedBox(width: _mediaQueryData.size.width*0.5),
                    Text(
                      "${groceries.amount} \$",
                      style: GoogleFonts.lato(
                        textStyle:
                        TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 0),
                Text(
                  groceries.id!,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(fontSize: 13, color: Colors.grey[100]),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
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