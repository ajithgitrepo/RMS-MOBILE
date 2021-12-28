import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:merchandising/clients/reports.dart';
import 'package:merchandising/main.dart';
import 'api_service.dart';
import 'package:intl/intl.dart';

class timesheet{
  static var empid;
  static var empname;
}


Future getTimeSheetdaily() async {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String todaydate = formatter.format(now);
  Map timesheetfm = {
    'emp_id': '${timesheet.empid}',
    'date': '$todaydate',
  };
  Map Timesheetrequest = {
    'emp_id': '${DBrequestdata.receivedempid}',
    'date': '$todaydate',
  };
  print(timesheetfm);
  http.Response tsresponse = await http.post(TSurl,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
    body: currentuser.roleid == 6 ? jsonEncode(Timesheetrequest) : jsonEncode(timesheetfm),
  );
  print(tsresponse.body);
  if (tsresponse.statusCode == 200) {
    TimeSheetdatadaily.outletname = [];
    TimeSheetdatadaily.checkouttime = [];
    TimeSheetdatadaily.checkintime = [];
    TimeSheetdatadaily.tsid = [];
    String data = tsresponse.body;
    var decodeData = jsonDecode(data);
    for(int u=0;u<decodeData['data'].length;u++){
      dynamic outletname = decodeData['data'][u]['store_name'];
      TimeSheetdatadaily.outletname.add(outletname);
      dynamic checkintime = decodeData['data'][u]['checkin_time'];
      TimeSheetdatadaily.checkintime.add(checkintime);
      dynamic checkouttime = decodeData['data'][u]['checkout_time'];
      TimeSheetdatadaily.checkouttime.add(checkouttime);

      dynamic timesheetid = decodeData['data'][u]['id'];
      TimeSheetdatadaily.tsid.add(timesheetid);

    }

  }
  else {
    print(tsresponse.statusCode);
    print("error");
  }
}

class TimeSheetdatadaily{
  static List<dynamic> outletname=[];
  static List<dynamic> checkintime=[];
  static List<dynamic> checkouttime=[];
  static List<dynamic> tsid =[];
}
// class TimeSheetspdatadaily{
//   static List<dynamic> outletname=[];
//   static List<dynamic> checkintime=[];
//   static List<dynamic> checkouttime=[];
// }



 DateTime now = DateTime.now();
 DateFormat formatter =DateFormat('dd-MM-yyyy');
 String todaydateapprove = formatter.format(now);

Future CDETimeSheetApproval() async{


  Map approvedatatoday = {
    'emp_id' : '${DBrequestdata.receivedempid}',
    'from_date':'${todaydateapprove}',
    'to_date':'${todaydateapprove}',
  };
  print(jsonEncode(approvedatatoday));

  http.Response addapprove = await http.post(CDEApproveTimeSheet,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
    body:jsonEncode(approvedatatoday),
  );
  print(addapprove.body);
  print(pressAttentionMTB);

}





Future CDETimeSheetApprovalmonth() async{

   DateTime now = DateTime.now();
   DateFormat formatter =DateFormat('dd-MM-yyyy');
   String todaydate = formatter.format(now);


  final DateTime monthly = DateTime.now();
  final DateFormat monthformat = DateFormat('01-MM-yyyy');
  final String monthdate = monthformat.format(monthly);
  Map approvedatamonth = {
    'emp_id' : '${DBrequestdata.receivedempid}',
    'from_date':'${monthdate}',
    'to_date':'${todaydate}',

  };
   print(jsonEncode(approvedatamonth));

  http.Response addapprove = await http.post(CDEApproveTimeSheet,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
    body:jsonEncode(approvedatamonth),
  );
  print(addapprove.body);
  print(pressAttentionMTB);

}


