import 'package:merchandising/Merchandiser/merchandiserscreens/expiry_report.dart';
import 'package:merchandising/api/api_service.dart';
import 'package:intl/intl.dart';
import 'package:merchandising/Constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:merchandising/Merchandiser/merchandiserscreens/expiry_report.dart';
import 'package:merchandising/offlinedata/sharedprefsdta.dart';
import 'package:merchandising/offlinedata/syncsendapi.dart';
import 'package:merchandising/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:merchandising/offlinedata/sharedprefsdta.dart';
List<dynamic>addedproductid=[];


// getproducts()async{
//   var conn = await MySqlConnection.connect(databse.settings);
//   var data = await conn.query('select id,zrep,material_description,barcode_cs,barcode_bs,barcode_pc from product');
//   if(data!=null){
//     for(int i = 0; i < data.length; i++){
//       Expiry.id.add(data.toList()[i]["id"]);
//       Expiry.zrepcodes.add(data.toList()[i]["zrep"]);
//       Expiry.sku.add(data.toList()[i]["material_description"]);
//       Expiry.barcode_bs.add(data.toList()[i]["barcode_cs"]);
//       Expiry.barcode_cs.add(data.toList()[i]["barcode_bs"]);
//       Expiry.barcode_ps.add(data.toList()[i]["barcode_pc"]);
//     }
//     print( Expiry.id.length);
//     print( Expiry.zrepcodes.length);
//     print( Expiry.sku.length);
//     print( Expiry.barcode_bs.length);
//     print( Expiry.barcode_cs.length);
//     print( Expiry.barcode_ps.length);
//   }
//   await getaddedsku();
//   return "done";
// }

class Expiry{
  static List<String>productfullname=[];
  static List<int>id=[];
  static List<String>zrepcodes=[];
  static List<String>sku=[];
  static List<String>barcodes=[];
  static List<String>productdetails=[];
  static List<String>type=[];
  static List<String>range=[];
  static List<int>priceofitem=[];
  static List<String>barcode=[];
}

// AddData()async{
//   var conn = await MySqlConnection.connect(databse.settings);
//   print('insert into stock_expiry( customer_outlet_id, product_id, copack_regular, near_expiry_in_pc, pc_expiry_date, period, exposure_qty_will_expire_in_pc, price_pc, near_expiry_in_cs, price_cs, cs_expiry_date, near_expiry_in_bs, price_bs, bs_expiry_date, exposure_expiry_in_cs, exposure_expiry_in_bs, action_to_be_filled_by_cde, client_id, remarks) values(    \"$Storecode\", \"$productid\",\"$packtypeselected\",   \"$expirypc\",\"$pcexpirydate\",\"$periodchoosed\",   \"$exposureqntypc\",    \"$pricepc\",   \"$expirycs\",\"$pricecs\",\"$csexpirydate\",\"$expirybs\", \"$pricebs\",\"$bsexpirydate\",\"$exposureqntycs\",\"$exposureqntybs\",\"${DBrequestdata.receivedempid}\",\"0\",\"$remarksifany\")');
//   await conn.query('insert into stock_expiry( customer_outlet_id, product_id, copack_regular, near_expiry_in_pc, pc_expiry_date, period, exposure_qty_will_expire_in_pc, price_pc, near_expiry_in_cs, price_cs, cs_expiry_date, near_expiry_in_bs, price_bs, bs_expiry_date, exposure_expiry_in_cs, exposure_expiry_in_bs, action_to_be_filled_by_cde, client_id, remarks) '
//       'values(    \"$Storecode\", \"$productid\",\"$packtypeselected\",   \"$expirypc\",\"$pcexpirydate\",\"$periodchoosed\",   \"$exposureqntypc\",    \"$pricepc\",   \"$expirycs\",\"$pricecs\",\"$csexpirydate\",\"$expirybs\", \"$pricebs\",\"$bsexpirydate\",\"$exposureqntycs\",\"$exposureqntybs\",\"${DBrequestdata.receivedempid}\",\"0\",\"$remarksifany\")');
//   return true;
//
// }
var Storecode;
var productid;
var packtypeselected;
var expirypc;
var pcexpirydate;
var periodchoosed;
var exposureqntypc;
var pricepc;
var expirycs;
var csexpirydate;
var exposureqntycs;
var pricecs;
var expirybs;
var bsexpirydate;
var exposureqntybs;
var pricebs;
var filledby;
var remarksifany;
var productlocation;
var customerstoregroup;
var uom;

