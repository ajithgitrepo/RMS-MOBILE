import 'package:merchandising/api/FMapi/outlet%20brand%20mappingapi.dart';
import 'package:merchandising/api/customer_activites_api/planogramdetailsapi.dart';
import 'package:merchandising/HR/HRdashboard.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:merchandising/api/avaiablityapi.dart';
import 'package:flutter/material.dart';
import 'package:merchandising/Constants.dart';
import 'outletdetailes.dart';
import 'package:merchandising/api/customer_activites_api/Competitioncheckapi.dart';
import 'package:merchandising/api/api_service.dart';
import 'Customers Activities.dart';
import 'package:merchandising/model/Location_service.dart';
import 'package:flushbar/flushbar.dart';
import 'package:merchandising/api/customer_activites_api/visibilityapi.dart';
import 'package:merchandising/api/customer_activites_api/share_of_shelf_detailsapi.dart';
import 'package:merchandising/api/customer_activites_api/competition_details.dart';
import 'package:merchandising/api/customer_activites_api/promotion_detailsapi.dart';
import 'package:merchandising/api/Journeyplansapi/todayplan/journeyplanapi.dart';
import 'package:merchandising/api/FMapi/nbl_detailsapi.dart';
import 'package:merchandising/api/myattendanceapi.dart';
import 'package:merchandising/api/clientapi/stockexpirydetailes.dart';

import 'package:merchandising/api/clientapi/stockexpirydetailes.dart';
import'package:merchandising/Merchandiser/merchandiserscreens/Journeyplan.dart';

class CheckIn extends StatefulWidget {
  @override
  _CheckInState createState() => _CheckInState();
}

