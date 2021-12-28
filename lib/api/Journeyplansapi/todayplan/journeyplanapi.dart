import 'dart:convert';
import 'package:http/http.dart' as http;
import '/api/api_service.dart';
import'package:merchandising/model/distanceinmeters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:merchandising/Constants.dart';
import 'package:merchandising/offlinedata/sharedprefsdta.dart';

var todayJPdata;
Future<void> getJourneyPlan() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  todayJPdata = prefs.getString('todayjp');
  if(todayJPdata == null|| currentlysyncing){
    Map DBrequestData = {'emp_id': '${DBrequestdata.receivedempid}'};
    http.Response JPresponse = await http.post(
      JPurl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
      },
      body: jsonEncode(DBrequestData),
    );
    if (JPresponse.statusCode == 200) {
      print('journey plan done');
      todayJPdata = JPresponse.body;
      addtodayjp(todayJPdata);
      var decodeJPData = jsonDecode(todayJPdata);
      gettodayjp.storenames = [];
      gettodayjp.isscheduled=[];
      gettodayjp.distanceinmeters = [];
      gettodayjp.contactnumbers = [];
      gettodayjp.outletcountry = [];
      gettodayjp.outletcity = [];
      gettodayjp.outletarea = [];
      gettodayjp.storecodes = [];
      gettodayjp.id = [];
      gettodayjp.outletlong = [];
      gettodayjp.outletlat = [];
      gettodayjp.outletids = [];
      gettodayjp.checkouttime = [];
      gettodayjp.checkintime = [];
      gettodayjp.status = [];
      for (int u = 0; u < decodeJPData['data'].length; u++) {
        dynamic storename = decodeJPData['data'][u]['store_name'];
        gettodayjp.storenames.add(storename);
        dynamic storecode = decodeJPData['data'][u]['store_code'];
        gettodayjp.storecodes.add(storecode);
        int isschdlue = decodeJPData['data'][u]['scheduled_calls'];
        gettodayjp.isscheduled.add(isschdlue);
        dynamic outletid = decodeJPData['data'][u]['outlet']['outlet_id'];
        gettodayjp.outletids.add(outletid);
        dynamic outletlat = decodeJPData['data'][u]['outlet']['outlet_lat'];
        gettodayjp.outletlat.add(outletlat);
        dynamic outletlong = decodeJPData['data'][u]['outlet']['outlet_long'];
        gettodayjp.outletlong.add(outletlong);
        dynamic outletarea = decodeJPData['data'][u]['outlet']['outlet_area'];
        gettodayjp.outletarea.add(outletarea);
        dynamic outletcity = decodeJPData['data'][u]['outlet']['outlet_city'];
        gettodayjp.outletcity.add(outletcity);
        dynamic outletcountry =
            decodeJPData['data'][u]['outlet']['outlet_country'];
        gettodayjp.outletcountry.add(outletcountry);
        dynamic tableid = decodeJPData['data'][u]['id'];
        gettodayjp.id.add(tableid);
        dynamic outletcontact = decodeJPData['data'][u]['contact_number'];
        gettodayjp.contactnumbers.add(outletcontact);
        if (decodeJPData['data'][u]['checkin_time'] == null) {
          gettodayjp.checkintime.add('notcheckedin');
        } else {
          gettodayjp.checkintime.add(decodeJPData['data'][u]['checkin_time']);
        }
        if (decodeJPData['data'][u]['checkin_time'] == null) {
          gettodayjp.checkouttime.add('notcheckedout');
        } else {
          gettodayjp.checkouttime.add(decodeJPData['data'][u]['checkout_time']);
        }
        if (decodeJPData['data'][u]['checkin_time'] != null &&
            decodeJPData['data'][u]['checkout_time'] != null) {
          gettodayjp.status.add('done');
        } else if (decodeJPData['data'][u]['checkin_time'] != null &&
            decodeJPData['data'][u]['checkout_time'] == null) {
          gettodayjp.status.add('working');
        } else {
          gettodayjp.status.add('pending');
        }
      }
      print("lat: ${gettodayjp.outletlat}");
      print(gettodayjp.isscheduled);
    } else {
      print(JPresponse.statusCode);
    }
  }else{
    var decodeJPData = jsonDecode(todayJPdata);
    gettodayjp.storenames = [];
    gettodayjp.distanceinmeters = [];
    gettodayjp.contactnumbers = [];
    gettodayjp.outletcountry = [];
    gettodayjp.outletcity = [];
    gettodayjp.outletarea = [];
    gettodayjp.storecodes = [];
    gettodayjp.id = [];
    gettodayjp.outletlong = [];
    gettodayjp.outletlat = [];
    gettodayjp.outletids = [];
    gettodayjp.checkouttime = [];
    gettodayjp.checkintime = [];
    gettodayjp.status = [];
    for (int u = 0; u < decodeJPData['data'].length; u++) {
      dynamic storename = decodeJPData['data'][u]['store_name'];
      gettodayjp.storenames.add(storename);
      dynamic storecode = decodeJPData['data'][u]['store_code'];
      gettodayjp.storecodes.add(storecode);
      int isschdlue = decodeJPData['data'][u]['scheduled_calls'];
      gettodayjp.isscheduled.add(isschdlue);
      dynamic outletid = decodeJPData['data'][u]['outlet']['outlet_id'];
      gettodayjp.outletids.add(outletid);
      dynamic outletlat = decodeJPData['data'][u]['outlet']['outlet_lat'];
      gettodayjp.outletlat.add(outletlat);
      dynamic outletlong = decodeJPData['data'][u]['outlet']['outlet_long'];
      gettodayjp.outletlong.add(outletlong);
      dynamic outletarea = decodeJPData['data'][u]['outlet']['outlet_area'];
      gettodayjp.outletarea.add(outletarea);
      dynamic outletcity = decodeJPData['data'][u]['outlet']['outlet_city'];
      gettodayjp.outletcity.add(outletcity);
      dynamic outletcountry =
      decodeJPData['data'][u]['outlet']['outlet_country'];
      gettodayjp.outletcountry.add(outletcountry);
      dynamic tableid = decodeJPData['data'][u]['id'];
      gettodayjp.id.add(tableid);
      dynamic outletcontact = decodeJPData['data'][u]['contact_number'];
      gettodayjp.contactnumbers.add(outletcontact);
      if (decodeJPData['data'][u]['checkin_time'] == null) {
        gettodayjp.checkintime.add('notcheckedin');
      } else {
        gettodayjp.checkintime.add(decodeJPData['data'][u]['checkin_time']);
      }
      if (decodeJPData['data'][u]['checkin_time'] == null) {
        gettodayjp.checkouttime.add('notcheckedout');
      } else {
        gettodayjp.checkouttime.add(decodeJPData['data'][u]['checkout_time']);
      }
      if (decodeJPData['data'][u]['checkin_time'] != null &&
          decodeJPData['data'][u]['checkout_time'] != null) {
        gettodayjp.status.add('done');
      } else if (decodeJPData['data'][u]['checkin_time'] != null &&
          decodeJPData['data'][u]['checkout_time'] == null) {
        gettodayjp.status.add('working');
      } else {
        gettodayjp.status.add('pending');
      }
    }
    print("lat: ${gettodayjp.outletlat}");
  }
}

class gettodayjp{
  static List<dynamic> storecodes=[];
  static List<dynamic> storenames=[];
  static List<dynamic> outletids=[];
  static List<dynamic> outletlat=[];
  static List<dynamic> outletlong=[];
  static List<dynamic> outletarea=[];
  static List<dynamic> outletcity=[];
  static List<dynamic> outletcountry=[];
  static List<dynamic> id=[];
  static List<dynamic> contactnumbers=[];
  static List<double> distanceinmeters=[];

  static List<double> sortdistnce=[];
  static List<int> isscheduled=[];
  static List<dynamic> checkintime=[];
  static List<dynamic> checkouttime=[];
  static List<String> status=[];
}