import 'dart:convert';

import 'package:merchandising/Merchandiser/merchandiserscreens/Customers%20Activities.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/expiry_report.dart';
import 'package:merchandising/offlinedata/syncreferenceapi.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/Constants.dart';
import 'package:merchandising/api/api_service.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/Journeyplan.dart';
import 'package:merchandising/model/rememberme.dart';
import 'model/Location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:merchandising/api/Journeyplansapi/weekly/jpskipped.dart';
import 'package:merchandising/api/Journeyplansapi/weekly/jpvisited.dart';
import 'package:merchandising/api/Journeyplansapi/weekly/jpplanned.dart';
import 'package:merchandising/api/Journeyplansapi/todayplan/journeyplanapi.dart';
import 'package:merchandising/api/Journeyplansapi/todayplan/jpskippedapi.dart';
import 'package:merchandising/api/Journeyplansapi/todayplan/JPvisitedapi.dart';
import 'package:merchandising/api/empdetailsapi.dart';
import 'package:merchandising/api/noti_detapi.dart';
import 'api/FMapi/outlet brand mappingapi.dart';
import 'login_page.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/merchandiserdashboard.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/CompetitionCheckOne.dart';
import 'dart:async';
import 'model/rememberme.dart';
import 'api/FMapi/relieverdet_api.dart';
import 'api/api_service.dart';
import 'package:merchandising/HR/HRdashboard.dart';
import 'api/HRapi/hrdashboardapi.dart';
import 'package:merchandising/Fieldmanager/FMdashboard.dart';
import 'dart:convert';
import 'api/FMapi/fmdbapi.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:merchandising/api/FMapi/fmdbapi.dart';
import 'offlinedata/syncsendapi.dart';
import 'package:merchandising/api/FMapi/storedetailsapi.dart';
import 'package:merchandising/api/FMapi/outletapi.dart';
import 'package:merchandising/api/FMapi/merchnamelistapi.dart';
import 'package:merchandising/api/myattendanceapi.dart';
import 'package:merchandising/api/FMapi/week_off_detailsapi.dart';
import 'package:merchandising/api/FMapi/brand_detailsapi.dart';
import 'package:merchandising/api/FMapi/category_detailsapi.dart';
import 'package:merchandising/api/FMapi/add_brandapi.dart';
import 'package:merchandising/api/FMapi/product_detailsapi.dart';
import'package:merchandising/api/clientapi/outletreport.dart';
import 'clients/client_dashboard.dart';
import'package:merchandising/api/HRapi/empdetailsapi.dart';
import'package:merchandising/api/cde api/cdedashboard.dart';
import 'offlinedata/backgroundsynchronize.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:merchandising/api/customer_activites_api/visibilityapi.dart';
import 'package:merchandising/api/customer_activites_api/share_of_shelf_detailsapi.dart';
import 'package:merchandising/api/customer_activites_api/promotion_detailsapi.dart';
import 'package:merchandising/api/FMapi/nbl_detailsapi.dart';
import 'package:merchandising/api/customer_activites_api/planogramdetailsapi.dart';
import 'package:merchandising/HR/leaverules.dart';
import 'package:merchandising/HR/editleaverule.dart';