class _CheckInState extends State<CheckIn> {
  bool isApiCallProcess = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        createlog("Check In tapped from outlet details","true");
        print(chekinoutlet.currentdistance);
        if (chekinoutlet.currentdistance > 300) {
          showDialog(
              context: context,
              builder: (_) => StatefulBuilder(builder: (context, setState) {
                    return ProgressHUD(
                        inAsyncCall: isApiCallProcess,
                        opacity: 0.3,
                        child: AlertDialog(
                          backgroundColor: alertboxcolor,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
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
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "It seems that you are not at the customer location.\nDo you want to do Force CheckIn?",
                                          style: TextStyle(fontSize: 13.6)),
                                      SizedBox(
                                        height: 10.00,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          OutLet()));
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                color: Color(0xffAEB7B5),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              margin:
                                                  EdgeInsets.only(right: 10.00),
                                              child:
                                                  Center(child: Text("cancel")),
                                            ),
                                          ),
                                          ForceCheckin(),
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
            setState(() {
              isApiCallProcess = true;
            });
            SubmitCheckin();
            normalcheckin = true;
            forcecheck.reason = "normal checkin less than 300m";
            addforeccheckin();
            getTaskList();
            getVisibility();
            getPlanogram();
            getPromotionDetails();
            // Addedstockdataformerch();
             getNBLdetails();
            getShareofshelf();
            await getAvaiablitity();
            await getmyattandance();
            addattendence();
            setState(() {
              isApiCallProcess = false;
            });
            normalcheckin = false;
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (BuildContext context) {
              return CustomerActivities();
            }), (Route<dynamic> route) => false);

        }
      },
      child: Container(
        padding: EdgeInsets.all(15.0),
        margin: EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
          color: pink,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "Check In",
          style: TextStyle(
              fontSize: 16, color: orange, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ForceCheckin extends StatefulWidget {
  @override
  _ForceCheckinState createState() => _ForceCheckinState();
}

class _ForceCheckinState extends State<ForceCheckin> {
  bool isApiCallProcess = false;
  bool gpsnotworking = false;
  bool geolocation = false;
  bool others = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        createlog("yes from alert Tapped","true");

        showDialog(
            context: context,
            builder: (_) => StatefulBuilder(builder: (context, setState) {
                  return ProgressHUD(
                    inAsyncCall: isApiCallProcess,
                    opacity: 0.1,
                    child: AlertDialog(
                      backgroundColor: alertboxcolor,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      content: Builder(
                        builder: (context) {
                          // Get available height and width of the build area of this widget. Make a choice depending on the size.
                          return Container(
                            child: SizedBox(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Force Check-In",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            gpsnotworking = true;
                                            geolocation = false;
                                            others = false;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            ForcecheckinContent(
                                              child: gpsnotworking == true
                                                  ? Icon(
                                                      Icons.circle,
                                                      size: 15.0,
                                                      color: orange,
                                                    )
                                                  : null,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "GPS Not Working",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            gpsnotworking = false;
                                            geolocation = true;
                                            others = false;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            ForcecheckinContent(
                                              child: geolocation == true
                                                  ? Icon(
                                                      Icons.circle,
                                                      size: 15.0,
                                                      color: orange,
                                                    )
                                                  : null,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Geo Location was wrong",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            gpsnotworking = false;
                                            geolocation = false;
                                            others = true;
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            ForcecheckinContent(
                                              child: others == true
                                                  ? Icon(
                                                      Icons.circle,
                                                      size: 15.0,
                                                      color: orange,
                                                    )
                                                  : null,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "Others",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Center(
                                        child: GestureDetector(
                                          onTap: () async {
                                            createlog("GPS not working tapped","true");
                                              if (gpsnotworking == true) {
                                                forcecheck.reason =
                                                    "GPS not working";
                                                setState(() {
                                                  isApiCallProcess = true;
                                                });

                                                addforeccheckin();
                                                addattendence();
                                                getTaskList();
                                                getVisibility();
                                                getPlanogram();
                                                getPromotionDetails();
                                                // Addedstockdataformerch();
                                                getNBLdetails();
                                                getShareofshelf();
                                                SubmitCheckin();
                                                // await getAvaiablitity();
                                                // await getmyattandance();
                                                //  if(noattendance.noatt=="attadded"){
                                                //    print("Attendance added:${noattendance.noatt}");
                                                //  }
                                                //  else{
                                                //     addattendence();
                                                //  }
                                                setState(() {
                                                  isApiCallProcess = false;
                                                });
                                                Navigator.pushAndRemoveUntil(
                                                    context,
                                                    MaterialPageRoute(builder:
                                                        (BuildContext context) {
                                                  return CustomerActivities();
                                                }),
                                                    (Route<dynamic> route) =>
                                                        false);
                                              } else {
                                                if (geolocation == true) {
                                                  createlog("Geo Location was wrong tapped","true");
                                                  forcecheck.reason =
                                                      "Geolocation was wrong";
                                                  setState(() {
                                                    isApiCallProcess = true;
                                                  });
                                                  addforeccheckin();
                                                  addattendence();
                                                  SubmitCheckin();
                                                  getTaskList();
                                                  getVisibility();
                                                  getPlanogram();
                                                  getPromotionDetails();
                                                  // Addedstockdataformerch();
                                                  getNBLdetails();
                                                  // await getAvaiablitity();
                                                  await getShareofshelf();
                                                  // await getmyattandance();
                                                  // if(noattendance.noatt=="attadded"){
                                                  //   print("Attendance added:${noattendance.noatt}");
                                                  // }
                                                  // else{
                                                  //   addattendence();
                                                  // }
                                                  setState(() {
                                                    isApiCallProcess = false;
                                                  });

                                                  print(
                                                      "geo Location was wrong");
                                                  Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(builder:
                                                          (BuildContext
                                                              context) {
                                                    return CustomerActivities();
                                                  }),
                                                      (Route<dynamic> route) =>
                                                          false);
                                                } else {
                                                  if (others == true) {
                                                    createlog("Others tapped","true");
                                                    forcecheck.reason =
                                                        "Others";
                                                    setState(() {
                                                      isApiCallProcess = true;
                                                    });
                                                    addforeccheckin();
                                                    addattendence();
                                                    getTaskList();
                                                    getVisibility();
                                                    getPlanogram();
                                                    getPromotionDetails();
                                                    // Addedstockdataformerch();
                                                    await getNBLdetails();
                                                    getShareofshelf();
                                                  // await getAvaiablitity();
                                                    await SubmitCheckin();
                                                    setState(() {
                                                      isApiCallProcess = false;
                                                    });
                                                    print("others");
                                                    Navigator.pushAndRemoveUntil(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                      return CustomerActivities();
                                                    }),
                                                        (Route<dynamic>
                                                                route) =>
                                                            false);
                                                  } else {
                                                    null;
                                                  }
                                                }
                                              }
                                            }

                                          ,
                                          child: Container(
                                            height: 40,
                                            width: 70,
                                            decoration: BoxDecoration(
                                              color: orange,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            margin:
                                                EdgeInsets.only(right: 10.00),
                                            child: Center(
                                                child: Text(
                                              "Submit",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }));
      },
      child: Container(
        height: 40,
        width: 70,
        decoration: BoxDecoration(
          color: orange,
          borderRadius: BorderRadius.circular(5),
        ),
        margin: EdgeInsets.only(left: 10.00),
        child: Center(
            child: Text(
          "yes",
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}
//
// class RoundCheckBOX extends StatefulWidget {
//   @override
//   _RoundCheckBOXState createState() => _RoundCheckBOXState();
// }
//
// class _RoundCheckBOXState extends State<RoundCheckBOX> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               gpsnotworking = true;
//               geolocation =false;
//               others = false;
//             });
//           },
//           child: Row(
//             children: [
//               ForcecheckinContent(
//                 child: gpsnotworking == true
//                     ? Icon(
//                   Icons.circle,
//                   size: 15.0,
//                   color: orange,
//                 )
//                     : null,
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Text(
//                 "GPS Not Working",
//                 style: TextStyle(fontSize: 16),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               gpsnotworking = false;
//               geolocation =true;
//               others = false;
//             });
//           },
//           child: Row(
//             children: [
//               ForcecheckinContent(
//                 child: geolocation == true
//                     ? Icon(
//                   Icons.circle,
//                   size: 15.0,
//                   color: orange,
//                 )
//                     : null,
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Text(
//                 "Geo Location was wrong",
//                 style: TextStyle(fontSize: 16),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(
//           height: 10,
//         ),
//         GestureDetector(
//           onTap: () {
//             setState(() {
//               gpsnotworking = false;
//               geolocation =false;
//               others = true;
//             });
//           },
//           child: Row(
//             children: [
//               ForcecheckinContent(
//                 child: others == true
//                     ? Icon(
//                   Icons.circle,
//                   size: 15.0,
//                   color: orange,
//                 )
//                     : null,
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//               Text(
//                 "others",
//                 style: TextStyle(fontSize: 16),
//               ),
//             ],
//           ),
//         ),
//         SizedBox(height: 10,),
//         Center(
//           child: GestureDetector(
//             onTap: ()async{
//               if (gpsnotworking == true) {
//                 setState(() {
//                   isApiCallProcess = true;
//                 });
//                 print("gps not working");
//                 SubmitCheckin();
//                 await Avaiablitity();
//                 await getVisibility();
//                 setState(() {
//                   isApiCallProcess = false;
//                 });
//                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
//                   return CustomerActivities();
//                 }), (Route<dynamic> route) => false);
//               }
//               else {
//                 if(geolocation == true){
//                   SubmitCheckin();
//                   print("geo Location was wrong");
//                   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
//                     return CustomerActivities();
//                   }), (Route<dynamic> route) => false);
//                 }
//                 else {
//                   if(others == true){
//                     SubmitCheckin();
//                     print("others");
//                     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context){
//                       return CustomerActivities();
//                     }), (Route<dynamic> route) => false);
//                   }
//                   else{
//                     null ;
//                   }
//                 }
//               }
//             },
//             child: Container(
//               height: 40,
//               width: 70,
//               decoration: BoxDecoration(
//                 color: orange,
//                 borderRadius: BorderRadius.circular(5),
//               ),
//               margin: EdgeInsets.only(right: 10.00),
//               child: Center(child: Text("submit",style: TextStyle(color: Colors.white),)),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

class ForcecheckinContent extends StatelessWidget {
  ForcecheckinContent({this.child});
  final child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1.0),
          color: Colors.transparent),
      child: child,
    );
  }
}
