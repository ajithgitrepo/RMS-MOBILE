import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_service.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/Visibility.dart';
import 'package:merchandising/Constants.dart';
class AddVisiData {
  static int outletid;
  static int timesheetid;
  static List<int> productid = [];
  static List<int> brandid = [];
  static List<int> categoryid = [];
  static List<dynamic> categoryname = [];
  static List<dynamic> productname = [];
  static List<int> checkvalue = [];
  static List<String> reason = [];
  static List<String> area = [];
  static List<String> sos = [];
  static List<String> poi = [];
  static var outletpdtmap;
}

Future addVisibilitydata() async {
  Map addvisibility = {
    'outlet_id': currentoutletid,
    'timesheet_id': currenttimesheetid,
    'outlet_products_mapping_id': AddVisiData.outletpdtmap,
    'category_id': AddVisiData.categoryid,
    'category_name': AddVisiData.categoryname,
    'check_value': AddVisiData.checkvalue,
    'reason': AddVisiData.reason,
    "g_area" : AddVisiData.area,
    "main_aisle" :  AddVisiData.sos,
    "pois" :  AddVisiData.poi
  };
  print(jsonEncode(addvisibility));
  adddataforsync("https://rms2.rhapsody.ae/api/add_visibility",jsonEncode(addvisibility),"Visibility added for the timesheet id $currenttimesheetid");
  // http.Response availresponse = await http.post(
  //   AddVisibility,
  //   headers: {
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
  //   },
  //   body: jsonEncode(addvisibility),
  // );
  // print(availresponse.body);
  print("Add Visibility done");
}
