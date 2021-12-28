
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:merchandising/api/api_service.dart';
import 'package:merchandising/main.dart';


Future HRdb() async{
  Map DBrequestData = {
    'emp_id': '${DBrequestdata.receivedempid}'
  };
  print(DBrequestData);
  http.Response DBresponse =await http.post(HRdburl,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
    body: jsonEncode(DBrequestData),
  );
  if (DBresponse.statusCode == 200){
    print('hr dashboard done');
    String data = DBresponse.body;
    var decodeData = jsonDecode(data);
    HRdashboarddata.fmtotal = decodeData['FieldManager'];
    HRdashboarddata.fmpresent = decodeData['FieldManagerPresent'];
    HRdashboarddata.fmabsent = decodeData['FieldManagerAbsent'];
    HRdashboarddata.merchtotal = decodeData['Merchandiser'];
    HRdashboarddata.merchpresent = decodeData['MerchandiserPresent'];
    HRdashboarddata.merchabsent = decodeData['MerchandiserAbsent'];
    HRdashboarddata.leavebalance = decodeData['AvailableLeave'];
    HRdashboarddata.leaveresponsetotal = decodeData['TotalLeaveReq'];
    HRdashboarddata.attendance = decodeData['Attendace'];
    HRdashboarddata.emptotal = HRdashboarddata.fmtotal + HRdashboarddata.merchtotal;
    HRdashboarddata.emppresent = HRdashboarddata.fmpresent + HRdashboarddata.merchpresent;
    HRdashboarddata.empabsent = HRdashboarddata.fmabsent + HRdashboarddata.merchabsent;
    remaining.leaves = HRdashboarddata.leavebalance;
    return HRdashboarddata.attendance;
  }
}

class HRdashboarddata{
  static int emptotal;
  static int emppresent;
  static int empabsent;
  static int fmtotal;
  static int fmpresent;
  static int fmabsent;
  static int merchtotal;
  static int merchpresent;
  static int merchabsent;
  static int leaveresponsetotal;
  static int leavebalance;
  static int attendance;
}