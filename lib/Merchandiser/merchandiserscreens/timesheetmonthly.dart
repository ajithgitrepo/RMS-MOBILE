import 'dart:convert';
import'package:merchandising/api/timesheetmonthly.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merchandising/Constants.dart';
import 'package:intl/intl.dart';
import 'package:merchandising/api/timesheetapi.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/Time Sheet.dart';
import 'package:merchandising/main.dart';
import 'package:merchandising/api/leavestakenapi.dart';


List<dynamic>nonnulldateslist=[];
class month {
  static List<String> dates;
}

var listOfDates = new List<String>.generate(
    daysInMonth(DateTime(int.parse(DateFormat('yyyy').format(DateTime.now())),
        int.parse(DateFormat('MM').format(DateTime.now())))),
    (i) => "${DateFormat('MMMM').format(DateTime.now())} ${'${i + 1}'}");

int daysInMonth(DateTime date) {
  var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
  var firstDayNextMonth = new DateTime(firstDayThisMonth.year,
      firstDayThisMonth.month + 1, firstDayThisMonth.day);
  return firstDayNextMonth.difference(firstDayThisMonth).inDays;
}

class Timesheetmonthly extends StatefulWidget {
  @override
  _TimesheetmonthlyState createState() => _TimesheetmonthlyState();
}