/// start of the application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /// initializing firebase at the start of the app.
  await Firebase.initializeApp();
  /// opening the app without login screen.
  /// trying to check if any email or password has been stored in the local storage.
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('useremail');
  var password = prefs.getString('userpassword');
  remembereddata.email = email;
  remembereddata.password = password;
  print("rememberme : $email");
  print("rememberme : $password");
  /// if email and password are stored, then it will go through this loop
  if(email != null && password != null) {
    fromloginscreen = true;
    ///make sure we receive token and empid before calling other api's
    /// so await for login api.
    int userroleid = await loginapi();
    ///login api will return a role id.
    /// based on the role id we will navigate to that role id dashboard
    currentuser.roleid = userroleid;
    print(userroleid);
    ///merchandiser's role id is 6
    if(userroleid == 6){
      //BackgroundFetch.configure(config, onFetch)
      // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
      // initPlatformState();
      //BackgroundConfig();
      // print("background fetch detail's : ${prefs.getString('fetch_events')}");
      /// first we are trying to get any unsynced data that was in the local storage.
      message = prefs.getStringList('addtoservermessage');
      requireurlstosync = prefs.getStringList('addtoserverurl');
      requirebodytosync = prefs.getStringList('addtoserverbody');


      ///fetch all the reference data from the local.
      currentlysyncing = false;
      print("going to get reference");
      await syncingreferencedata();
      print("going to send");
      if(onlinemode.value){
        print("come to send");
        print(requireurlstosync);
        print(requirebodytosync);
        syncingsenddata();
      }


      ///once app is up and running for every 20 minutes we are trying to get reference data.
      // const time = const Duration(minutes: 20);
      // Timer.periodic(time, (Timer t) => syncingreferencedata());
      ///once app is up and running for every 15 minutes we are trying to get sync data.
      // const period = const Duration(minutes: 15);
      // Timer.periodic(period, (Timer t) => syncingsenddata());
      var currentpage = prefs.getString('pageiddata');
      print("current page : $currentpage");
      if(currentpage=="2"){


        currentoutletid = int.parse(prefs.getString('outletiddata'));
        currenttimesheetid = prefs.getString('timesheetiddata');
        currentoutletindex = int.parse(prefs.getString('currentoutletindexdata'));
        company.text =  prefs.getString("companydata");
        category.text = prefs.getString("categorydata");
        itemname.text = prefs.getString("itemdata");
        promotiontype.text = prefs.getString("promotypedata");
        promodscrptn.text = prefs.getString("promodescdata");
        mrp.text = prefs.getString("regpricedata");
        sellingprice.text = prefs.getString("sellpricedata");
        // var savedcopmimg =prefs.getString("capimgdata");


        // readasbyteimgcomp = savedimgcomp;
        //   decodedcompimg = base64Encode(readasbyteimgcomp);

         // var decodedimg = base64Decode(capturedcopmtnimg);


        print("getString == ${company.text}");
        // print("img == $savedcopmimg");

      }
      if(currentpage == "1"){
        await getLocation();
        await callfrequently();
        fromloginscreen = false;
        runApp(MaterialApp(
            title: 'Rhapsody merchandising solutions',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Poppins',
              primaryColor: Colors.white,
              accentColor: orange,),
            home:  JourneyPlanPage()
        ));
      }else if(currentpage == "2"){
        await getLocation();
        await outletwhencheckin();
        getTaskList();
        getVisibility();
        getPlanogram();
        getPromotionDetails();
        // Addedstockdataformerch();
        await getNBLdetails();
        getShareofshelf();
        NBLdetailsoffline();

        print("KPI current page timesheet id");
        print(currenttimesheetid);
        fromloginscreen = false;
        runApp(MaterialApp(

 title: 'Rhapsody merchandising solutions',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Poppins',
              primaryColor: Colors.white,
              accentColor: orange,),
            home:  CustomerActivities(),


        ));
      }else{
        runApp(MaterialApp(
            title: 'Rhapsody merchandising solutions',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Poppins',
              primaryColor: Colors.white,
              accentColor: orange,),
            home:  DashBoard()
        ));
      }
    }
    /// HR role id is 3
    else if(userroleid == 3){
      await HRdb();
      await getempdetails();
      runApp(MaterialApp(
          title: 'Rhapsody merchandising solutions',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            primaryColor: Colors.white,
            accentColor: orange,),
          home: HRdashboard()
      ));
    }
    /// field manager role id is 5.
    /// CDE's role id is 2.
    /// requesting all the data that is required for fm.
    else if(userroleid == 5||userroleid == 2){
      getempdetails();
      getWeekoffdetails();
      getBrandDetails();
      getemployeestoaddbrand();
      getCategoryDetails();
      getProductDetails();
      //getmyattandance();
      getStoreDetails();
      getmappedoutlets();
      getallempdetails();
      getRelieverDetails();
      OutletsForClient();
       // getNotificationDetails();
      await getFMoutletdetails();

      if(userroleid == 2){
        await merchnamelistunderCDE();
        await getCDEdb();
      }else{
        await getmerchnamelist();
        await getFMdb();
      }

      runApp(MaterialApp(
          title: 'Rhapsody merchandising services',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            primaryColor: Colors.white,
            accentColor: orange,),
          home: FieldManagerDashBoard()
      ));
    }
    /// client role id is 7
    else if (userroleid == 7){
      await OutletsForClient();
      await getallempdetails();
      await getmerchnamelist();
      runApp(MaterialApp(
          title: 'Rhapsody merchandising solutions',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            primaryColor: Colors.white,
            accentColor: orange,),
          home: ClientDB()
      ));
    }
    else{
      runApp(MaterialApp(
          title: 'Rhapsody merchandising solutions',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Poppins',
            primaryColor: Colors.white,
            accentColor: orange,),
          home: LoginPage()
      ));
    }
  }
  else{
    ///if no email or password found it will open login page.
    runApp(MaterialApp(
        title: 'Rhapsody merchandising solutions',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: Colors.white,
          accentColor: orange,),
        home: LoginPage()
    ));
  }
}

class currentuser{
  static int roleid;
}

class remaining{
  static var leaves;
}
