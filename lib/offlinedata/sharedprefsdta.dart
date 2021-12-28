import 'package:merchandising/api/customer_activites_api/add_competitionapi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import'package:merchandising/Merchandiser/merchandiserscreens/CompetitionCheckOne.dart';
import 'dart:convert';
import 'dart:async';

import 'package:merchandising/api/api_service.dart';
import 'package:intl/intl.dart';



String base64Image;
adduserdetails(logindata) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('logindata', logindata);
  }
lastsynced (date,starttime,endtime) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('lastsyncedondate', "$date");
  prefs.setString('lastsyncedonstarttime', "$starttime");
  prefs.setString('lastsyncedonendtime', "$endtime");
}

 plannedjpweekly(weeklyjplan)async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setString("journeyplanweekly",weeklyjplan );
 }
addskippedjpweekly(weeklyjplan)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("skjourneyplanweekly",weeklyjplan );
}
addvisitedjpweekly(weeklyjplan)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("vstjourneyplanweekly",weeklyjplan );
}

 adddailydashboardmerch(dbdaily)async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.setString("dbdailymerch",dbdaily);
   print("dbdailymerchadded");
 }
adddailymonthlymerch(dbmonthly)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("dbmontlymerch",dbmonthly);
}

addtodayjp(todayjp)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("todayjp",todayjp);
}

addtodayskipped(todayskipped)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("todayskipped",todayskipped);
}

addtodayvisited(todayvisited)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("todayvisited",todayvisited);
}

Addjpoutletsdetailesdata(data)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("alljpoutlets",data);
}

Addjpoutletschartdetailesdata(data)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("alljpoutletschart",data);
}
AddjpoutletsEchartdetailesdata(data)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("alljpoutletsEchart",data);
}
addempdetailesdata(data)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("empdetails",data);
}


Adddatatoserver(urls,body,meesage)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("addtoserverurl",urls);
  prefs.setStringList("addtoserverbody",body);
  prefs.setStringList("addtoservermessage",meesage);
}
removesenddatafromlocal()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("addtoserverurl");
  prefs.remove("addtoserverbody");
  prefs.remove("addtoservermessage");
}

Expiryreportproducts(data)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("expiryproductsdata",data);
}
addempdetailesreport(data)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("empdetailesreport",data);
}

savelogreport(data,time,status)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("logdata",data);
  prefs.setStringList("logtime",time);
  prefs.setStringList("status",status);
}

allempsdata(data)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("allemployees",data);
}

currentpagestatus(pageid,outletid,timesheetid,currentoutletindex)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("pageiddata",pageid);
  prefs.setString("outletiddata", outletid);
  prefs.setString("timesheetiddata",timesheetid);
  prefs.setString('currentoutletindexdata', currentoutletindex);

}


Visibilitydetail(data)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("visibilitydetdata",data);
}

sosdetail(data)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("shareofshelfdetdata",data);
}

planodetail(data)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("planodetaildata",data);
}

///for competition details,only sending the data,not referening(syncreference)

promodetail(data)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("promodetaildata",data);
}


checklistdetail(data)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("checklistdetaildata",data);
}

NBLdetail(data)async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList("nbldetaildata",data);
}


SaveCompetitionData()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("companydata","${company.text}");
  prefs.setString("categorydata",category.text);
  prefs.setString("itemdata",itemname.text);
  prefs.setString("promotypedata",promotiontype.text);
  prefs.setString("promodescdata",promodscrptn.text);
  prefs.setString("regpricedata",mrp.text);
  prefs.setString("sellpricedata",sellingprice.text);

  // print("check 1 comp");
  // var imagesbytescomp =capturedimage.readAsBytesSync();
  // print("check 2 comp");
  // base64Image = base64Encode(imagesbytescomp);
  // print("check 3 comp");
  // prefs.setString("capimgdata", base64Image);
  // print("check 4 comp");
  // print("compimage: ${base64Image}");
  // var savedimg = 'data:image/jpeg;base64,${base64Encode(imagesbytes)}';
  // prefs.setString("capimgdata",capturedcopmtnimg);

}


RemoveCompetitionData()async{
  print("remove competition data");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("companydata");
  prefs.remove("categorydata");
  prefs.remove("itemdata");
  prefs.remove("promotypedata");
  prefs.remove("promodescdata");
  prefs.remove("regpricedata");
  prefs.remove("sellpricedata");
  prefs.remove("capimgdata");

}