String brand;
Future getstockexpiryproducts() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  brand = prefs.getString('expiryproductsdata');
  if (brand == null || currentlysyncing) {
    http.Response Response = await http.post(stockexpiryDetails,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
      },
    );
    if (Response.statusCode == 200) {
      print("stockexpirydone");
      String brand = Response.body;
      Expiryreportproducts(brand);
      Expiryreportproducts(brand);
      var decodebrands = jsonDecode(brand);
      for (int u = 0; u < decodebrands['data'].length; u++) {
        Expiry.id.add(decodebrands['data'][u]["id"]);
        Expiry.zrepcodes.add(decodebrands['data'][u]["zrep_code"].toString());
        Expiry.sku.add(decodebrands['data'][u]["sku"]);
        Expiry.productdetails.add(decodebrands['data'][u]["product_name"]);
        Expiry.barcode.add(decodebrands['data'][u]["barcode"].toString());
        Expiry.type.add(decodebrands['data'][u]["type"]);
        Expiry.range.add(decodebrands['data'][u]["range"]);
        Expiry.priceofitem.add(decodebrands['data'][u]["price_per_piece"]);
        Expiry.productfullname.add(
            "${decodebrands['data'][u]["product_name"]}-${decodebrands['data'][u]["zrep_code"]}-${decodebrands['data'][u]["sku"]}-${decodebrands['data'][u]["barcode"]}");
      }
      // print(Expiry.barcode);
    }
  }else {
    var decodebrands = jsonDecode(brand);
    for (int u = 0; u < decodebrands['data'].length; u++) {
      Expiry.id.add(decodebrands['data'][u]["id"]);
      Expiry.zrepcodes.add(decodebrands['data'][u]["zrep_code"].toString());
      Expiry.sku.add(decodebrands['data'][u]["sku"]);
      Expiry.productdetails.add(decodebrands['data'][u]["product_name"]);
      Expiry.barcode.add(decodebrands['data'][u]["barcode"].toString());
      Expiry.type.add(decodebrands['data'][u]["type"]);
      Expiry.range.add(decodebrands['data'][u]["range"]);
      Expiry.priceofitem.add(decodebrands['data'][u]["price_per_piece"]);
      Expiry.productfullname.add(
          "${decodebrands['data'][u]["product_name"]}-${decodebrands['data'][u]["zrep_code"]}-${decodebrands['data'][u]["sku"]}-${decodebrands['data'][u]["barcode"]}");
    }
  }
}
int addedexpiryindex;
Future<int> addexpiryproducts() async{
  Map stockdata = {
    "timesheet_id" : currenttimesheetid,
    "product_id": productid,
    "piece_price" :  pricepc,
    "near_expiry"  :  expirypc,
    "expiry_date" : pcexpirydate,
    "exposure_qty"  : exposureqntypc,
    "remarks" : remarksifany,
    "prodcut_location" : productlocation,
     "customer_storegroup" : customerstoregroup,
     "uom" : uom,

};
  print(jsonEncode(stockdata));
  adddataforsync("https://rms2.rhapsody.ae/api/add_stock_expiry_new",jsonEncode(stockdata),"expiry report for product id :$productid for the timesheet $currenttimesheetid, items count : $expirypc, expiry date : $pcexpirydate");
   //http.Response Response = await http.post(addexpiryDetail,
  //   headers: {
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //     'Authorization': 'BeaKrer ${DBrequestdata.receivedtoken}',
  //   },
  //      body: jsonEncode(stockdata),
  // );
  // print(Response.body);
  }


//
Future getaddedexpiryproducts() async {
  Map stockdata = {
    "merchandiser_id": "${DBrequestdata.receivedempid}",
  };
  print(jsonEncode(stockdata));
  http.Response productsresponse = await http.post(addedstockexpiryDetails,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
    body: jsonEncode(stockdata),
  );
  print('added products:${productsresponse.body}');
  if (productsresponse.statusCode == 200) {
    String data = productsresponse.body;
    var decodeData = jsonDecode(data);
    for (int u = 0; u < decodeData['data'].length; u++) {
      addedproductname.add(decodeData['data'][u]["product_name"]);
      addedexpirydate.add(decodeData['data'][u]["expiry_date"]);
      addeditemscounts.add(decodeData['data'][u]["near_expiry"]);
    }
    print(addedexpirydate);
  }
}
List<dynamic>addeditemscounts=[];