import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import 'jprequest.dart';
import 'package:merchandising/pages/Journeyplan.dart';
import 'package:merchandising/model/Location_service.dart';


Future<void> getJourneyPlan() async {
  http.Response JPresponse = await http.post(JPurl,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(DBrequestData),
  );
  if (JPresponse.statusCode == 200){
    String JPdata = JPresponse.body;
    var decodeJPData = jsonDecode(JPdata);
    JPResponsedata.outletiddata1 = decodeJPData['data'][0]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata1 = decodeJPData['data'][0]['outlet']['outlet_name'];
    JPResponsedata.latitudedata1 = decodeJPData['data'][0]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata1 = decodeJPData['data'][0]['outlet']['outlet_long'];
    JPResponsedata.outletareadata1 = decodeJPData['data'][0]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata1 = decodeJPData['data'][0]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata1 = decodeJPData['data'][0]['outlet']['outlet_city'];
    JPResponsedata.outletiddata2 = decodeJPData['data'][1]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata2 = decodeJPData['data'][1]['outlet']['outlet_name'];
    JPResponsedata.latitudedata2 = decodeJPData['data'][1]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata2 = decodeJPData['data'][1]['outlet']['outlet_long'];
    JPResponsedata.outletareadata2 = decodeJPData['data'][1]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata2 = decodeJPData['data'][1]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata2 = decodeJPData['data'][1]['outlet']['outlet_city'];
    JPResponsedata.outletiddata3 = decodeJPData['data'][2]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata3 = decodeJPData['data'][2]['outlet']['outlet_name'];
    JPResponsedata.latitudedata3 = decodeJPData['data'][2]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata3 = decodeJPData['data'][2]['outlet']['outlet_long'];
    JPResponsedata.outletareadata3 = decodeJPData['data'][2]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata3 = decodeJPData['data'][2]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata3 = decodeJPData['data'][2]['outlet']['outlet_city'];
    JPResponsedata.outletiddata4 = decodeJPData['data'][3]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata4 = decodeJPData['data'][3]['outlet']['outlet_name'];
    JPResponsedata.latitudedata4 = decodeJPData['data'][3]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata4 = decodeJPData['data'][3]['outlet']['outlet_long'];
    JPResponsedata.outletareadata4 = decodeJPData['data'][3]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata4 = decodeJPData['data'][3]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata4 = decodeJPData['data'][3]['outlet']['outlet_city'];
    JPResponsedata.outletiddata5 = decodeJPData['data'][4]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata5 = decodeJPData['data'][4]['outlet']['outlet_name'];
    JPResponsedata.latitudedata5 = decodeJPData['data'][4]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata5 = decodeJPData['data'][4]['outlet']['outlet_long'];
    JPResponsedata.outletareadata5 = decodeJPData['data'][4]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata5 = decodeJPData['data'][4]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata5 = decodeJPData['data'][4]['outlet']['outlet_city'];
    JPResponsedata.outletiddata6 = decodeJPData['data'][5]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata6 = decodeJPData['data'][5]['outlet']['outlet_name'];
    JPResponsedata.latitudedata6 = decodeJPData['data'][5]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata6 = decodeJPData['data'][5]['outlet']['outlet_long'];
    JPResponsedata.outletareadata6 = decodeJPData['data'][5]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata6 = decodeJPData['data'][5]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata6 = decodeJPData['data'][5]['outlet']['outlet_city'];
    JPResponsedata.outletiddata7 = decodeJPData['data'][6]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata7 = decodeJPData['data'][6]['outlet']['outlet_name'];
    JPResponsedata.latitudedata7 = decodeJPData['data'][6]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata7 = decodeJPData['data'][6]['outlet']['outlet_long'];
    JPResponsedata.outletareadata7 = decodeJPData['data'][6]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata7 = decodeJPData['data'][6]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata7 = decodeJPData['data'][6]['outlet']['outlet_city'];
    JPResponsedata.outletiddata8 = decodeJPData['data'][7]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata8 = decodeJPData['data'][7]['outlet']['outlet_name'];
    JPResponsedata.latitudedata8 = decodeJPData['data'][7]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata8 = decodeJPData['data'][7]['outlet']['outlet_long'];
    JPResponsedata.outletareadata8 = decodeJPData['data'][7]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata8 = decodeJPData['data'][7]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata8 = decodeJPData['data'][7]['outlet']['outlet_city'];
    JPResponsedata.outletiddata9 = decodeJPData['data'][8]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata9 = decodeJPData['data'][8]['outlet']['outlet_name'];
    JPResponsedata.latitudedata9 = decodeJPData['data'][8]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata9 = decodeJPData['data'][8]['outlet']['outlet_long'];
    JPResponsedata.outletareadata9 = decodeJPData['data'][8]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata9 = decodeJPData['data'][8]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata9 = decodeJPData['data'][8]['outlet']['outlet_city'];
    JPResponsedata.outletiddata10 = decodeJPData['data'][9]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata10 = decodeJPData['data'][9]['outlet']['outlet_name'];
    JPResponsedata.latitudedata10 = decodeJPData['data'][9]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata10 = decodeJPData['data'][9]['outlet']['outlet_long'];
    JPResponsedata.outletareadata10 = decodeJPData['data'][9]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata10 = decodeJPData['data'][9]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata10 = decodeJPData['data'][9]['outlet']['outlet_city'];
    JPResponsedata.outletiddata11 = decodeJPData['data'][10]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata11 = decodeJPData['data'][10]['outlet']['outlet_name'];
    JPResponsedata.latitudedata11 = decodeJPData['data'][10]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata11 = decodeJPData['data'][10]['outlet']['outlet_long'];
    JPResponsedata.outletareadata11 = decodeJPData['data'][10]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata11 = decodeJPData['data'][10]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata11 = decodeJPData['data'][10]['outlet']['outlet_city'];
    JPResponsedata.outletiddata12 = decodeJPData['data'][11]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata12 = decodeJPData['data'][11]['outlet']['outlet_name'];
    JPResponsedata.latitudedata12 = decodeJPData['data'][11]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata12 = decodeJPData['data'][11]['outlet']['outlet_long'];
    JPResponsedata.outletareadata12 = decodeJPData['data'][11]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata12 = decodeJPData['data'][11]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata12 = decodeJPData['data'][11]['outlet']['outlet_city'];
    JPResponsedata.outletiddata13 = decodeJPData['data'][12]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata13 = decodeJPData['data'][12]['outlet']['outlet_name'];
    JPResponsedata.latitudedata13 = decodeJPData['data'][12]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata13 = decodeJPData['data'][12]['outlet']['outlet_long'];
    JPResponsedata.outletareadata13 = decodeJPData['data'][12]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata13 = decodeJPData['data'][12]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata13 = decodeJPData['data'][12]['outlet']['outlet_city'];
    JPResponsedata.outletiddata14 = decodeJPData['data'][13]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata14 = decodeJPData['data'][13]['outlet']['outlet_name'];
    JPResponsedata.latitudedata14= decodeJPData['data'][13]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata14 = decodeJPData['data'][13]['outlet']['outlet_long'];
    JPResponsedata.outletareadata14 = decodeJPData['data'][13]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata14 = decodeJPData['data'][13]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata14 = decodeJPData['data'][13]['outlet']['outlet_city'];
    JPResponsedata.outletiddata15 = decodeJPData['data'][14]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata15 = decodeJPData['data'][14]['outlet']['outlet_name'];
    JPResponsedata.latitudedata15 = decodeJPData['data'][14]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata15 = decodeJPData['data'][14]['outlet']['outlet_long'];
    JPResponsedata.outletareadata15 = decodeJPData['data'][14]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata15 = decodeJPData['data'][14]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata15 = decodeJPData['data'][14]['outlet']['outlet_city'];
    JPResponsedata.outletiddata16 = decodeJPData['data'][15]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata16 = decodeJPData['data'][15]['outlet']['outlet_name'];
    JPResponsedata.latitudedata16 = decodeJPData['data'][15]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata16 = decodeJPData['data'][15]['outlet']['outlet_long'];
    JPResponsedata.outletareadata16 = decodeJPData['data'][15]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata16 = decodeJPData['data'][15]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata16 = decodeJPData['data'][15]['outlet']['outlet_city'];
    JPResponsedata.outletiddata17 = decodeJPData['data'][16]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata17 = decodeJPData['data'][16]['outlet']['outlet_name'];
    JPResponsedata.latitudedata17 = decodeJPData['data'][16]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata17 = decodeJPData['data'][16]['outlet']['outlet_long'];
    JPResponsedata.outletareadata17 = decodeJPData['data'][16]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata17 = decodeJPData['data'][16]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata17 = decodeJPData['data'][16]['outlet']['outlet_city'];
    JPResponsedata.outletiddata18 = decodeJPData['data'][17]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata18 = decodeJPData['data'][17]['outlet']['outlet_name'];
    JPResponsedata.latitudedata18 = decodeJPData['data'][17]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata18 = decodeJPData['data'][17]['outlet']['outlet_long'];
    JPResponsedata.outletareadata18 = decodeJPData['data'][17]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata18 = decodeJPData['data'][17]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata18 = decodeJPData['data'][17]['outlet']['outlet_city'];
    JPResponsedata.outletiddata19 = decodeJPData['data'][18]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata19 = decodeJPData['data'][18]['outlet']['outlet_name'];
    JPResponsedata.latitudedata19 = decodeJPData['data'][18]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata19 = decodeJPData['data'][18]['outlet']['outlet_long'];
    JPResponsedata.outletareadata19 = decodeJPData['data'][18]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata19 = decodeJPData['data'][18]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata19 = decodeJPData['data'][18]['outlet']['outlet_city'];
    JPResponsedata.outletiddata20 = decodeJPData['data'][19]['outlet']['outlet_id'];
    JPResponsedata.outletnamedata20 = decodeJPData['data'][19]['outlet']['outlet_name'];
    JPResponsedata.latitudedata20 = decodeJPData['data'][19]['outlet']['outlet_lat'];
    JPResponsedata.longitudedata20 = decodeJPData['data'][19]['outlet']['outlet_long'];
    JPResponsedata.outletareadata20 = decodeJPData['data'][19]['outlet']['outlet_area'];
    JPResponsedata.outletcountrydata20 = decodeJPData['data'][19]['outlet']['outlet_country'];
    JPResponsedata.outletcitydata20 = decodeJPData['data'][19]['outlet']['outlet_city'];
  }
  if(JPresponse.statusCode != 200){
    print(JPresponse.statusCode);
  }
}