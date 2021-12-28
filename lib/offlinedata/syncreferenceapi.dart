import 'package:merchandising/api/api_service.dart';
import 'package:merchandising/offlinedata/syncdata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:merchandising/offlinedata/sharedprefsdta.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/merchandiserdashboard.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter_launcher_icons/constants.dart';
import 'dart:convert';
import 'package:merchandising/Constants.dart';
import 'package:intl/intl.dart';
import 'package:merchandising/api/Journeyplansapi/todayplan/journeyplanapi.dart';
import 'package:merchandising/api/Journeyplansapi/todayplan/jpskippedapi.dart';
import 'package:merchandising/api/Journeyplansapi/todayplan/JPvisitedapi.dart';
import 'package:merchandising/api/Journeyplansapi/weekly/jpplanned.dart';
import 'package:merchandising/api/Journeyplansapi/weekly/jpskipped.dart';
import 'package:merchandising/api/Journeyplansapi/weekly/jpvisited.dart';
import 'package:merchandising/api/empdetailsapi.dart';
import 'package:merchandising/model/database.dart';
import 'package:merchandising/api/HRapi/empdetailsforreportapi.dart';
import 'package:merchandising/api/HRapi/empdetailsapi.dart';
DateTime lastsyncedon;
DateTime lastsyncedendtime;
Duration difference;
List<Uri>urlstosync=[];
List<Map>bodytosync=[];
List<String>sucessmsgaftersync=[];

syncingreferencedata()async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  lastsyncedon = DateTime.parse(prefs.getString('lastsyncedondate'));
  if(lastsyncedon!=null){
    lastsyncedendtime = DateTime.parse(prefs.getString('lastsyncedonendtime'));
     difference = DateTime.now().difference(lastsyncedendtime);
     print("difference: ${difference.inMinutes}");
     print("${DateFormat('yyyy-MM-dd').format(lastsyncedon)} = ${DateFormat('yyyy-MM-dd').format(DateTime.now())}");
  }
    if (currentlysyncing && onlinemode.value) {
      currentlysyncing = true;
      currentstep = 0;
      print("Syncing");
      var date = DateTime.now();
      var starttime = DateTime.now();
      loginfromloginpage = false;
      await loginapi();
      // progress.value = 25;
      await getJourneyPlan();
      await SOSDetailsoffline();
      PlanoDetailsoffline();
      await PromoDetailsoffline();
      await CheckListDetailsoffline();
      // progress.value = 35;
      getallempdetails();
      getempdetails();
      // progress.value = 40;
      getaddedexpiryproducts();
      getstockexpiryproducts();
      getempdetailsforreport();
      DBRequestmonthly();
      getskippedJourneyPlan();
      getvisitedJourneyPlan();
      getJourneyPlanweekly();
      getSkipJourneyPlanweekly();
      getVisitJourneyPlanweekly();
      Expectedchartvisits();
      chartvisits();
      progress.value=85;
      await getalljpoutletsdata();
      NBLdetailsoffline();
      VisibilityDetailsoffline();
       progress.value = 97;
      await DBRequestdaily();
       progress.value = 99;
      currentlysyncing = false;
      var endtime = DateTime.now();
      await lastsynced(date, starttime, endtime);
       progress.value = 100;
    }else{
      DBRequestmonthly();
      getaddedexpiryproducts();
      getempdetails();
      getempdetailsforreport();
      getstockexpiryproducts();
      await DBRequestdaily();
      await callfrequently();
      getempdetails();
      getallempdetails();
      getaddedexpiryproducts();
      getstockexpiryproducts();
      getempdetailsforreport();
      getJourneyPlan();
      getskippedJourneyPlan();
      getvisitedJourneyPlan();
      getSkipJourneyPlanweekly();
      getVisitJourneyPlanweekly();
      getJourneyPlanweekly();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      offlineoutletdeatiles = prefs.getStringList('alljpoutlets');
      outletvisitsdata = prefs.getStringList('alljpoutletschart');
      outletEvisitsdata = prefs.getStringList('alljpoutletsEchart');
      offlinevisibilitydata=prefs.getStringList('visibilitydetdata');
      offlinesosdata=prefs.getStringList('shareofshelfdetdata');
      offlineplanodata=prefs.getStringList('planodetaildata');
      offlinepromodata=prefs.getStringList('promodetaildata');
      offlinechecklistdata=prefs.getStringList('checklistdetaildata');
      offlinenbldata = prefs.getStringList('nbldetaildata');
      const time = const Duration(seconds: 120);
      Timer.periodic(time, (Timer t) => callfrequently());
    }
}


