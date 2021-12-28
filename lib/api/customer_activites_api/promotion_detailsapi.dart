import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_service.dart';
import 'package:merchandising/main.dart';
Future<void> getPromotionDetails() async {
  // Map DBrequestData = {
  //   'outlet_id': currentoutletid
  // };
  // print(jsonEncode(DBrequestData));
  // http.Response promoresponse = await http.post(PromoDetails,
  //   headers: {
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
  //   },
  //     body: jsonEncode(DBrequestData),
  // );
  // print(promoresponse.body);
  // if (promoresponse.statusCode == 200){
    print("getPromotion Details Done");
    String stores = offlinepromodata[currentoutletindex];
    var decodestores = jsonDecode(stores);


    if(decodestores['data'].length==0){
      print("No Data");
      PromoData.nodata = "nodata";
      print(PromoData.nodata);

    }
    PromoData.outletid = [];
    PromoData.productname = [];
    PromoData.fromdate = [];
    PromoData.todate = [];
    PromoData.description = [];
    PromoData.storename = [];
    PromoData.productid = [];
    for(int u=0;u<decodestores['data'].length;u++) {
      // if(decodestores['data'][u]['product_name'] != null && decodestores['data'][u]['outlet_id'] == currentoutletid){
          PromoData.productname.add(decodestores['data'][u]['product_name']);
          PromoData.outletid.add(decodestores['data'][u]['outlet_id']);
          PromoData.storename.add(decodestores['data'][u]['store_name']);
          PromoData.fromdate.add(decodestores['data'][u]['from_date']);
          PromoData.productid.add(decodestores['data'][u]['product_id']);
          PromoData.todate.add(decodestores['data'][u]['to_date']);
          PromoData.description.add( decodestores['data'][u]['description']);

          if(decodestores['data'][u]['is_available'] == '0'){
            PromoData.oospdtdata.add(decodestores['data'][u]['product_name']);
            PromoData.oosreason.add(decodestores['data'][u]['reason']);
          }else{
            PromoData.inspdtdata.add(decodestores['data'][u]['product_name']);
            promocheck=true;
            PromoData.insimage.add('https://rms2.rhapsody.ae/product_image/${decodestores['data'][u]['Image_url']}');
          }
          print("mowa ikkada okasa look yee : ${decodestores['data'][u]['is_available']}");
          if(decodestores['data'][u]['is_available']!= null){
            print("check");
            promocheck=true;
          }
        }
    // }
    print(PromoData.productname);
  // }
  // if(promoresponse.statusCode != 200){
  //   print(promoresponse.statusCode);
  //
  // }
}

class PromoData {
  static List<int> outletid = [];
  static List<String> storename = [];
  static List<String> productname = [];
  static List<String> fromdate = [];
  static List<String> todate = [];
  static List<String> description = [];
  static List<int> productid = [];

  static List<String> inspdtdata=[];
  static List<String> oospdtdata=[];
  static List<String> insimage = [];
  static List<String> oosreason = [];
  static List<String> isavail = [];
  static var nodata;
}
bool promocheck = false;