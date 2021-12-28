import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/Customers%20Activities.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/merchandiserdashboard.dart';
import 'package:merchandising/offlinedata/sharedprefsdta.dart';
import '../../Constants.dart';
import 'package:flutter/cupertino.dart';
import 'MenuContent.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/Maps_Veiw.dart';
import 'outletdetailes.dart';
import 'package:merchandising/api/api_service.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/jpskiped.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/jpvisited.dart';
import 'package:merchandising/api/Journeyplansapi/todayplan/journeyplanapi.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/weeklyjpwidgets/weeklyjp.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/weeklyjpwidgets/weeklyskipjp.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/weeklyjpwidgets/weeklyvisitjp.dart';
import 'package:merchandising/offlinedata/syncdata.dart';
import 'Customers Activities.dart';
import'package:merchandising/offlinedata/syncreferenceapi.dart';
import 'package:intl/intl.dart';
import 'package:flushbar/flushbar.dart';
import 'package:getwidget/getwidget.dart';
import'package:merchandising/model/distanceinmeters.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:merchandising/Constants.dart';
import 'package:merchandising/api/customer_activites_api/visibilityapi.dart';
import 'package:merchandising/api/customer_activites_api/share_of_shelf_detailsapi.dart';
import 'package:merchandising/api/customer_activites_api/competition_details.dart';
import 'package:merchandising/api/customer_activites_api/promotion_detailsapi.dart';
import 'package:merchandising/api/Journeyplansapi/todayplan/journeyplanapi.dart';
import 'package:merchandising/api/FMapi/nbl_detailsapi.dart';
import 'package:merchandising/api/customer_activites_api/planogramdetailsapi.dart';
import 'package:merchandising/api/avaiablityapi.dart';
import 'package:merchandising/api/Journeyplansapi/todayplan/jpskippedapi.dart';
import 'package:merchandising/api/Journeyplansapi/todayplan/JPvisitedapi.dart';
import 'package:merchandising/api/Journeyplansapi/weekly/jpplanned.dart';
import 'package:merchandising/api/Journeyplansapi/weekly/jpskipped.dart';
import 'package:merchandising/api/Journeyplansapi/weekly/jpvisited.dart';
import 'package:merchandising/api/empdetailsapi.dart';
import 'package:merchandising/model/database.dart';
import 'package:merchandising/api/HRapi/empdetailsforreportapi.dart';
import 'package:merchandising/api/HRapi/empdetailsapi.dart';

List<String> breakspl = [];
bool jptimecal = false;

class JourneyPlanPage extends StatefulWidget {
  @override
  _JourneyPlanPageState createState() => _JourneyPlanPageState();
}

class _JourneyPlanPageState extends State<JourneyPlanPage> {
  @override
  void initState() {
    createlog("Navigated to Journey plan Page","true");
    currentpagestatus('1', '1', '1','1');
    super.initState();
    if (checkoutrequested && checkoutdatasubmitted) {
      Future.delayed(const Duration(seconds: 2), () {
        Flushbar(
          message: "Checkout Updated",
          duration: Duration(seconds: 5),
        )..show(context);
        checkoutrequested = false;
        checkoutdatasubmitted = false;
      });
    } else if (checkoutrequested && !checkoutdatasubmitted) {
      Future.delayed(const Duration(seconds: 2), () {
        Flushbar(
          message: "Error While Updating Checkout Please Try again.",
          duration: Duration(seconds: 5),
        )..show(context);
        checkoutrequested = false;
        checkoutdatasubmitted = false;
      });
    }
  }

