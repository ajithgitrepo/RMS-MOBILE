

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:merchandising/api/api_service.dart';
import 'package:intl/intl.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/timesheetmonthly.dart';
import 'package:merchandising/api/timesheetapi.dart';
import 'package:merchandising/main.dart';
import'package:merchandising/Merchandiser/merchandiserscreens/Time Sheet.dart';

final DateTime now = DateTime.now();
final DateFormat formatter = DateFormat('yyyy-MM-dd');
final String todaydate = formatter.format(now);
List dataofdates=[];
List<dynamic> listOfDatesapi;

Future<void> gettimesheetmonthly() async {
   listOfDatesapi = new List<String>.generate(
      daysInMonth(DateTime(int.parse(DateFormat('yyyy').format(DateTime.now())),
          int.parse(DateFormat('mm').format(DateTime.now())))),
          (i) => "${int.parse(DateFormat('yyyy').format(DateTime.now()))}-${DateFormat('MM').format(DateTime.now())}-${'${i + 1}'.toString().padLeft(2,"0")}");
  Map request = {
    "emp_id": "${DBrequestdata.receivedempid}",
    "month" : "$todaydate"
  };
  Map fmrequest = {
    "emp_id": "${timesheet.empid}",
    "month" : "$todaydate"
  };
  print(fmrequest);
  http.Response dataresponse = await http.post(TSMurl,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
      body: currentuser.roleid == 6 ? jsonEncode(request) : jsonEncode(fmrequest),
  );
  if (dataresponse.statusCode == 200) {
    TMmonthly.day1=[];
    TMmonthly.day2=[];
    TMmonthly.day3=[];
    TMmonthly.day4=[];
    TMmonthly.day5=[];
    TMmonthly.day6=[];
    TMmonthly.day7=[];
    TMmonthly.day8=[];
    TMmonthly.day9=[];
    TMmonthly.day10=[];
    TMmonthly.day11=[];
    TMmonthly.day12=[];
    TMmonthly.day13=[];
    TMmonthly.day14=[];
    TMmonthly.day15=[];
    TMmonthly.day16=[];
    TMmonthly.day17=[];
    TMmonthly.day18=[];
    TMmonthly.day19=[];
    TMmonthly.day20=[];
    TMmonthly.day21=[];
    TMmonthly.day22=[];
    TMmonthly.day23=[];
    TMmonthly.day24=[];
    TMmonthly.day25=[];
    TMmonthly.day26=[];
    TMmonthly.day27=[];
    TMmonthly.day28=[];
    TMmonthly.day29=[];
    TMmonthly.day30=[];
    TMmonthly.day31=[];
    String data = dataresponse.body;
    var decodeData = jsonDecode(data);
    print(decodeData['data'].length);
    print('length : ${listOfDatesapi.length}');
    dataofdates = [];
    for (int u=0;u<decodeData['data'].length;u++){

      String date = decodeData['data'][u]['date'];
      print(date);
      if(dataofdates.contains(date)){

      }else{
        dataofdates.add(date);
        dataofdates.sort();
      }

      if(date == listOfDatesapi[1-1]){TMmonthly.day1.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[2-1]){TMmonthly.day2.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[3-1]){TMmonthly.day3.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[4-1]){TMmonthly.day4.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[5-1]){TMmonthly.day5.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[6-1]){TMmonthly.day6.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[7-1]){TMmonthly.day7.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[8-1]){TMmonthly.day8.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[9-1]){TMmonthly.day9.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[10-1]){TMmonthly.day10.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[11-1]){TMmonthly.day11.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[12-1]){TMmonthly.day12.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[13-1]){TMmonthly.day13.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[14-1]){TMmonthly.day14.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[15-1]){TMmonthly.day15.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[16-1]){TMmonthly.day16.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[17-1]){TMmonthly.day17.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[18-1]){TMmonthly.day18.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[19-1]){TMmonthly.day19.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[20-1]){TMmonthly.day20.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[21-1]){TMmonthly.day21.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[22-1]){TMmonthly.day22.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[23-1]){TMmonthly.day23.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[24-1]){TMmonthly.day24.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[25-1]){TMmonthly.day25.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[26-1]){TMmonthly.day26.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[27-1]){TMmonthly.day27.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(date == listOfDatesapi[28-1]){TMmonthly.day28.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      if(listOfDatesapi.length > 28){
        if (date == listOfDatesapi[28]) {TMmonthly.day29.add('{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      }
      if(listOfDatesapi.length > 29){
        if (date == listOfDatesapi[29]) {
          TMmonthly.day30.add(
              '{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      }
      if(listOfDatesapi.length > 30){
        if (date == listOfDatesapi[30]) {
          TMmonthly.day31.add(
              '{"Outlet": "${decodeData['data'][u]['store_name']}","CheckIn":"${decodeData['data'][u]['checkin_time']}","CheckOut":"${decodeData['data'][u]['checkout_time']}"}');}
      }
    }
    print(dataofdates);




  }else{
    print(dataresponse.body);
  }
}




class TMmonthly{
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