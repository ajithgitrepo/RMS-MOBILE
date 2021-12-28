import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_service.dart';

Future<void> getNBLdetails() async {
  // Map body ={
  //   "outlet_id": currentoutletid,
  // };
  // print(jsonEncode(body));
  // http.Response response = await http.post(NBLDetailsFMs,
  //   headers: {
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
  //   },
  //
  //   body: jsonEncode(body),
  // );
  // if (response.statusCode == 200){
    print("get FM NBL Details Done");
    String brand = offlinenbldata[currentoutletindex];
    var decodebrands = jsonDecode(brand);
    print(brand);
    NBLDetData.fileurl=[];
    NBLDetData.outletid=[];
    NBLDetData.id=[];
    NBLDetData.isactive=[];

    for(int u=0;u<decodebrands['data'].length;u++) {
      NBLDetData.outletid.add(decodebrands['data'][u]['outlet_id']);
      NBLDetData.fileurl.add(decodebrands['data'][u]['file_url']);
      NBLDetData.id.add(decodebrands['data'][u]['id']);
      NBLDetData.isactive.add(decodebrands['data'][u]['is_active']);

    }
    print("files");
    print(NBLDetData.fileurl);
  }
//   if(response.statusCode != 200){
//     print(response.statusCode);
//   }
// }

class NBLDetData {
  static List<String> fileurl = [];
  static List<dynamic> outletid = [];
  static List<int> id = [];
  static List<int> isactive = [];


}