  bool isApiCallProcess = false;
  int index;
  bool pressWeek = false;
  bool pressTODAY = true;
  bool pressCustomers = false;
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: onlinemode,
        builder: (context, value, child) {
          return WillPopScope(
            onWillPop: () async => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => DashBoard())),
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: containerscolor,
                // automaticallyImplyLeading: false,
                // leading: GestureDetector(
                //     onTap: () {
                //       Navigator.pushReplacement(
                //           context,
                //           MaterialPageRoute(
                //               builder: (BuildContext context) => DashBoard()));
                //     },
                //     child: Icon(
                //       CupertinoIcons.back,
                //       size: 30,
                //     )),
                iconTheme: IconThemeData(color: orange),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Journey Plan',
                          style: TextStyle(color: orange),
                        ),
                        EmpInfo()
                      ],
                    ),
                    IconButton(onPressed: ()async{
                      if(onlinemode.value) {
                        print(onlinemode.value);
                        syncnowjourneyplan(context);
                      }
                      else if(onlinemode.value==false){
                        print(onlinemode.value);
                          Flushbar(
                            message:
                            "Active internet is required to Refresh Journey Plan",
                            duration: Duration(
                                seconds: 3),
                           )..show(context);
                      }


                    }, icon: Icon(CupertinoIcons.refresh_circled_solid,color: orange,size: 30)),
                    GestureDetector(
                      onTap: () {
                        createlog("map view tapped","true");
                        if (onlinemode.value) {
                          nearestoutletindex = null;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => MapVeiw()));
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10.00),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: onlinemode.value ? orange : iconscolor,
                          borderRadius: BorderRadius.circular(10.00),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.location_solid,
                              size: 15,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Map",
                              style: TextStyle(fontSize: 15, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              drawer: Drawer(
                child: Menu(),
              ),
              body: Stack(
                children: [
                  BackGround(),
                  OfflineNotification(
                    body: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: onlinemode.value ? 0 : 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                createlog("Today's Journey Plan tapped","true");
                                setState(() {
                                  pressTODAY = true;
                                  pressCustomers = false;
                                  pressWeek = false;
                                });
                              },
                              child: JourneyPlanHeader(
                                icon: Icons.calendar_today,
                                chartext: "Today's\nJourney Plan",
                                textcolor: pressTODAY == true
                                    ? Colors.white
                                    : Colors.black,
                                containercolor:
                                    pressTODAY == true ? orange : pink,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                createlog("Week's Journey Plan tapped","true");
                                setState(() {
                                  pressTODAY = false;
                                  pressCustomers = false;
                                  pressWeek = true;
                                });
                              },
                              child: JourneyPlanHeader(
                                icon: Icons.calendar_today_outlined,
                                chartext: "Week's\nJounery Plan",
                                textcolor: pressWeek == true
                                    ? Colors.white
                                    : Colors.black,
                                containercolor: pressWeek == true ? orange : pink,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                createlog("My Customers tapped","true");
                                setState(() {
                                  pressTODAY = false;
                                  pressCustomers = true;
                                  pressWeek = false;
                                });
                              },
                              child: JourneyPlanHeader(
                                icon: Icons.group,
                                chartext: "My\nCustomers",
                                textcolor: pressCustomers == true
                                    ? Colors.white
                                    : Colors.black,
                                containercolor:
                                    pressCustomers == true ? orange : pink,
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(height: 10.0),
                        // Text("Checkin is only available for Today Planned Journey Plan only",style: TextStyle(fontSize: 10,color:iconscolor),),
                        Expanded(
                          child: DefaultTabController(
                            length: 3, // length of tabs
                            initialIndex: 0,
                            child: Scaffold(
                              backgroundColor: Colors.transparent,
                              appBar: PreferredSize(
                                preferredSize: Size.fromHeight(kToolbarHeight),
                                child: Container(
                                  margin:
                                      EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: Colors.white,
                                  ),
                                  child: TabBar(
                                    labelColor: orange,
                                    unselectedLabelColor: Colors.black,
                                    indicatorColor: orange,
                                    tabs: [
                                      Tab(text: 'PLANNED'),
                                      Tab(text: 'YET TO VISIT'),
                                      Tab(text: 'VISITED'),
                                    ],
                                  ),
                                ),
                              ),
                              body: TabBarView(children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    /*
                              SizedBox(
                                height: 10,
                              ),
                             Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                                  color: pink,
                                ),
                                height: 40,
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                     Expanded(
                                      child: Theme(
                                        data: ThemeData(primaryColor: orange),
                                        child: TextField(
                                          cursorColor: orange,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            focusColor: Colors.black,
                                            hintText:
                                            'Search by Store Code/Name',
                                            hintStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext context) =>
                                                    MapVeiw()));
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            CupertinoIcons.location_solid,
                                            size: 15,
                                          ),
                                          Text("MAP VIEW"),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ), */
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                        child: pressTODAY == true
                                            ? JourneyListBuilder()
                                            : pressWeek == true
                                                ? WeeklyJourneyListBuilder()
                                                : Center(
                                                    child: Text(
                                                    "we have journey plan only for today and monthly only",
                                                  )))
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                        child: pressTODAY == true
                                            ? SkipedJourneyListBuilder()
                                            : pressWeek == true
                                                ? WeeklySkipJourneyListBuilder()
                                                : Center(
                                                    child: Text(
                                                    "we have journey plan only for today",
                                                  )))
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                        child: pressTODAY == true
                                            ? visitedJourneyListBuilder()
                                            : pressWeek == true
                                                ? WeeklyVisitJourneyListBuilder()
                                                : Center(
                                                    child: Text(
                                                    "we have journey plan only for today",
                                                  )))
                                  ],
                                ),
                              ]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class JourneyPlanHeader extends StatelessWidget {
  JourneyPlanHeader(
      {this.chartext, this.icon, this.textcolor, this.containercolor});
  final chartext;
  final icon;
  final textcolor;
  final containercolor;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width / 3.5,
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: containercolor),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textcolor),
            SizedBox(width: 10,),
            Text(
              chartext,
              style: TextStyle(
                fontSize: 12,
                color: textcolor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

//List<String>journeydone=[];

class JourneyListBuilder extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<JourneyListBuilder> {
  bool isApiCallProcess = false;
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return gettodayjp.storenames.length == 0
        ? Center(
            child: Text(
            "you dont have any active journey plan\ncontact your manager for more info",
            textAlign: TextAlign.center,
          ))
        : ListView.builder(
            itemCount: gettodayjp.storenames.length,
            itemBuilder: (BuildContext context, int index) {


              return GestureDetector(
                onTap: () async {
                  print("schecduled");
                  print(gettodayjp.isscheduled[index]);
                  createlog("Outlet from JP tapped","true");
                  currentoutletindex = index;
                  if (gettodayjp.status[index] == 'done') {
                    print("entered if");
                    print("JP Check in:${gettodayjp.checkintime[index]}");
                    print("JP Check out:${gettodayjp.checkouttime[index]}");
                    showDialog(
                        context: context,
                        builder: (_) =>
                            StatefulBuilder(builder: (context, setState) {
                              return ProgressHUD(
                                  inAsyncCall: isApiCallProcess,
                                  opacity: 0.3,
                                  child: AlertDialog(
                                    backgroundColor: alertboxcolor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                    content: Builder(
                                      builder: (context) {
                                        // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                        return Container(
                                          child: SizedBox(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Alert",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                    "It seems you have already finished this Outlet\nDo you want to do Split Shift?",
                                                    style: TextStyle(
                                                        fontSize: 13.6)),
                                                SizedBox(
                                                  height: 10.00,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () async {
                                                        createlog("Split Shift checked in tapped","true");

                                                        // if(onlinemode.value){
                                                          jptimecal = true;
                                                          currentoutletid =
                                                              gettodayjp
                                                                      .outletids[
                                                                  index];
                                                          currenttimesheetid =
                                                              gettodayjp
                                                                  .id[index];
                                                          var currenttime =
                                                              DateTime.now();
                                                          // splitbreak.type ="Split Shift";
                                                          splitbreak
                                                              .citime = DateFormat(
                                                                  'HH:mm:ss')
                                                              .format(
                                                                  currenttime);
                                                          splitbreak.cotime =
                                                              "";
                                                          splitbreak.jtimeid =
                                                              "";
                                                          outletrequestdata
                                                                  .outletidpressed =
                                                              currentoutletid;
                                                          setState(() {
                                                            isApiCallProcess =
                                                                true;
                                                          });
                                                          getTaskList();
                                                          getVisibility();
                                                          getPlanogram();
                                                          getPromotionDetails();
                                                          // getAvaiablitity();
                                                          getShareofshelf();
                                                          // Addedstockdataformerch();
                                                          getNBLdetails();
                                                          await merchbreak();
                                                          // await getTotalJnyTime();
                                                          outletselectedfordetails = index;
                                                          await outletwhencheckin();
                                                          setState(() {
                                                            isApiCallProcess =
                                                                false;
                                                          });
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (BuildContext
                                                                          context) =>
                                                                      CustomerActivities()));
                                                        // }else{
                                                        //   Flushbar(
                                                        //     message:
                                                        //     "Active internet required",
                                                        //     duration: Duration(
                                                        //         seconds: 3),
                                                        //   )..show(context);
                                                        // }
                                                      },
                                                      child: Container(
                                                        height: 40,
                                                        width: 70,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: orange,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                        ),
                                                        margin: EdgeInsets.only(
                                                            right: 10.00),
                                                        child: Center(
                                                            child: Text("YES")),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ));
                            }));
                  } else {
                    print("entered else");
                    createlog("Outlet from JP tapped","true");

                    setState(() {
                      isApiCallProcess = true;
                    });
                    outletrequestdata.outletidpressed =
                        gettodayjp.outletids[index];
                    checkinoutdata.checkid = gettodayjp.id[index];
                    currenttimesheetid = gettodayjp.id[index];
                    currentoutletid = gettodayjp.outletids[index];
                    print("check1");
                    var data = await outletwhencheckin();
                    print("check2");
                    setState(() {
                      isApiCallProcess = false;
                    });
                    if (data != null) {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              // ignore: non_constant_identifier_names
                              builder: (BuildContextcontext) => OutLet()));
                    } else {
                      setState(() {
                        isApiCallProcess = false;
                      });
                    }
                    print(checkinoutdata.checkid);
                  }
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  height: 130,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text(
                                  '[${gettodayjp.storecodes[index]}] ${gettodayjp.storenames[index]}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                gettodayjp.isscheduled[index] == 0
                                    ? Text('(unscheduled)',
                                        style: TextStyle(
                                            fontSize: 13.0, color: orange),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text('${gettodayjp.outletarea[index]}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Text('${gettodayjp.outletcity[index]}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Text('${gettodayjp.outletcountry[index]}',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  )),
                            ],
                          ),
                          Spacer(),
                          Table(
                            children: [
                              TableRow(children: [
                                Text('Contact Number :',
                                    style: TextStyle(
                                      fontSize: 13.0,
                                    )),
                                Text('${gettodayjp.contactnumbers[index]}',
                                    style: TextStyle(color: orange)),
                              ]),
                              TableRow(children: [
                                Text('Distance :',
                                    style: TextStyle(
                                      fontSize: 13.0,
                                    )),
                                Row(
                                  children: [
                                    Text(
                                        '${gettodayjp.distanceinmeters[index].toStringAsFixed(2)}',
                                        style: TextStyle(color: orange)),
                                    Text("KM", style: TextStyle(color: orange))
                                  ],
                                ),
                              ]),
                            ],
                          ),
                        ],
                      ),
                      gettodayjp.status[index] == 'done'
                          ? Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(
                                Icons.check_circle_outline_sharp,
                                color: Colors.green,
                                size: 20,
                              ))
                          : SizedBox(),
                    ],
                  ),
                ),
              );
            });
  }
}