class _TimesheetmonthlyState extends State<Timesheetmonthly> {

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
        decoration: BoxDecoration(
            color: pink, borderRadius: BorderRadius.circular(10.00)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              currentuser.roleid==2?Row(
                mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
                children: [
                 SizedBox(
                    width: MediaQuery.of(context).size.width/1.7,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Select All",
                        style: TextStyle(fontSize: 16,color: orange,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      print(alldateselected);
                      if(alldateselected){
                        setState(() {
                          alldateselected=false;
                          for(int i=0;i<dataofdates.length;i++){
                            int index = listOfDates.indexOf("${DateFormat('MMMMd').format(DateTime.parse(dataofdates[i]))}");
                            selecteddates[index]=false;
                          }
                        });
                      }else{
                        setState(() {
                          alldateselected=true;
                          for(int i=0;i<dataofdates.length;i++){
                            int index = listOfDates.indexOf("${DateFormat('MMMMd').format(DateTime.parse(dataofdates[i]))}");
                            selecteddates[index]=true;
                          }
                        });
                      }
                    },
                    child: Icon(
                      alldateselected ==
                          true
                          ? CupertinoIcons
                          .check_mark_circled_solid
                          : CupertinoIcons
                          .xmark_circle_fill,
                      color:  alldateselected ==
                          true
                          ? orange
                          : Colors
                          .grey,
                      size: 30,
                    ),
                  ),
                ],
              ):SizedBox(),
              TMmonthly.day1.length != 0
                  ? Column(
                    children: [
                      Customtimesheetheader(index: 0,),
                      CustomTimesheetWidget(
                        inputdata: TMmonthly.day1,
                      ),
                    ],
                  )
                  :TMmonthly1.day1.length!=0?Column(children: [
                    Customtimesheetheader(index: 0),
                CustomLeaveTypeWidget(inputdata: TMmonthly1.day1),

              ],):SizedBox(),
              TMmonthly.day2.length != 0
                  ? Column(
                    children: [
                      Customtimesheetheader(index: 1,),
                      CustomTimesheetWidget(
                        inputdata: TMmonthly.day2,
                      )
                    ],
                  ):TMmonthly1.day2.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 1),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day2),
                ],
              ) : SizedBox(),

              TMmonthly.day3.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 2),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day3,
                  )
                ],
              ):TMmonthly1.day3.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 2),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day3),
                ],
              ) : SizedBox(),

              TMmonthly.day4.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 3),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day4,
                  )
                ],
              ):TMmonthly1.day4.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 3),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day4),
                ],
              ) : SizedBox(),

              TMmonthly.day5.length != 0
                  ?  Column(
                children: [
                  Customtimesheetheader(index: 4),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day5,
                  )
                ],
              ):TMmonthly1.day5.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 4),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day5),
                ],
              ) : SizedBox(),

              TMmonthly.day6.length != 0
                  ?  Column(
                children: [
                  Customtimesheetheader(index: 5),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day6,
                  )
                ],
              ):TMmonthly1.day6.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 5),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day6),
                ],
              ) : SizedBox(),




              TMmonthly.day7.length != 0
                  ?  Column(
                children: [
                  Customtimesheetheader(index: 6),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day7,
                  )
                ],
              ):TMmonthly1.day7.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 6),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day7),
                ],
              ) : SizedBox(),

              TMmonthly.day8.length != 0
                  ?  Column(
                children: [
                  Customtimesheetheader(index: 7),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day8,
                  )
                ],
              ):TMmonthly1.day8.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 7),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day8),
                ],
              ) : SizedBox(),

              TMmonthly.day9.length != 0
                  ?  Column(
                children: [
                  Customtimesheetheader(index: 8),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day9,
                  )
                ],
              ):TMmonthly1.day9.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 8),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day9),
                ],
              )
                  : SizedBox(),

              TMmonthly.day10.length != 0
                  ?  Column(
                children: [
                  Customtimesheetheader(index: 9),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day10,
                  )
                ],
              ):TMmonthly1.day10.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 9),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day10),
                ],
              )
                  : SizedBox(),

              TMmonthly.day11.length != 0
                  ?  Column(
                children: [
                  Customtimesheetheader(index: 10),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day11,
                  )
                ],
              ):TMmonthly1.day11.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 10),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day11),
                ],
              )
                  : SizedBox(),

              TMmonthly.day12.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 11),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day12,
                  )
                ],
              ):TMmonthly1.day12.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 11),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day12),
                ],
              )
                  : SizedBox(),

              TMmonthly.day13.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 12),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day13,
                  )
                ],
              ):TMmonthly1.day13.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 12),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day13),
                ],
              )
                  : SizedBox(),

              TMmonthly.day14.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 13),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day14,
                  )
                ],
              ):TMmonthly1.day14.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 13),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day14),
                ],
              )
                  : SizedBox(),

              TMmonthly.day15.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 14),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day15,
                  )
                ],
              ):TMmonthly1.day15.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 14),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day15),
                ],
              )
                  : SizedBox(),

              TMmonthly.day16.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 15),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day16,
                  )
                ],
              ):TMmonthly1.day16.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 15),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day16),
                ],
              )
                  : SizedBox(),

              TMmonthly.day17.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 16),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day17,
                  )
                ],
              )/*:TMmonthly1.day17.length!=0?Column(
                children: [
                  Customtimesheetheader(index: 16),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day17),
                ],
              )*/
                  : SizedBox(),

              TMmonthly.day18.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 17),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day18,
                  )
                ],
              ):TMmonthly1.day18.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 17),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day18),
                ],
              )
                  : SizedBox(),

              TMmonthly.day19.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 18),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day19,
                  )
                ],
              ):TMmonthly1.day19.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 18),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day19),
                ],
              )
                  : SizedBox(),

              TMmonthly.day20.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 19),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day20,
                  )
                ],
              ):TMmonthly1.day20.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 19),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day20),
                ],
              )
                  : SizedBox(),

              TMmonthly.day21.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 20),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day21,
                  )
                ],
              ):TMmonthly1.day21.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 20),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day21),
                ],
              )
                  : SizedBox(),

              TMmonthly.day22.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 21),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day22,
                  )
                ],
              ):TMmonthly1.day22.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 21),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day22),
                ],
              )
                  : SizedBox(),

              TMmonthly.day23.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 22),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day23,
                  )
                ],
              ):TMmonthly1.day23.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 22),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day23),
                ],
              )
                  : SizedBox(),

              TMmonthly.day24.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 23),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day24,
                  )
                ],
              ):TMmonthly1.day24.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 23),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day24),
                ],
              )
                  : SizedBox(),

              TMmonthly.day25.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 24),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day25,
                  )
                ],
              ):TMmonthly1.day25.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 24),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day25),
                ],
              )
                  : SizedBox(),

              TMmonthly.day26.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 25),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day26,
                  )
                ],
              ):TMmonthly1.day26.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 25),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day26),
                ],
              )
                  : SizedBox(),

              TMmonthly.day27.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 26),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day27,
                  )
                ],
              ):TMmonthly1.day27.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 26),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day27),
                ],
              )
                  : SizedBox(),

              TMmonthly.day28.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 27),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day28,
                  )
                ],
              ):TMmonthly1.day28.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 27),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day28),
                ],
              )
                  : SizedBox(),

              TMmonthly.day29.length != 0
                  ? listOfDates.length > 28
                      ? Column(
                children: [
                  Customtimesheetheader(index: 28),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day29,
                  )
                ],
              ):TMmonthly1.day29.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 28),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day29),
                ],
              )
                      : SizedBox()
                  : SizedBox(),
              TMmonthly.day30.length != 0
                  ? listOfDates.length > 29
                      ?Column(
                children: [
                  Customtimesheetheader(index: 29),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day30,
                  )
                ],
              ):TMmonthly1.day30.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 29),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day30),
                ],
              )
                      : SizedBox()
                  : SizedBox(),

              TMmonthly.day31.length != 0
                  ? listOfDates.length > 30
                      ? Column(
                children: [
                  Customtimesheetheader(index: 30),
                  CustomTimesheetWidget(
                    inputdata: TMmonthly.day31,
                  )
                ],
              ):TMmonthly1.day31.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 30),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day31),
                ],
              )
                      : SizedBox()
                  : SizedBox(),
            ],
          ),
        ));
  }
}
class Customtimesheetheader extends StatefulWidget {

