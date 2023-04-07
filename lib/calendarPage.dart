import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class calendarPage extends StatefulWidget {
  calendarPage({Key? key}) : super(key: key);

  @override
  State<calendarPage> createState() => _calendarPage();
}

class _calendarPage extends State<calendarPage> {
  late CalendarController _controller;
  TextStyle dayStyle(FontWeight fontWeight){
    return TextStyle(color: Color(0xff30384c), fontWeight: fontWeight);
  }
  Container taskList(String title, String description, IconData iconImg, Color iconColor){
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Icon(
            iconImg,
            //CupertinoIcons.check_mark_circled_solid,
            color: iconColor,
            size: 30,
          ),
          Container(
            padding: EdgeInsets.only(left:10, right: 10),
            width: MediaQuery.of(context).size.width*0.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style:(
                    TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    )
                ),
                ),
                SizedBox(height: 10,),
                Text(description, style:(
                    TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.white
                    )
                ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  void initState(){
    _controller = CalendarController();
  }
  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30,),
              TableCalendar(
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  weekdayStyle: dayStyle(FontWeight.normal),
                  weekendStyle: dayStyle(FontWeight.normal),
                  selectedColor: Color(0xff30374b),
                  todayColor: Colors.orange.shade700,
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: Color(0xff30384c),
                    fontWeight: FontWeight.bold,
                    fontSize: 16
                  ),
                  weekendStyle: TextStyle(
                      color: Color(0xff30384c),
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                  // dowTextBuilder: (date, locale){
                  //   return DateFormate.E(locale).f
                  // }

                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                      color: Color(0xff30384c),
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Color(0xff30384c),
                  ),
                  rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: Color(0xff30384c),
                ),

                ),
                calendarController: _controller,),
              SizedBox(height:20,),
              Container(
                padding: EdgeInsets.only(left: 30),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular((50)), topRight: Radius.circular(50)),
                  color: Colors.orange.shade700,
                ),
                child:Stack(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(top: 50),
                            child: Text("Today", style: TextStyle(
                                color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold
                            ),
                            ),
                        ),
                        taskList("Task 1", "some description about the task", CupertinoIcons.check_mark_circled_solid, Colors.green.shade700),
                        taskList("Task 2", "some description about the task", CupertinoIcons.clock_solid, Colors.red),
                        taskList("Task 3", "some description about the task", CupertinoIcons.check_mark_circled_solid, Colors.green.shade700),
                        taskList("Task 4", "some description about the task", CupertinoIcons.check_mark_circled_solid, Colors.green.shade700),

                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Color(0xff30384c)
                            ],
                            stops: [
                              0.0,
                              1.0
                            ],
                          )
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      right: 20,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(90)),
                          color: Color(0xff30384c),
                          boxShadow: [BoxShadow(color: Colors.black38,blurRadius: 30)],
                        ),
                        child: Text("+", style: TextStyle(color: Colors.white, fontSize: 40)),
                      ),
                    ),

                  ],
                )
              ),
            ],

          ),
        ),
      ),
    );
  }
}
