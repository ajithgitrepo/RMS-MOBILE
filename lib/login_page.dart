import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:merchandising/api/api_service.dart';
import 'package:merchandising/Constants.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/merchandiserdashboard.dart';
import 'package:merchandising/model/rememberme.dart';
import 'package:merchandising/HR/HRdashboard.dart';
import 'package:merchandising/Fieldmanager/FMdashboard.dart';
import 'api/HRapi/hrdashboardapi.dart';
import 'package:merchandising/api/FMapi/fmdbapi.dart';
import 'api/FMapi/relieverdet_api.dart';
import 'package:merchandising/offlinedata/sharedprefsdta.dart';
import'package:merchandising/api/HRapi/empdetailsapi.dart';
import 'package:merchandising/main.dart';
import 'package:merchandising/api/empdetailsapi.dart';
import 'api/HRapi/empdetailsforreportapi.dart';
import 'dart:async';
import 'model/database.dart';
import 'package:merchandising/api/FMapi/storedetailsapi.dart';
import 'offlinedata/syncreferenceapi.dart';
import 'package:merchandising/api/FMapi/outletapi.dart';
import 'package:merchandising/api/FMapi/merchnamelistapi.dart';
import 'package:merchandising/api/myattendanceapi.dart';
import 'package:merchandising/api/FMapi/week_off_detailsapi.dart';
import 'package:merchandising/api/FMapi/brand_detailsapi.dart';
import 'package:merchandising/api/FMapi/category_detailsapi.dart';
import 'package:merchandising/api/FMapi/add_brandapi.dart';
import 'package:merchandising/api/FMapi/product_detailsapi.dart';
import'package:merchandising/api/FMapi/outlet brand mappingapi.dart';
import 'package:merchandising/clients/client_dashboard.dart';
import 'api/clientapi/outletreport.dart';
import 'offlinedata/syncsendapi.dart';
import 'package:flushbar/flushbar.dart';
import 'package:merchandising/api/Journeyplansapi/todayplan/journeyplanapi.dart';
import 'package:merchandising/api/Journeyplansapi/todayplan/jpskippedapi.dart';
import 'package:merchandising/api/Journeyplansapi/todayplan/JPvisitedapi.dart';
import 'package:merchandising/api/Journeyplansapi/weekly/jpplanned.dart';
import 'package:merchandising/api/Journeyplansapi/weekly/jpskipped.dart';
import 'package:merchandising/api/Journeyplansapi/weekly/jpvisited.dart';
import'package:merchandising/api/cde api/cdedashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController emailinputcontroller = TextEditingController();
  static TextEditingController passwordinputcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    /// ProgressHUD is a custom widget created to show loading screen.
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }
  Widget _uiSetup(BuildContext context) {
    return GestureDetector(
      onTap: (){
        /// the below code is because text field will triggered automatically.
        /// with the help of the below line keyboard will show only if textfield got tapped.
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        key: scaffoldKey,
         // backgroundColor: Theme.of(context).accentColor,
        body: OfflineNotification(
          body: Stack(
            children: [
              BackGround(),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 1.15,
                            padding: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 20),
                            margin:
                                EdgeInsets.symmetric(vertical: 85, horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: transparentwhite,
                            ),
                            child: Form(
                              key: globalFormKey,
                              child: Column(
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  Hero(
                                    tag: 'logo',
                                    child: Image(
                                      height: 40,
                                      image: AssetImage('images/rmsLogo.png'),
                                    ),
                                  ),
                                  SizedBox(height: 40),
                                  Container(
                                    color: Colors.white,
                                    width: MediaQuery.of(context).size.width / 1.5,
                                    child: Theme(
                                      data: ThemeData.from(
                                        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange),
                                      ),
                                      // data: ThemeData(primaryColor: orange),
                                      child: TextFormField(
                                        controller: emailinputcontroller,
                                        keyboardType: TextInputType.emailAddress,
                                        validator: (input) => !input.contains('@')
                                            ? "Email Id should be valid"
                                            : null,
                                        cursorColor: grey,
                                        decoration: new InputDecoration(
                                          focusColor: grey,
                                          hintText: "Email Address",
                                          hintStyle: TextStyle(
                                            color: grey,
                                            fontSize: 16.0,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.person,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Container(
                                    width: MediaQuery.of(context).size.width / 1.5,
                                    color: Colors.white,
                                    child: Theme(
                                      data: ThemeData.from(
                                        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange),
                                      ),
                                      // data: ThemeData(primaryColor: orange),
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        controller: passwordinputcontroller,
                                        validator: (input) => input.length < 6
                                            ? "Password should be more than 6 characters"
                                            : null,
                                        obscureText: hidePassword,
                                        decoration: new InputDecoration(
                                          focusColor: grey,
                                          hintText: "Password",
                                          hintStyle: TextStyle(
                                            color: grey,
                                            fontSize: 16.0,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.lock,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                hidePassword = !hidePassword;
                                              });
                                            },
                                            color: Theme.of(context)
                                                .accentColor
                                                .withOpacity(0.4),
                                            icon: Icon(hidePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  GestureDetector(
                                    onTap: () async {
                                      /// validate and save function will return a bool
                                      /// it will for the validation conditions given for the text field.
                                     if(onlinemode.value) {
                                        if (validateAndSave()) {
                                          setState(() {
                                            isApiCallProcess = true;
                                          });

                                          /// it will tell login api to consider
                                          /// email and password typed in the login page
                                          /// if not login api will try get locally stored email and password.
                                          loginfromloginpage = true;
                                          loginrequestdata.inputemail =
                                              emailinputcontroller.text;
                                          loginrequestdata.inputpassword =
                                              passwordinputcontroller.text;
                                          if (loginrequestdata.inputemail !=
                                                  null &&
                                              loginrequestdata.inputpassword !=
                                                  null) {
                                            fromloginscreen = true;
                                            var date = DateTime.now();
                                            var starttime = DateTime.now();

                                            ///this below will make sure to get latest data from online instead
                                            /// of accessing data from local.
                                            currentlysyncing = true;
                                            int userroleid = await loginapi();
                                            currentuser.roleid = userroleid;
                                            print(userroleid);
                                            if (userroleid != null) {
                                              print("logindetails added");

                                              /// this function will store email and password of the user in local
                                              addLogindetails();
                                            }
                                            if (userroleid == 6) {
                                              var DBMresult =
                                                  DBRequestmonthly();
                                              await getJourneyPlan();
                                              chartvisits();
                                              Expectedchartvisits();
                                              getempdetails();
                                              getallempdetails();
                                              //getaddedexpiryproducts();
                                              getstockexpiryproducts();
                                              getempdetailsforreport();
                                              getskippedJourneyPlan();
                                              getvisitedJourneyPlan();
                                              getSkipJourneyPlanweekly();
                                              getJourneyPlanweekly();
                                              getVisitJourneyPlanweekly();
                                              // getLocation();
                                              await callfrequently();
                                              var DBDresult =
                                                  await DBRequestdaily();

                                              ///once app is up and running for every 20 minutes we are trying to get reference data.
                                              // const time = const Duration(minutes: 20);
                                              // Timer.periodic(time, (Timer t) => syncingreferencedata());
                                              ///once app is up and running for every 15 minutes we are trying to send sync data.
                                              // const period = const Duration(minutes: 15);
                                              // Timer.periodic(period, (Timer t) => syncingsenddata());
                                              const hat =
                                                  const Duration(seconds: 120);

                                              ///once app is up and running for every 2 minutes we are trying to get location and distance.
                                              Timer.periodic(
                                                  hat,
                                                  (Timer t) =>
                                                      callfrequently());
                                              var endtime = DateTime.now();
                                              await lastsynced(
                                                  date, starttime, endtime);
                                              if (DBMresult != null &&
                                                  DBDresult != null) {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            (BuildContextcontext) =>
                                                                DashBoard()));
                                              }
                                            }

                                            /// HR role id is 3.
                                            else if (userroleid == 3) {
                                              await getempdetails();
                                              int result = await HRdb();
                                              if (result != null) {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder:
                                                            // ignore: non_constant_identifier_names
                                                            (BuildContextcontext) =>
                                                                HRdashboard()));
                                              }
                                            }

                                            /// field manager role id is 5.
                                            /// CDE's role id is 2.
                                            /// requesting all the data that is required for fm.
                                            else if (userroleid == 5 ||
                                                userroleid == 2) {
                                              getempdetails();
                                              getWeekoffdetails();
                                              getBrandDetails();
                                              getemployeestoaddbrand();
                                              getCategoryDetails();
                                              getmappedoutlets();
                                              getProductDetails();
                                              //getmyattandance();
                                              getallempdetails();
                                              getStoreDetails();
                                              OutletsForClient();
                                              getRelieverDetails();
                                              await getFMoutletdetails();
                                              if (userroleid == 2) {
                                                await merchnamelistunderCDE();
                                                await getCDEdb();
                                              } else {
                                                await getmerchnamelist();
                                                await getFMdb();
                                              }

                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (BuildContextcontext) =>
                                                              FieldManagerDashBoard()));
                                            }

                                            /// Client role id is 7.
                                            else if (userroleid == 7) {
                                              await OutletsForClient();
                                              await getallempdetails();
                                              await getmerchnamelist();
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder:
                                                          (BuildContextcontext) =>
                                                              ClientDB()));
                                            }

                                            ///if login was not sucessfull.
                                            else {
                                              setState(() {
                                                isApiCallProcess = false;
                                              });

                                              /// snack bar pop's out with the message coming from login api.
                                              final snackBar = SnackBar(
                                                  elevation: 20.00,
                                                  duration:
                                                      Duration(seconds: 2),
                                                  content: Text(
                                                    DBrequestdata.message
                                                        .toString(),
                                                  ));
                                              scaffoldKey.currentState
                                                  .showSnackBar(snackBar);
                                            }
                                          }
                                        }
                                      }
                                     else{
                                       Flushbar(
                                         message: "Internet is required to login",
                                         duration: Duration(seconds: 5),
                                       )..show(context);

                                     }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 15.0),
                                      padding: EdgeInsets.all(15.0),
                                      width:
                                          MediaQuery.of(context).size.width / 1.5,
                                      color: orange,
                                      child: Center(
                                        child: Text(
                                          "LOGIN",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
