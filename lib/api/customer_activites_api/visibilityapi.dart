import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:merchandising/api/api_service.dart';
import 'dart:async';
import 'dart:io';
import 'package:merchandising/Merchandiser/merchandiserscreens/Visibility.dart';
Future<void> getVisibility() async {
  // Map body = {
  //   "time_sheet_id" : "$currenttimesheetid"
  // };
  // http.Response VisibilityResponse = await http.post(VisibilityDetails,
  //   headers: {
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
  //   },
  //   body: jsonEncode(body),
  // );
  // if (VisibilityResponse.statusCode == 200) {
  //   print(body);
    VisibilityData.productid = [];
    VisibilityData.brandid = [];
    VisibilityData.productname = [];
    VisibilityData.categoryid = [];
    VisibilityData.categoryname = [];
    VisibilityData.isavailable = [];
    VisibilityData.reason = [];
    VisibilityData.imageurl = [];
    VisibilityData.inscatdata=[];
    VisibilityData.insimage = [];
    VisibilityData.oosreason = [];
    VisibilityData.ooscatdata=[];

    print('Visibility done');

    String availabititybody = offlinevisibilitydata[currentoutletindex];
    var decodeddata = jsonDecode(availabititybody);
    if(decodeddata['data'].length==0){
      print("No Data");
      VisibilityData.nodata = "nodata";
      print(VisibilityData.nodata);

    }

    for (int u = 0; u< decodeddata['data'].length; u++) {
      if(decodeddata['data'][u]['category_name'] != null){
        VisibilityData.productname.add(decodeddata['data'][u]['p_name']);
        VisibilityData.imageurl.add(decodeddata['data'][u]['image_url']);
        VisibilityData.categoryid.add(decodeddata['data'][u]['c_id']);
        VisibilityData.categoryname.add(decodeddata['data'][u]['category_name']);
        VisibilityData.productid.add(decodeddata['data'][u]['product_id']);
        VisibilityData.mappingid=decodeddata['data'][u]['opm'];
        VisibilityData.isavailable.add(decodeddata['data'][u]['is_available']);
        if(decodeddata['data'][u]['is_available'] == '0'){
          print("yes");
          VisibilityData.ooscatdata.add(decodeddata['data'][u]['category_name']);
          VisibilityData.oosreason.add(decodeddata['data'][u]['reason']);
        }else if(decodeddata['data'][u]['is_available'] == '1'){
          print("Ohh double yes");
          visibilitycheck = true;
          print(decodeddata['data'][u]['image_url']);
          VisibilityData.inscatdata.add(decodeddata['data'][u]['category_name']);
          VisibilityData.insimage.add('https://rms2.rhapsody.ae/visibility_image/${decodeddata['data'][u]['image_url']}');
        }
      }
    }
    comid = VisibilityData.mappingid;
    addGarea=[];
    for (int i = 0;
    i < VisibilityData.productname.length;
    i++) {
      images.add(File('dummy.txt'));
      visibilityreasons.add('');
      checkvaluevisibility.add(1);
      addGarea = new List.generate(VisibilityData.categoryname.length, (i) => []);
      addmainaisle = new List.generate(VisibilityData.categoryname.length, (i) => []);
      addpois = new List.generate(VisibilityData.categoryname.length, (i) => []);
      // addGarea.add("");
      // addMain.add("");
      // addPOI.add("");
      addpoibool.add(true);
    }
    print("visibility");
    print(VisibilityData.isavailable);
    //await getBrandDetails();
    // VisibilityData.brandid=[];
    // for(int u = 0; u<VisibilityData.categoryid.length; u++){
    //   //VisibilityData.brandid.add(BrandData.brandid[BrandData.brandname.indexOf(VisibilityData.categoryid[u])]);
    // }
  }
// }



class VisibilityData{
  static var mappingid;
  static List<int> productid=[];
  static List<int> brandid=[];
  static List<String> productname=[];
  static List<int> categoryid = [];
  static List<String> categoryname = [];
  static List<String> isavailable=[];
  static List<String> reason=[];
  static List<String> imageurl = [];
  static List<String> inscatdata=[];
  static List<String> ooscatdata=[];
  static List<String> insimage = [];
  static List<String> oosreason = [];
  static List<String> isavail=[];
  static String nodata;

}
bool visibilitycheck = false;





