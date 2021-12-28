import 'package:merchandising/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:merchandising/offlinedata/sharedprefsdta.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_launcher_icons/constants.dart';
import 'dart:convert';
import 'package:merchandising/Constants.dart';
import 'package:intl/intl.dart';
import 'syncreferenceapi.dart';

 bool backgroundsyncing  = false;
List<String>requireurlstosync=[];
List<String>requirebodytosync=[];
List<String>message=[];


syncingsenddata()async {
  CreateLog("synchronising data from device to server started",true);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  lastsyncedon =  DateTime.parse(prefs.getString('lastsyncedondate'));
  requireurlstosync =  prefs.getStringList('addtoserverurl');
  print(lastsyncedon);
  if(requireurlstosync!=null){
    requireurlstosync =  prefs.getStringList('addtoserverurl');
    requirebodytosync =  prefs.getStringList('addtoserverbody');
    message =  prefs.getStringList('addtoservermessage');
  }else{
    requireurlstosync=[];
    requirebodytosync=[];
    message =[];
  }
  print("syncing current data");
    if (requireurlstosync != [] && requireurlstosync != null && onlinemode.value) {    
      for (int i = 0; i < requireurlstosync.length; i++) {
        var checkintime=null;
        var timesheetid=null;
        var checkouttime=null;
        var journeytimeid=null;

        var type= jsonDecode(requirebodytosync[i])["type"];
        checkintime= jsonDecode(requirebodytosync[i])["checkin_time"];
        timesheetid= jsonDecode(requirebodytosync[i])["timesheet_id"];
        checkouttime= jsonDecode(requirebodytosync[i])["checkout_time"];
        journeytimeid= jsonDecode(requirebodytosync[i])["journey_time_id"];
        if(type == "Split Shift"&&checkintime==""&&timesheetid!=null&&checkouttime!=""&&journeytimeid == ""){
          print(true);
          print(type);
          print(checkintime);
          print(timesheetid);
          print(checkouttime);
          print(journeytimeid);
          currenttimesheetid = timesheetid;
          await getTotalJnyTime();
          print(TotalJnyTime.id.last);
          Map breaktime =
          {
            "type" : "Split Shift",
            "timesheet_id" : timesheetid,
            "checkin_time" : "",
            "checkout_time" : checkouttime,
            "journey_time_id" : TotalJnyTime.id.last,
          };
          http.Response response = await http.post(Uri.parse(requireurlstosync[i]),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
            },
            body: jsonEncode(breaktime),
          );
          print(response.body);
          print("check 1 sync send");
          CreateLog("Api request : url-${requireurlstosync[i]},Body-${requirebodytosync[i]},response-${response.body}",true);
          print("check 1 sync send createlog done");
        }
        else{
        // progress.value++;
        http.Response response = await http.post(
          Uri.parse(requireurlstosync[i]),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
          },
          body: requirebodytosync[i],
        );
        if (response.statusCode == 200) {
          print(response.body);
          print("check 2 sync send");

          CreateLog("Api request : url-${requireurlstosync[i]},Body-${requirebodytosync[i]},response-${response.body}",true);
        } else {
          print(response.body);
          print("check 3 sync send");
          CreateLog("Api Error : url-${requireurlstosync[i]},Body-${requirebodytosync[i]},response-${response.body}",false);
        }
      }
    }
      requireurlstosync = [];
      requirebodytosync = [];
      message=[];
      removesenddatafromlocal();
  }

}

CreateLog(message,status){
  logreport.add(message);
  logtime.add(DateFormat.yMd().add_jm().format(DateTime.now()).toString());
  logreportstatus.add("$status");
  savelogreport(logreport,logtime,logreportstatus);
}