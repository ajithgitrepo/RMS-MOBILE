import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_service.dart';


Future leaverequestwithtype() async {
  var leavetype = leaverequestdata.type;
  var startdate = leaverequestdata.startdate;
  var enddate = leaverequestdata.enddate;
  var reason = leaverequestdata.reason;
  var image = leaverequestdata.image;
  var empid = leaverequestdata.empid;
  Map leaverequestbody =
  {
    'emp_id': '$empid',
    "leavetype": "$leavetype",
    "leavestartdate": "$startdate",
    "leaveenddate": "$enddate",
    "reason": "$reason",
    "image":"data:image/jpg;base64,$image",
  };
  print("json response");
  print(jsonEncode(leaverequestbody));
  http.Response leaveresponse = await http.post(LeaveReportwithtype,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
    body: jsonEncode(leaverequestbody),
  );
  print(leaveresponse.statusCode);
  if(leaveresponse.statusCode == 200 ){
    print(jsonDecode(leaveresponse.body));
  }
}

class leaverequestdata {
  static var type;
  static var startdate;
  static var enddate;
  static var reason;
  static var image;
  static var empid;
}