getalljpoutletsdata()async{
  offlineoutletdeatiles=[];
  print("length:${gettodayjp.outletids.length}");
  for(int i=0;i<gettodayjp.outletids.length;i++){
    progress.value++;
    int outletid = gettodayjp.outletids[i];
    Map ODrequestDataforcheckin = {
      "emp_id": "${DBrequestdata.receivedempid}",
      'outlet_id': '$outletid',
    };
    print(ODrequestDataforcheckin);
    print("outlet when check in");
    http.Response OCresponse = await http.post(OCurl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
      },
      body: jsonEncode(ODrequestDataforcheckin),
    );
    if(OCresponse.statusCode == 200){
      offlineoutletdeatiles.add(OCresponse.body);
    }
  }
  Addjpoutletsdetailesdata(offlineoutletdeatiles);
}
chartvisits()async{
  outletvisitsdata=[];
  for(int i=0;i<gettodayjp.outletids.length;i++){
    int outletid = gettodayjp.outletids[i];
    Map ODrequestDataforcheckin = {
      'outlet_id': outletid,
    };
    print(ODrequestDataforcheckin);
    http.Response OCResponse = await http.post(ChartUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
      },
      body: jsonEncode(ODrequestDataforcheckin),
    );
    if(OCResponse.statusCode == 200){
      outletvisitsdata.add(OCResponse.body);
    }
  }
  Addjpoutletschartdetailesdata(outletvisitsdata);
}

Expectedchartvisits()async{
  outletEvisitsdata=[];
  for(int i=0;i<gettodayjp.outletids.length;i++){
    int outletid = gettodayjp.outletids[i];
    Map ODrequestDataforcheckin = {
      'outlet_id': outletid,
    };
    print(ODrequestDataforcheckin);
    http.Response OCResponse = await http.post(expectedvisitchart,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
      },
      body: jsonEncode(ODrequestDataforcheckin),
    );
    if(OCResponse.statusCode == 200){
      outletEvisitsdata.add(OCResponse.body);
    }
  }
  AddjpoutletsEchartdetailesdata(outletEvisitsdata);
}

VisibilityDetailsoffline()async{
  offlinevisibilitydata=[];
  for(int i=0;i<gettodayjp.id.length;i++){
    int timesheetid = gettodayjp.id[i];
    Map body = {
      "time_sheet_id" : "$timesheetid"
    };
    print("visibility");
    print(body);
    http.Response OCResponse = await http.post(VisibilityDetails,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
      },
      body: jsonEncode(body),
    );
    if(OCResponse.statusCode == 200){
      offlinevisibilitydata.add(OCResponse.body);
    }
  }
  Visibilitydetail(offlinevisibilitydata);
}


SOSDetailsoffline()async{
  offlinesosdata=[];
  for(int i=0;i<gettodayjp.id.length;i++){
    progress.value++;
    int timesheetid = gettodayjp.id[i];
    Map body = {
      "time_sheet_id" : "$timesheetid"
    };
    print("Share of shelf");
    print(body);
    http.Response OCResponse = await http.post(ShareofshelfDetails,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
      },
      body: jsonEncode(body),
    );
    print(OCResponse.body);
    if(OCResponse.statusCode == 200){
      offlinesosdata.add(OCResponse.body);
    }
    print("share of shelf list length:${offlinesosdata.length}");
  }
  sosdetail(offlinesosdata);
}


PlanoDetailsoffline()async{
  offlineplanodata=[];
  for(int i=0;i<gettodayjp.id.length;i++){

    int timesheetid = gettodayjp.id[i];
    Map body = {
      "time_sheet_id" : "$timesheetid"
    };
    print("planogram");
    print(body);
    http.Response OCResponse = await http.post(PlanogramDetails,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
      },
      body: jsonEncode(body),
    );
    print(OCResponse.body);
    if(OCResponse.statusCode == 200){
      offlineplanodata.add(OCResponse.body);
    }
    print("share of shelf list length:${offlineplanodata.length}");
  }
  planodetail(offlineplanodata);
}


PromoDetailsoffline()async{
  offlinepromodata=[];
  for(int i=0;i<gettodayjp.outletids.length;i++){
    progress.value++;
    int outletid = gettodayjp.outletids[i];
    Map body = {
      "outlet_id" : "$outletid"
    };
    print("promotion");
    print(body);
    http.Response OCResponse = await http.post(PromoDetails,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
      },
      body: jsonEncode(body),
    );
    print("promotion details response");
    print(OCResponse.body);
    if(OCResponse.statusCode == 200){
      offlinepromodata.add(OCResponse.body);
    }

  }
  promodetail(offlinepromodata);
}


CheckListDetailsoffline()async{
  offlinechecklistdata=[];
  for(int i=0;i<gettodayjp.outletids.length;i++){
    progress.value++;
    int outletid = gettodayjp.outletids[i];
    Map body = {
      "outlet_id" : "$outletid"
    };
    print("checklist");
    print(body);
    http.Response OCResponse = await http.post(taskdetailes,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
      },
      body: jsonEncode(body),
    );
    print("checklist details response");
    print(OCResponse.body);
    if(OCResponse.statusCode == 200){
      offlinechecklistdata.add(OCResponse.body);
    }

  }
  checklistdetail(offlinechecklistdata);
}


NBLdetailsoffline()async{
  offlinenbldata=[];
  for(int i=0;i<gettodayjp.outletids.length;i++){
    int outletid = gettodayjp.outletids[i];
    Map ODrequestDataforcheckin = {
      'outlet_id': outletid,
    };
    print(ODrequestDataforcheckin);
    http.Response OCResponse = await http.post(NBLDetailsFMs,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
      },
      body: jsonEncode(ODrequestDataforcheckin),
    );
    if(OCResponse.statusCode == 200){
      offlinenbldata.add(OCResponse.body);
    }
  }
  NBLdetail(offlinenbldata);
}