syncnowjourneyplan(context)async{
  if (onlinemode.value) {
    currentlysyncing = true;
    showDialog(
        context: context ,
        barrierDismissible: false,
        builder: (_) => StatefulBuilder(
            builder: (context, setState) {
              progress.value = 10;
              currentlysyncing = true;
              return ValueListenableBuilder<int>(
                  valueListenable: progress,
                  builder: (context, value, child) {
                    return AlertDialog(
                      backgroundColor: alertboxcolor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.all(
                              Radius.circular(
                                  10.0))),
                      content: Builder(
                        builder: (context) {
                          // Get available height and width of the build area of this widget. Make a choice depending on the size.
                          return Column(
                            mainAxisSize:
                            MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Refreshing',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18),
                                  ),
                                  SizedBox(width:5),
                                  currentlysyncing ?SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(color: orange,strokeWidth: 2,)):SizedBox(),
                                ],
                              ),
                              Divider(
                                color: Colors.black,
                                thickness: 0.8,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "${progress.value} %",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight:
                                    FontWeight.bold,
                                    color: orange),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              GFProgressBar(
                                  percentage: (progress.value)/100,
                                  backgroundColor:
                                  Colors.black26,
                                  progressBarColor:
                                  orange),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                  child: Text(
                                    'Please don\'t turn off your data, or close the app',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color:
                                        Colors.black),
                                    textAlign:
                                    TextAlign.center,
                                  )),
                            ],
                          );
                        },
                      ),
                    );
                  });
            }));

    progress.value = 30;
    currentlysyncing = true;
    await syncingreferencedata();
    progress.value = 100;
    currentlysyncing = false;
    dispose.value = true;
    await distinmeters();
    Navigator.pop(
        context,
        MaterialPageRoute(
            builder: (BuildContext
            context) =>
                JourneyPlanPage()));


  } else {
    Flushbar(
      message: "Make sure you had an active internet",
      duration: Duration(seconds: 3),
    );
  }
}