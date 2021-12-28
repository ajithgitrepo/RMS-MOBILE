import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_service.dart';
import 'package:merchandising/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:merchandising/Constants.dart';
import 'package:merchandising/offlinedata/sharedprefsdta.dart';
String empreportdata;
Future getempdetailsforreport() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  empreportdata = prefs.getString('empdetailesreport');
  if(empreportdata==null || currentlysyncing) {
    Map DBrequestData = {
      'emp_id': '${DBrequestdata.receivedempid}'
    };
    http.Response EmpReport = await http.post(reportingdataurl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
      },
      body: jsonEncode(DBrequestData),
    );
    if (EmpReport.statusCode == 200) {
      print('reporting details done');
      reporting.feildmanager = [];
      reporting.startdate = [];
      reporting.merchandisers = [];
      reporting.enddate = [];
      print('reporting details');
      empreportdata = EmpReport.body;
      addempdetailesreport(empreportdata);
      var decodeddata = jsonDecode(empreportdata);
      for (int u = 0; u < decodeddata['data'].length; u++) {
        reporting.merchandisers.add(
            '${decodeddata["data"][u]['employee']['first_name']} ${decodeddata["data"][u]['employee']['surname']}(${decodeddata["data"][u]['employee']['employee_id']})');
        reporting.feildmanager.add(
            decodeddata["data"][u]['reporting_to_emp_id']);
        reporting.startdate.add(decodeddata["data"][u]['reporting_date']);
        reporting.enddate.add(decodeddata["data"][u]['reporting_end_date']);
        reporting.merchandisersid.add(
            decodeddata["data"][u]['employee']['employee_id']);
        reporting.fmnames.add(
            '${decodeddata["data"][u]['employee_reporting_to']['surname']} ${decodeddata["data"][u]['employee_reporting_to']['first_name']}');
      }
      print(reporting.merchandisersid.length);
      print(reporting.feildmanager.length);
      print(reporting.fmnames.length);
      if (currentuser.roleid == 6) {
        for (int u = 0; u < reporting.merchandisersid.length; u++) {
          if (currentmerchid == reporting.merchandisersid[u]) {
            fieldmanagerofcurrentmerch = reporting.feildmanager[u];
            fieldmanagernameofcurrentmerch = reporting.fmnames[u];
          }
        }
        print(currentmerchid);
        print('fm is : $fieldmanagerofcurrentmerch');
        print(fieldmanagernameofcurrentmerch);
      }
    }
    if (EmpReport.statusCode != 200) {
      print(EmpReport.body);
    }
  }else{
    var decodeddata = jsonDecode(empreportdata);
    for (int u = 0; u < decodeddata['data'].length; u++) {
      reporting.merchandisers.add(
          '${decodeddata["data"][u]['employee']['first_name']} ${decodeddata["data"][u]['employee']['surname']}(${decodeddata["data"][u]['employee']['employee_id']})');
      reporting.feildmanager.add(
          decodeddata["data"][u]['reporting_to_emp_id']);
      reporting.startdate.add(decodeddata["data"][u]['reporting_date']);
      reporting.enddate.add(decodeddata["data"][u]['reporting_end_date']);
      reporting.merchandisersid.add(
          decodeddata["data"][u]['employee']['employee_id']);
      reporting.fmnames.add(
          '${decodeddata["data"][u]['employee_reporting_to']['surname']} ${decodeddata["data"][u]['employee_reporting_to']['first_name']}');
    }
    print(reporting.merchandisersid.length);
    print(reporting.feildmanager.length);
    print(reporting.fmnames.length);
    if (currentuser.roleid == 6) {
      for (int u = 0; u < reporting.merchandisersid.length; u++) {
        if (currentmerchid == reporting.merchandisersid[u]) {
          fieldmanagerofcurrentmerch = reporting.feildmanager[u];
          fieldmanagernameofcurrentmerch = reporting.fmnames[u];
        }
      }
      print(currentmerchid);
      print('fm is : $fieldmanagerofcurrentmerch');
      print(fieldmanagernameofcurrentmerch);
    }
  }
}

class reporting {
  static List <dynamic> feildmanager = [];
  static List<dynamic> startdate=[];
  static List<dynamic> merchandisers = [];
  static List<dynamic> enddate=[];
  static List<dynamic> merchandisersid=[];
  static List<dynamic> fmnames=[];


}