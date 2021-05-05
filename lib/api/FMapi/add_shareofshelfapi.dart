import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:merchandising/api/api_service.dart';

class AddShareData{
  static var outletid;
  static var timesheetid;
  static List<dynamic> brandid=[];
  static List<dynamic> totalshare=[];
  static List<dynamic> share=[];
  static List<dynamic> target = [];
  static List<dynamic> actual = [];

}

Future addShareofshelfdata() async{
  Map addshare = {
    'outlet_id' : currentoutletid,
    'timesheet_id' : currenttimesheetid,
    'brand_id' : '${AddShareData.brandid}',
    'total_share' : '${AddShareData.totalshare}',
    'share' : '${AddShareData.share}',
    'target' : '${AddShareData.target}',
    'actual' : '${AddShareData.actual}',
   };
  http.Response shareresponse = await http.post(AddShareofshelf,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
    body: jsonEncode(addshare),
  );
  print(shareresponse.body);
}