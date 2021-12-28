import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
Future<void> getNotificationDetails() async {
  Map DBrequestData = {
    'emp_id': '${DBrequestdata.receivedempid}',
  };
  print(DBrequestData);
  http.Response SDResponse = await http.post(NotiDet,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
    body: jsonEncode(DBrequestData),
  );
  if (SDResponse.statusCode == 200){
    print("Notification Details Done");
    String stores = SDResponse.body;
    var decodenotdet = jsonDecode(stores);
    NotiDetData.id = [];
    NotiDetData.title = [];
    NotiDetData.date = [];

    for(int u=0;u<decodenotdet['data'].length;u++) {

      NotiDetData.title.add(decodenotdet['data'][u]['title']);
      NotiDetData.id.add(decodenotdet['data'][u]['id']);
      NotiDetData.date.add('${decodenotdet['data'][u]['date']}');

    }
  }

  if(SDResponse.statusCode != 200){
    print(SDResponse.statusCode);
  }
}

class NotiDetData {
  static List<int> id = [];
  static List<String> title = [];
  static List<String> date = [];

}


class NotificationViewed{
  static var id;

}

Future notificationviewed() async{
  Map storedata = {
    'notification_id' : '${NotificationViewed.id}',

  };
  http.Response stores = await http.post(NotiViewed,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
    body: jsonEncode(storedata),
  );
//print(stores.body);
  print("Notification has been Viewed");
}


class NotiViewedAll{
  static List<int> notid =[];
}
Future notiviewall() async{
  Map storedata = {
    'notification_id' : '${NotiViewedAll.notid}',

  };
  http.Response stores = await http.post(NotiViewAll,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
    body: jsonEncode(storedata),
  );
//print(stores.body);
  print("All Notification has been Viewed");
}
