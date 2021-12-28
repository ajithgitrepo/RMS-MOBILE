import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';



class Leave{
  static bool employee = false;
  static var empid;
}

Future leaverulesdata1() async{
  http.Response leaverulesdata = await http.post(LeaveRuleDetails,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
  );
  if (leaverulesdata.statusCode == 200){
    leaverules.leavetype=[];
    leaverules.total_days_count=[];
    leaverules.remarks=[];
    leaverules.leaveid=[];
    String responsedata = leaverulesdata.body;
    var decodeddata = jsonDecode(responsedata);
    for(int u=0;u<decodeddata['data'].length;u++) {
      leaverules.leavetype.add(decodeddata['data'][u]['leave_type']);
      leaverules.total_days_count.add(decodeddata['data'][u]['total_days']);
      leaverules.remarks.add(decodeddata['data'][u]['remarks']);
      leaverules.leaveid.add(decodeddata['data'][u]['leave_rule_id']);
      print("leave rule id from api:${leaverules.leaveid}");


      //data[0].leave_rule_id
      //data[0].leave_type
      //data[0].total_days
      //data[0].remarks
    }
  }

}

class leaverules {
  static List<String> leavetype= [];
  static List<dynamic> total_days_count= [];
  static List<String> remarks= [];
  static List<int> leaveid = [];

}