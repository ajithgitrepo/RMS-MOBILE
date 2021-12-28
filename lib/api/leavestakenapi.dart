import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:merchandising/Fieldmanager/Leavereporting.dart';
import 'package:merchandising/api/timesheetapi.dart';
import 'package:merchandising/main.dart';
import '../Constants.dart';
import 'api_service.dart';
import'package:intl/intl.dart';


import 'package:merchandising/api/api_service.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/timesheetmonthly.dart';



final DateTime now = DateTime.now();
final DateFormat formatter = DateFormat('yyyy-MM-dd');
final String todaydate1 = formatter.format(now);



Future<void> leaveData() async {
  Map body = {
    'emp_id': '${DBrequestdata.receivedempid}'
  };
  http.Response LDresponse = await http.post(LDurl,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
    body: jsonEncode(body),
  );
  if (LDresponse.statusCode == 200) {
    leavedataResponse.reasons = [];
    leavedataResponse.leavetypes = [];
    leavedataResponse.Startdates = [];
    leavedataResponse.enddates = [];
    leavedataResponse.isleaveaccepted = [];
    leavedataResponse.isleaverejected = [];
    leavedataResponse.leavetype = [];
    print('leave data done');
    String LDdata = LDresponse.body;
    var decodeLDData = jsonDecode(LDdata);
    for (int u = 0; u< decodeLDData['data'].length; u++) {
      dynamic reason = decodeLDData['data'][u]['reason'];
      leavedataResponse.reasons.add(reason);
      dynamic type = decodeLDData['data'][u]['leavetype'];
      leavedataResponse.leavetypes.add(type);
      dynamic startdate = decodeLDData['data'][u]['leavestartdate'];
      leavedataResponse.Startdates.add(startdate);
      dynamic enddate = decodeLDData['data'][u]['leaveenddate'];
      leavedataResponse.enddates.add(enddate);
      String isrejected = decodeLDData['data'][u]['is_rejected'];
      leavedataResponse.isleaverejected.add(isrejected);
      String isaccepted = decodeLDData['data'][u]['is_approved'];
      leavedataResponse.isleaveaccepted.add(isaccepted);


    }
  }
}


class leavedataResponse{
  static List<dynamic> reasons=[];
  static List<dynamic> leavetypes=[];
  static List<dynamic> Startdates=[];
  static List<dynamic> enddates=[];
  static List<dynamic> isleaverejected=[];
  static List<dynamic> isleaveaccepted=[];
  static List<dynamic> leavetype=[];
}




List dataofdates1=[];
List<dynamic> listOfDatesapi1;

