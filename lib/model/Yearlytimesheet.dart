import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merchandising/Constants.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../Constants.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:merchandising/api/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:merchandising/main.dart';
import 'package:merchandising/api/timesheetapi.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/timesheetmonthly.dart';
import 'package:merchandising/api/leavestakenapi.dart';



var initialDate = DateTime.now();
DateTime selectedDate;

String Selectedday;

Future<void> getSelectedtimesheetmonthly() async {
  var listOfDatesapi = new List<String>.generate(
      daysInMonthyearly(
          DateTime(int.parse(DateFormat('yyyy').format(selectedDate)),
              int.parse(DateFormat('mm').format(selectedDate)))),
          (i) =>
      "${int.parse(DateFormat('yyyy').format(selectedDate))}-${DateFormat('MM')
          .format(selectedDate)}-${'${i + 1}'.toString().padLeft(2, "0")}");

  Map request = {
    "emp_id": "${DBrequestdata.receivedempid}",
    "month": "$Selectedday"
  };
  Map fmrequest = {"emp_id": "${timesheet.empid}", "month": "$Selectedday"};
  print(fmrequest);
  http.Response dataresponse = await http.post(
    TSMurl,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
    body: currentuser.roleid == 6 ? jsonEncode(request) : jsonEncode(fmrequest),
  );
  print(dataresponse.body);
  if (dataresponse.statusCode == 200) {
    SelectedTMmonthly.day1 = [];
    SelectedTMmonthly.day2 = [];
    SelectedTMmonthly.day3 = [];
    SelectedTMmonthly.day4 = [];
    SelectedTMmonthly.day5 = [];
    SelectedTMmonthly.day6 = [];
    SelectedTMmonthly.day7 = [];
    SelectedTMmonthly.day8 = [];
    SelectedTMmonthly.day9 = [];
    SelectedTMmonthly.day10 = [];
    SelectedTMmonthly.day11 = [];
    SelectedTMmonthly.day12 = [];
    SelectedTMmonthly.day13 = [];
    SelectedTMmonthly.day14 = [];
    SelectedTMmonthly.day15 = [];
    SelectedTMmonthly.day16 = [];
    SelectedTMmonthly.day17 = [];
    SelectedTMmonthly.day18 = [];
    SelectedTMmonthly.day19 = [];
    SelectedTMmonthly.day20 = [];
    SelectedTMmonthly.day21 = [];
    SelectedTMmonthly.day22 = [];
    SelectedTMmonthly.day23 = [];
    SelectedTMmonthly.day24 = [];
    SelectedTMmonthly.day25 = [];
    SelectedTMmonthly.day26 = [];
    SelectedTMmonthly.day27 = [];
    SelectedTMmonthly.day28 = [];
    SelectedTMmonthly.day29 = [];
    SelectedTMmonthly.day30 = [];
    SelectedTMmonthly.day31 = [];
    String data = dataresponse.body;
    var decodeData = jsonDecode(data);
    for (int u = 0; u < decodeData['data'].length; u++) {
      String date = decodeData['data'][u]['date'];
      if(date == listOfDatesapi[1-1]){SelectedTMmonthly.day1.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[2-1]){SelectedTMmonthly.day2.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[3-1]){SelectedTMmonthly.day3.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[4-1]){SelectedTMmonthly.day4.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[5-1]){SelectedTMmonthly.day5.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[6-1]){SelectedTMmonthly.day6.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[7-1]){SelectedTMmonthly.day7.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[8-1]){SelectedTMmonthly.day8.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[9-1]){SelectedTMmonthly.day9.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[10-1]){SelectedTMmonthly.day10.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[11-1]){SelectedTMmonthly.day11.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[12-1]){SelectedTMmonthly.day12.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[13-1]){SelectedTMmonthly.day13.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[14-1]){SelectedTMmonthly.day14.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[15-1]){SelectedTMmonthly.day15.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[16-1]){SelectedTMmonthly.day16.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[17-1]){SelectedTMmonthly.day17.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[18-1]){SelectedTMmonthly.day18.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[19-1]){SelectedTMmonthly.day19.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[20-1]){SelectedTMmonthly.day20.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[21-1]){SelectedTMmonthly.day21.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[22-1]){SelectedTMmonthly.day22.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[23-1]){SelectedTMmonthly.day23.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[24-1]){SelectedTMmonthly.day24.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[25-1]){SelectedTMmonthly.day25.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[26-1]){SelectedTMmonthly.day26.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[27-1]){SelectedTMmonthly.day27.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[28-1]){SelectedTMmonthly.day28.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(listOfDatesapi.length > 28){
        if (date == listOfDatesapi[28]) {SelectedTMmonthly.day29.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      }
      if(listOfDatesapi.length > 29){
        if (date == listOfDatesapi[29]) {
          SelectedTMmonthly.day30.add(
              '{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      }
      if(listOfDatesapi.length > 30){
        if (date == listOfDatesapi[30]) {
          SelectedTMmonthly.day31.add(
              '{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      }
    }
  } else {
    print(dataresponse.body);
  }
}
class SelectedTMmonthly{
  static List<String> day1= [];
  static List<String> day2 = [];
  static List<String> day3 = [];
  static List<String> day4 = [];
  static List<String> day5 = [];
  static List<String> day6 = [];
  static List<String> day7 = [];
  static List<String> day8 = [];
  static List<String> day9 = [];
  static List<String> day10 = [];
  static List<String> day11 = [];
  static List<String> day12 = [];
  static List<String> day13 = [];
  static List<String> day14 = [];
  static List<String> day15 = [];
  static List<String> day16 = [];
  static List<String> day17 = [];
  static List<String> day18 = [];
  static List<String> day19 = [];
  static List<String> day20 = [];
  static List<String> day21 = [];
  static List<String> day22 = [];
  static List<String> day23 = [];
  static List<String> day24 = [];
  static List<String> day25 = [];
  static List<String> day26 = [];
  static List<String> day27 = [];
  static List<String> day28 = [];
  static List<String> day29 = [];
  static List<String> day30 = [];
  static List<String> day31 = [];
}

int daysInMonthyearly(DateTime date) {
  var firstDayThisMonth = new DateTime(date.year, date.month, date.day);
  var firstDayNextMonth = new DateTime(firstDayThisMonth.year,
      firstDayThisMonth.month + 1, firstDayThisMonth.day);
  return firstDayNextMonth.difference(firstDayThisMonth).inDays;
}
var listOfDatesUI=[];
class Timesheetyearly extends StatefulWidget {

  @override
  _TimesheetyearlyState createState() => _TimesheetyearlyState();
}

class _TimesheetyearlyState extends State<Timesheetyearly> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
          decoration: BoxDecoration(
              color: pink, borderRadius: BorderRadius.circular(10.00)),
          child: Column(
            children: [
              SelectedTMmonthly.day1.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 0,),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day1,
                  ),
                ],
              ):TMmonthly1.day1.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 0),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day1),
                ],
              )
                  : SizedBox(),
              SelectedTMmonthly.day2.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 1,),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day2,
                  )
                ],
              ):TMmonthly1.day2.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 1),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day2),
                ],
              )
                  : SizedBox(),
              SelectedTMmonthly.day3.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 2),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day3,
                  )
                ],
              ):TMmonthly1.day3.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 2),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day3),
                ],
              )
                  : SizedBox(),
              // day3list(),
              SelectedTMmonthly.day4.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 3),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day4,
                  )
                ],
              ):TMmonthly1.day4.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 3),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day4),
                ],
              )
                  : SizedBox(),
              // day4 == true ? day4list() : SizedBox(),
              SelectedTMmonthly.day5.length != 0
                  ?  Column(
                children: [
                  Customtimesheetheader(index: 4),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day5,
                  )
                ],
              ):TMmonthly1.day5.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 4),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day5),
                ],
              )
                  : SizedBox(),
              // day5 == true ? day5list() : SizedBox(),
              SelectedTMmonthly.day6.length != 0
                  ?  Column(
                children: [
                  Customtimesheetheader(index: 5),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day6,
                  )
                ],
              ):TMmonthly1.day6.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 5),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day6),
                ],
              )
                  : SizedBox(),
              // day6 == true ? day6list() : SizedBox(),
              SelectedTMmonthly.day7.length != 0
                  ?  Column(
                children: [
                  Customtimesheetheader(index: 6),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day7,
                  )
                ],
              ):TMmonthly1.day7.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 6),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day7),
                ],
              )
                  : SizedBox(),
              // day7 == true ? day7list() : SizedBox(),
              SelectedTMmonthly.day8.length != 0
                  ?  Column(
                children: [
                  Customtimesheetheader(index: 7),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day8,
                  )
                ],
              ):TMmonthly1.day8.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 7),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day8),
                ],
              )
                  : SizedBox(),
              // day8 == true ? day8list() : SizedBox(),
              SelectedTMmonthly.day9.length != 0
                  ?  Column(
                children: [
                  Customtimesheetheader(index: 8),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day9,
                  )
                ],
              ):TMmonthly1.day9.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 8),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day9),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day10.length != 0
                  ?  Column(
                children: [
                  Customtimesheetheader(index: 9),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day10,
                  )
                ],
              ):TMmonthly1.day10.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 9),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day10),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day11.length != 0
                  ?  Column(
                children: [
                  Customtimesheetheader(index: 10),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day11,
                  )
                ],
              ):TMmonthly1.day11.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 10),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day11),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day12.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 11),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day12,
                  )
                ],
              ):TMmonthly1.day12.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 11),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day12),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day13.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 12),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day13,
                  )
                ],
              ):TMmonthly1.day13.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 12),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day13),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day14.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 13),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day14,
                  )
                ],
              ):TMmonthly1.day14.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 13),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day14),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day15.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 14),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day15,
                  )
                ],
              ):TMmonthly1.day15.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 14),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day15),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day16.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 15),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day16,
                  )
                ],
              ):TMmonthly1.day16.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 15),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day16),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day17.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 16),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day17,
                  )
                ],
              ):TMmonthly1.day17.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 16),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day17),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day18.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 17),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day18,
                  )
                ],
              ):TMmonthly1.day18.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 17),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day18),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day19.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 18),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day19,
                  )
                ],
              ):TMmonthly1.day19.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 18),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day19),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day20.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 19),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day20,
                  )
                ],
              ):TMmonthly1.day20.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 19),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day20),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day21.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 20),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day21,
                  )
                ],
              ):TMmonthly1.day21.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 20),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day21),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day22.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 21),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day22,
                  )
                ],
              ):TMmonthly1.day22.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 21),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day22),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day23.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 22),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day23,
                  )
                ],
              ):TMmonthly1.day23.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 22),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day23),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day24.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 23),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day24,
                  )
                ],
              ):TMmonthly1.day24.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 23),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day24),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day25.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 24),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day25,
                  )
                ],
              ):TMmonthly1.day25.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 24),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day25),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day26.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 25),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day26,
                  )
                ],
              ):TMmonthly1.day26.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 25),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day26),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day27.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 26),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day27,
                  )
                ],
              ):TMmonthly1.day27.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 26),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day27),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day28.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 27),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day28,
                  )
                ],
              ):TMmonthly1.day28.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 27),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day28),
                ],
              )
                  : SizedBox(),

              SelectedTMmonthly.day29.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 28),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day29,
                  )
                ],
              ):TMmonthly1.day29.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 28),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day29),
                ],
              )
                  : SizedBox(),
              // listOfDates.length > 28
              //     ? day29 == true
              //         ? day29list()
              //         : SizedBox()
              //     : SizedBox(),
              SelectedTMmonthly.day30.length != 0
                  ?Column(
                children: [
                  Customtimesheetheader(index: 29),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day30,
                  )
                ],
              ):TMmonthly1.day30.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 29),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day30),
                ],
              )
                  : SizedBox(),
              // listOfDates.length > 29
              //     ? day30 == true
              //         ? day30list()
              //         : SizedBox()
              //     : SizedBox(),
              SelectedTMmonthly.day31.length != 0
                  ? Column(
                children: [
                  Customtimesheetheader(index: 30),
                  CustomTimesheetWidget(
                    inputdata: SelectedTMmonthly.day31,
                  )
                ],
              ):TMmonthly1.day31.length !=0?Column(
                children: [
                  Customtimesheetheader(index: 30),
                  CustomLeaveTypeWidget(inputdata: TMmonthly1.day31),
                ],
              )
                  : SizedBox(),
              // listOfDates.length > 30
              //     ? day31 == true
              //         ? day31list()
              //         : SizedBox()
              //     : SizedBox(),
            ],
          )),
    );
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
              listOfDatesUI[widget.index],
              style: TextStyle(fontSize: 16,color:iconscolor,fontWeight: FontWeight.bold),
            ),
          ),
          // GestureDetector(
          //   onTap: (){
          //     setState(() {
          //       selecteddates[widget.index] == false
          //           ? selecteddates[widget.index] = true
          //           : selecteddates[widget.index] = false;
          //     });
          //   },
          //   child: Icon(
          //     selecteddates[widget.index] == true
          //         ? CupertinoIcons.check_mark_circled_solid
          //         : CupertinoIcons.xmark_circle_fill,
          //     color: selecteddates[widget.index] == true
          //         ? orange
          //         : Colors.grey,
          //     size: 30,
          //   ),
          // ),
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
      var decodeddata = jsonDecode(inputdata[i]);
      outlet.add(decodeddata['Outlet']);
      checkin.add(decodeddata['CheckIn']);
      checkout.add(decodeddata['CheckOut']);
    }
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