  int index;
  Customtimesheetheader({@required this.index,});

  @override
  _CustomtimesheetheaderState createState() => _CustomtimesheetheaderState();
}

class _CustomtimesheetheaderState extends State<Customtimesheetheader> {
  @override
  Widget build(BuildContext context) {
    return
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left:10.0),
            child: Text(
              listOfDates[widget.index],
              style: TextStyle(fontSize: 16,color:iconscolor,fontWeight: FontWeight.bold),
            ),
          ),
         currentuser.roleid==2? GestureDetector(
            onTap: (){
              setState(() {
                selecteddates[widget.index] == false
                    ? selecteddates[widget.index] = true
                    : selecteddates[widget.index] = false;
              });
            },
            child: Icon(
              selecteddates[widget.index] == true
                  ? CupertinoIcons.check_mark_circled_solid
                  : CupertinoIcons.xmark_circle_fill,
              color: selecteddates[widget.index] == true
                  ? orange
                  : Colors.grey,
              size: 30,
            ),
          ):SizedBox(),
        ],
      );
  }
}

class CustomTimesheetWidget extends StatelessWidget {

  List<String> inputdata;
  CustomTimesheetWidget({@required this.inputdata});
  @override
  Widget build(BuildContext context) {
    List<String> outlet = [];
    List<String> checkin = [];
    List<String> checkout = [];


    for (int i = 0; i < inputdata.length; i++) {
      print("regular time sheet");
      var decodeddata = jsonDecode(inputdata[i]);
      outlet.add(decodeddata['Outlet']);
      checkin.add(decodeddata['CheckIn']);
      checkout.add(decodeddata['CheckOut']);
    }

    // for(int j=0;j<outlet.length;j++){
    //   print("ascending order of time sheet");
    //   var decodeddata = jsonDecode(inputdata[j]);
    //   outlet.add(decodeddata['Outlet']);
    //
    //   checkin.sort((a,b) {
    //   return a.compareTo(b);
    // });
    //
    //   checkout.sort((a,b) {
    //     return a.compareTo(b);
    //   });
    // }
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.fromLTRB(5.0, 10, 5.0, 10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.00)),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Table(
            columnWidths: {
              0: FractionColumnWidth(.5),
            },
            children: [
              TableRow(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    "Outlet",
                    style:
                    TextStyle(color: orange, fontWeight: FontWeight.bold,),
                  ),
                ),
                Center(
                  child: Text(
                    "Check in",
                    style: TextStyle(color: orange, fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Text(
                    "Check out",
                    style: TextStyle(color: orange, fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            ],
          ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: outlet.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Table(
                      columnWidths: {
                        0: FractionColumnWidth(.5),
                      },
                      children: [
                        TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              outlet[index],softWrap: true,
                            ),
                          ),
                          Center(
                            child: Text(
                              checkin[index],
                            ),
                          ),
                          Center(
                            child: Text(
                              checkout[index],
                            ),
                          ),
                        ]),
                      ],
                    ),
                    index ==outlet.length-1 ?SizedBox():Divider(color: Colors.grey,)
                  ],
                );
              })
        ],
      ),
    );
  }
}






