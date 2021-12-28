import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_service.dart';
import 'package:merchandising/Fieldmanager/products.dart';
Future<void> getmappedoutlets() async {
  Map body ={
    "outlet_id": currentoutletid,
  };
  print(jsonEncode(body));
  http.Response BDResponse = await http.post(outletbrandmapping,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
    body: jsonEncode(body),
  );
  if (BDResponse.statusCode == 200){
    print("getOutlet Brand Mapping Done");
    String brand = BDResponse.body;
    var decodebrands = jsonDecode(brand);
    mapping.outletid=[];
    mapping.outletname=[];
    mapping.opmid=[];
    mapping.categoryname=[];
    mapping.outletaddress=[];
    mapping.outletnumber=[];
    mapping.planogramimage=[];
    mapping.shelf=[];
    mapping.outletid=[];
    mapping.target=[];
    for(int u=0;u<decodebrands['data'].length;u++) {
      if(decodebrands['data'][u]['store_code'] != null){
        if(decodebrands['data'][u]['category_name']!=null){
          mapping.opmid.add(decodebrands['data'][u]['id']);
          mapping.outletname.add('[${decodebrands['data'][u]['store_code']}] ${decodebrands['data'][u]['store_name'].toString()}');
          mapping.categoryname.add(decodebrands['data'][u]['category_name']);
          mapping.outletaddress.add(decodebrands['data'][u]['address'].toString());
          mapping.outletnumber.add(decodebrands['data'][u]['contact_number'].toString());
          mapping.planogramimage.add(decodebrands['data'][u]['planogram_img']);
          mapping.shelf.add(decodebrands['data'][u]['shelf']);
          mapping.target.add(decodebrands['data'][u]['target']);
          mapping.outletid.add(decodebrands['data'][u]['outlet_id']);
          mapping.pdfurl.add("https://rms2.rhapsody.ae/nbl_file/${decodebrands['data'][u]['nbl_pdf']}");
        }
      }
      }
    Distictcategorylist=mapping.categoryname.toSet().toList();
    print("elements : ${mapping.opmid}");
    print(mapping.pdfurl.length);
    print(mapping.pdfurl);
  }
  if(BDResponse.statusCode != 200){
    print(BDResponse.statusCode);
  }
}
List<String>Distictcategorylist=[];

class mapping {
  static List<String> outletname = [];
  static List<int> opmid = [];
  static List<String> outletaddress = [];
  static List<String> outletnumber = [];
  static List<String> shelf = [];
  static List<String> target = [];
  static List<dynamic> planogramimage = [];
  static List<String> categoryname = [];
  static List<int>outletid =[];
  static List<String>pdfurl =[];
}

Future<void> delcategory() async {
  Map body = {
    "outlet_products_mapping_id": delcategoryid,
  };
  print(jsonEncode(body));
  http.Response response = await http.post(delcategorymapping,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
    },
    body: jsonEncode(body),
  );
  print(response.body);
}
int delcategoryid;