Future<void> gettimesheetleavetype() async {

  final DateTime date1 = DateTime.now();
  var firstDay = new DateTime(date1.year, date1.month, 1);
  var firstDayOfMonth = new DateTime(date1.year, date1.month + 1, 0);

  listOfDatesapi1 = new List<String>.generate(
      daysInMonth(DateTime(int.parse(DateFormat('yyyy').format(DateTime.now())),
          int.parse(DateFormat('mm').format(DateTime.now())))),
          (i) => "${int.parse(DateFormat('yyyy').format(DateTime.now()))}-${DateFormat('MM').format(DateTime.now())}-${'${i + 1}'.toString().padLeft(2,"0")}");


  Map body = {
    'emp_id': '${DBrequestdata.receivedempid}',
    'from_date': "${firstDay}",
    'to_date': "${firstDayOfMonth}",

    // "from_date":"1-10-2021",
    // "to_date":"31-10-2021"
    //'to_date': "$todaydate",
  };

  Map bodyfm = {
    'emp_id': '${timesheet.empid}',
    'from_date': "${firstDay}",
    'to_date':  "${firstDayOfMonth}",
    // "from_date":"1-10-2021",
    // "to_date":"31-10-2021"
  };
  print(bodyfm);
  http.Response dataresponse1 = await http.post(LeaveReportDetails,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
    body: currentuser.roleid == 6 ? jsonEncode(body) : jsonEncode(bodyfm),
  );
  if (dataresponse1.statusCode == 200) {
    TMmonthly1.day1=[];
    TMmonthly1.day2=[];
    TMmonthly1.day3=[];
    TMmonthly1.day4=[];
    TMmonthly1.day5=[];
    TMmonthly1.day6=[];
    TMmonthly1.day7=[];
    TMmonthly1.day8=[];
    TMmonthly1.day9=[];
    TMmonthly1.day10=[];
    TMmonthly1.day11=[];
    TMmonthly1.day12=[];
    TMmonthly1.day13=[];
    TMmonthly1.day14=[];
    TMmonthly1.day15=[];
    TMmonthly1.day16=[];
    TMmonthly1.day17=[];
    TMmonthly1.day18=[];
    TMmonthly1.day19=[];
    TMmonthly1.day20=[];
    TMmonthly1.day21=[];
    TMmonthly1.day22=[];
    TMmonthly1.day23=[];
    TMmonthly1.day24=[];
    TMmonthly1.day25=[];
    TMmonthly1.day26=[];
    TMmonthly1.day27=[];
    TMmonthly1.day28=[];
    TMmonthly1.day29=[];
    TMmonthly1.day30=[];
    TMmonthly1.day31=[];
    String data = dataresponse1.body;
    var decodeData = jsonDecode(data);
    print(decodeData['data'].length);


    print('firstdate-----------------> : ${firstDay}');
    print('lastdate-------------------> : ${firstDayOfMonth}');



    print('length : ${listOfDatesapi1.length}');
    dataofdates1 = [];
    for (int u=0;u<decodeData['data'].length;u++){
      String date = decodeData['data'][u]['leavestartdate'];
      print("Entered for loop of leave type api");
      print(date);
      if(dataofdates1.contains(date)){

      }else{
        dataofdates1.add(date);
        dataofdates1.sort();
      }

      if(date == listOfDatesapi1[1-1]){TMmonthly1.day1.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[2-1]){TMmonthly1.day2.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[3-1]){TMmonthly1.day3.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[4-1]){TMmonthly1.day4.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[5-1]){TMmonthly1.day5.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[6-1]){TMmonthly1.day6.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[7-1]){TMmonthly1.day7.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
       if(date == listOfDatesapi1[8-1]){TMmonthly1.day8.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      // TMmonthly1.day7.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');
      // TMmonthly1.day8.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');
      if(date == listOfDatesapi1[9-1]){TMmonthly1.day9.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[10-1]){TMmonthly1.day10.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[11-1]){TMmonthly1.day11.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[12-1]){TMmonthly1.day12.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      print(TMmonthly1.day12);
      if(date == listOfDatesapi1[13-1]){TMmonthly1.day13.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      print(TMmonthly1.day13);
      if(date == listOfDatesapi1[14-1]){TMmonthly1.day14.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      print(TMmonthly1.day14);
      if(date == listOfDatesapi1[15-1]){TMmonthly1.day15.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[16-1]){TMmonthly1.day16.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[17-1]){TMmonthly1.day17.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[18-1]){TMmonthly1.day18.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[19-1]){TMmonthly1.day19.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[20-1]){TMmonthly1.day20.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[21-1]){TMmonthly1.day21.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[22-1]){TMmonthly1.day22.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[23-1]){TMmonthly1.day23.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[24-1]){TMmonthly1.day24.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[25-1]){TMmonthly1.day25.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[26-1]){TMmonthly1.day26.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[27-1]){TMmonthly1.day27.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(date == listOfDatesapi1[28-1]){TMmonthly1.day28.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      if(listOfDatesapi1.length > 28){
        if (date == listOfDatesapi1[28]) {TMmonthly1.day29.add('{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      }
      if(listOfDatesapi1.length > 29){
        if (date == listOfDatesapi1[29]) {
          TMmonthly1.day30.add(
              '{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      }
      if(listOfDatesapi1.length > 30){
        if (date == listOfDatesapi1[30]) {
          TMmonthly1.day31.add(
              '{"Leavetype": "${decodeData['data'][u]['leavetype']}"}');}
      }
    }
    print(dataofdates1);




  }else{
    print(dataresponse1.body);
  }
}



class TMmonthly1{
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



class CustomLeaveTypeWidget extends StatelessWidget {

  List<String> inputdata;
  CustomLeaveTypeWidget({@required this.inputdata});
  @override
  Widget build(BuildContext context) {
    List<String> leavetype = [];

    for (int i = 0; i < inputdata.length; i++) {
      print("Week off Monthly");
      var decodeddata = jsonDecode(inputdata[i]);
      leavetype.add(decodeddata['Leavetype']);

    }
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.fromLTRB(5.0, 10, 5.0, 10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.00)),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    "Leave Type",
                    style:
                    TextStyle(color: orange, fontWeight: FontWeight.bold,),
                  ),
                ),
              ]),
            ],
          ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: leavetype.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                              leavetype[index],softWrap: true,
                            ),
                          ),

                        ]),
                      ],
                    ),
                    index ==leavetype.length-1 ?SizedBox():Divider(color: Colors.grey,)
                  ],
                );
              })
        ],
      ),
    );
  }
}