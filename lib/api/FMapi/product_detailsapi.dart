import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_service.dart';
Future<void> getProductDetails() async {

  http.Response PDresponse = await http.post(productdetails,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
  );
  if (PDresponse.statusCode == 200){
    print("getProductDetailsDone");

    String productdetails = PDresponse.body;
    var decodededproducts = jsonDecode(productdetails);

    productlist.productname = [];
    productlist.brandname = [];
    productlist.type = [];
    productlist.productcategory = [];
    productlist.clientid = [];
    productlist.brandid = [];
    productlist.priceperpiece = [];
    productlist.piecepercartoon = [];
    productlist.zrepcode = [];
    productlist.range = [];
    productlist.imageurl = [];

    print(decodededproducts['data'].length);
    for(int u=0;u<decodededproducts['data'].length;u++) {

      dynamic categoryname = '${decodededproducts['data'][u]['product_name']}';
      productlist.productname.add(categoryname);

      dynamic brandname = '${decodededproducts['data'][u]['brand_name']}';
      productlist.brandname.add(brandname);

      dynamic type = '${decodededproducts['data'][u]['type']}';
      productlist.type.add(type);

      dynamic categoryofpdts = '${decodededproducts['data'][u]['category_name']}';
      productlist.productcategory.add(categoryofpdts);

      dynamic sku = '${decodededproducts['data'][u]['sku']}';
      productlist.sku.add(sku);

      dynamic range = '${decodededproducts['data'][u]['range']}';
      productlist.range.add(range);

      var zrepcode = decodededproducts['data'][u]['zrep_code'];
      productlist.zrepcode.add(zrepcode);

      var piecepercartoon = decodededproducts['data'][u]['piece_per_carton'];
      productlist.piecepercartoon.add(piecepercartoon);

      var priceperpiece = decodededproducts['data'][u]['price_per_piece'];
      productlist.priceperpiece.add(priceperpiece);

      var brandid = decodededproducts['data'][u]['brand_id'];
      productlist.brandid.add(brandid);

      dynamic clientid = '${decodededproducts['data'][u]['client_id']}';
      productlist.clientid.add(clientid);

      dynamic imageurl = '${decodededproducts['data'][u]['Image_url']}';
      productlist.imageurl.add(imageurl);
      productlist.productid.add(decodededproducts['data'][u]['product_id']);
    }
    print("products : ${productlist.sku}");
  }
  if(PDresponse.statusCode != 200){
    print(PDresponse.statusCode);

  }
}

class productlist {
  static List<String> sku = [];
  static List<String> productname = [];
  static List<String> type = [];
  static List<String> range = [];
  static List<int> zrepcode = [];
  static List<String> brandname = [];
  static List<int> piecepercartoon = [];
  static List<int> priceperpiece = [];
  static List<int> brandid = [];
  static List<int> productid = [];
  static List<String> clientid = [];
  static List<String> productcategory = [];
  static List<String> imageurl = [];

}