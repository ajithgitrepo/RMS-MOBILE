
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:merchandising/api/api_service.dart';
import 'package:merchandising/api/holidays.dart';


void leaveruleupdate() async {
  Map newholiday =
  {
    "leave_id":"${updateleaverule.leaveid}",
    "total_days":"${updateleaverule.totaldays}",
    "remarks":"${updateleaverule.remarks}"
  };
  print(newholiday);
  http.Response response = await http.post(LeaveRuleUpdtae,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
    body: jsonEncode(newholiday),
  );
  if(response.statusCode == 200){
    print(response.body);

  }else{
    print(response.body);
  }
}

class updateleaverule{
  static int leaveid;
  static String totaldays;
  static String remarks;
}