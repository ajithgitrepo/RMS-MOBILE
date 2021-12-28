import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:merchandising/main.dart';
import '../api_service.dart';
import'package:merchandising/api/HRapi/empdetailsapi.dart';
import'package:merchandising/clients/FM_list.dart';


var token='eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZWQzNTcwYTllNDQ1ZTk1ZjUzM2VkMTdjM2IzMjg2ZjU5OTdlZGM3NTM2ZTYzZTAzNzcxZTIxOWQ5MmY5MDMzNjE5YzdjNTVlOTE4ODY0ZGEiLCJpYXQiOiIxNjIzMTMxMjMzLjMxNTYzNCIsIm5iZiI6IjE2MjMxMzEyMzMuMzE1NjQ1IiwiZXhwIjoiMTY1NDY2NzIzMy4yODAyMjgiLCJzdWIiOiI3NiIsInNjb3BlcyI6W119.g_LCuleJT0YXAhhYZlQTyUxWnV1BHqcYgh4DD5zo62vJimFGMiMXPhJ2Bladc6PoZYAH6XWQuMXQxAkObn9eQ9ps7CLo64H6Z4sJrTWCMcmCtHM6_L_Pm9D9Wsp9nVzJ8ILRgjru0gCgIuF58OxxZKWtH_nMXo6F7k0-naNi1KuJpfHKmWCzrx4mwlPIQZgHNykUmZUUn9N-wjtDmmXgjLy4KdATlHj428QV0b2Ka6wwonWz9CG8oLJjgAQWVY8h9sQNicXlnPEaahyuLXjduKpbLSTeZviZxRhw3Nn75oiXwaGVQ4QQvfs8pnA0izvqpbiqTZ8bCSfnHAk0yT_de_GU06eiF5NnmVa6Pqqmo2HeCWniv5pCDb2Aee_-3hT90Gf8lP-ZGMMTbn-elZwDMLwtwmppEoQ0V-XPfChKqN9qfOc3LcotB3BMwtD_ZRt1IrCgrdt076OUxIdR_bjHXfQ10ErMNqQmZ4SFEvWqk-DbXoQHe4caLLniO7UK71cKATMI1OW0ka95Vxo61crXKUTXaGp9opimxaJpxN2Vl2D8XHY1tvvsmyFvDNS7K7OpdWALqjm6WtTwY6mfHBEEuojTc3Yex9GbTO1pDLSjkFM8WEYiwUCnsgihdWzfXtb7nzVJfmBnRJrJu3jEZak_dIj3k_e2WIymq7QWhQ-I4vo';
Future getmerchnamelist() async{
  Map clientFM ={
    'emp_id': '${CLFM.empid}'
  };
  Map DBrequestData = {
    'emp_id': '${DBrequestdata.receivedempid}'
  };
  http.Response Merchname = await http.post(MercNameList,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': currentuser.roleid==5? 'Bearer ${DBrequestdata.receivedtoken}':currentuser.roleid==7?'Bearer ${token}':null,
    },
    body: currentuser.roleid==5?jsonEncode(DBrequestData):currentuser.roleid==7?jsonEncode(clientFM):null,
  );
  print("Client FM:${jsonEncode(clientFM)}");
  print("FM:${jsonEncode(DBrequestData)}");

  print(Merchname.body);
  if (Merchname.statusCode == 200){
    merchnamelist.employeeid = [];
    merchnamelist.firstname = [];
    merchnamelist.name = [];
    print('reporting details');
    String empdata = Merchname.body;
    var decodeddata = jsonDecode(empdata);
    for(int u=0;u<decodeddata['data'].length;u++) {
      merchnamelist.firstname.add('${decodeddata["data"][u]['first_name']} '
          '(${decodeddata["data"][u]['employee_id']})');
      merchnamelist.employeeid.add(decodeddata["data"][u]['employee_id']);
      merchnamelist.name.add('${decodeddata["data"][u]['first_name']}');
    }
  }
  print("MerchandiserNameList Done");
  print(merchnamelist.firstname);
  if(Merchname.statusCode != 200){
    print(Merchname.body);
  }
}

class merchnamelist {
  static List<String> employeeid = [];
  static List<String> firstname=[];
  static List<String> name=[];
}


Future merchnamelistunderCDE() async{

  Map DBrequestData = {
    'emp_id': '${DBrequestdata.receivedempid}'
  };


  http.Response Merchname = await http.post(Merchlistundercde,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization':  'Bearer ${DBrequestdata.receivedtoken}',
    },
    body:jsonEncode(DBrequestData),
  );

  print(Merchname.body);
  if (Merchname.statusCode == 200){
    MerchUnderCDE.employeeid = [];
    MerchUnderCDE.firstname = [];
    MerchUnderCDE.name = [];

    String empdata = Merchname.body;
    var decodeddata = jsonDecode(empdata);
    for(int u=0;u<decodeddata['data'].length;u++) {
      MerchUnderCDE.firstname.add('${decodeddata["data"][u]['first_name']}'
          '(${decodeddata["data"][u]['employee_id']})');
      MerchUnderCDE.employeeid.add(decodeddata["data"][u]['employee_id']);
      MerchUnderCDE.name.add('${decodeddata["data"][u]['first_name']}');
    }
  }
  print("MerchandiserNameList under CDE Done");

  if(Merchname.statusCode != 200){
    print(Merchname.body);
  }
}

class MerchUnderCDE{
  static List<String> employeeid = [];
  static List<String> firstname=[];
  static List<String> name=[];

}
//${decodeddata["data"][u]['surname']}