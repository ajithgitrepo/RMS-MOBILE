import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:merchandising/Fieldmanager/addjp.dart';
import 'package:merchandising/clients/clientoutlet_details.dart';
import '../../Constants.dart';
import 'package:flutter/cupertino.dart';
import 'MenuContent.dart';
import 'package:merchandising/api/api_service.dart';
import 'package:merchandising/api/timesheetapi.dart';
import 'timesheetmonthly.dart';
import 'package:merchandising/main.dart';
import 'package:merchandising/api/timesheetmonthly.dart';
import 'package:merchandising/Fieldmanager/FMdashboard.dart';
import 'package:merchandising/Fieldmanager/merchandiserslist.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/TS_split.dart';
import 'package:merchandising/model/Yearlytimesheet.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';
import 'package:flushbar/flushbar.dart';

bool isApiCallProcess = false;
String Approveddates;
List selecteddatestoapprove=[];
bool selected= false;
List<bool>selecteddates;
bool alldateselected = false;

class TimeSheetList extends StatefulWidget {
  @override
  _TimeSheetListState createState() => _TimeSheetListState();
}

class _TimeSheetListState extends State<TimeSheetList> {
  @override
  void initState() {
    super.initState();
    selectedDate=null;
  }
  bool pressAttentionMTB = false;
  bool pressAttentionTODAY = true;
  bool pressAttentionYTB = false;

  bool splitshit = false;
  bool normal = true;
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      opacity: 0.3,
      inAsyncCall: isApiCallProcess,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: containerscolor,
          iconTheme: IconThemeData(color: orange),
          title: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Time Sheet',
                    style: TextStyle(color: orange),
                  ),
                  EmpInfo()
                ],
              ),
              Spacer(),
              currentuser.roleid == 2 && pressAttentionYTB == false?GestureDetector(
                onTap: ()async{

                          Approveddates = null;
                          for (int i = 0; i < listOfDatesapi.length; i++) {
                            if (selecteddates[i]) {
                              todaydateapprove = listOfDatesapi[i];
                              if (Approveddates == null) {
                                Approveddates = DateFormat('MMMMd')
                                    .format(DateTime.parse(listOfDatesapi[i]));
                              } else {
                                String temp = Approveddates;
                                Approveddates = "$temp,${DateFormat('MMMMd').format(DateTime.parse(listOfDatesapi[i]))}";
                              }
                            }
                          }
                          if(pressAttentionMTB==true && Approveddates == null){
                            Flushbar(
                              message: "Please select dates to approve Time Sheet",
                              duration: Duration(seconds: 4),
                            )..show(context);
                            print("No Dates Selected");
                          }

                          else {
                          showDialog(
                            context: context,
                            builder: (_) =>
                                StatefulBuilder(builder: (context, setState) {
                              return AlertDialog(
                                backgroundColor: alertboxcolor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                content: Builder(
                                  builder: (context) {
                                    // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                    return ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              1.5),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text("Alert",
                                                style: TextStyle(
                                                    color: orange,
                                                    fontSize: 20)),
                                            Divider(
                                              color: Colors.black,
                                              thickness: 0.8,
                                            ),
                                            Text(
                                              pressAttentionTODAY == true
                                                  ? "Do you want to Approve Time Sheet for Today?"
                                                  : 'Do you want to approve Time Sheet\nfor the following dates?',
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(height:5),
                                            pressAttentionMTB == true
                                                ? Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      pressAttentionMTB == true
                                                          ? Approveddates
                                                          : "${DateFormat('MMMMd').format(DateTime.parse(dataofdates.toString()))}",
                                                      style:
                                                          TextStyle(fontSize: 14),
                                                    ),
                                                )
                                                : Text(""),
                                            pressAttentionMTB == true
                                                ? SizedBox(height: 15)
                                                : SizedBox(height:1),
                                            GestureDetector(
                                              onTap: () async {
                                                print(selecteddates);

                                                if (pressAttentionMTB == true) {
                                                  print(listOfDatesapi.length);
                                                  Approveddates = null;
                                                  for (int i = 0;
                                                      i < listOfDatesapi.length;
                                                      i++) {
                                                    if (selecteddates[i]) {
                                                      todaydateapprove =
                                                          listOfDatesapi[i];
                                                      if (Approveddates ==
                                                          null) {
                                                        Approveddates = DateFormat(
                                                                'MMMMd')
                                                            .format(DateTime.parse(
                                                                listOfDatesapi[
                                                                    i]));
                                                      } else {
                                                        String temp =
                                                            Approveddates;
                                                        Approveddates =
                                                            "$temp,${DateFormat('MMMMd').format(DateTime.parse(listOfDatesapi[i]))}";
                                                      }

                                                      DBrequestdata
                                                              .receivedempid =
                                                          timesheet.empid;
                                                      await CDETimeSheetApproval();
                                                    }
                                                  }
                                                  print(
                                                      "selected dates String : $Approveddates");
                                                  setState(() {
                                                    selecteddates = [];
                                                    for (int i = 0;
                                                        i < listOfDates.length;
                                                        i++) {
                                                      selecteddates.add(false);
                                                    }
                                                  });
                                                } else if (pressAttentionTODAY ==
                                                    true) {
                                                  final DateTime now =
                                                      DateTime.now();
                                                  final DateFormat formatter =
                                                      DateFormat('yyyy-MM-dd');
                                                  final String todaydate =
                                                      formatter.format(now);
                                                  todaydateapprove = todaydate;
                                                  DBrequestdata.receivedempid =
                                                      timesheet.empid;
                                                  await CDETimeSheetApproval();
                                                }

                                                Navigator.pop(context);

                                                setState(() {
                                                  selecteddates = [];
                                                  for (int i = 0;
                                                      i < listOfDates.length;
                                                      i++) {
                                                    selecteddates.add(false);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 80,
                                                decoration: BoxDecoration(
                                                  color: orange,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Center(
                                                    child: Text('Approve',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white))),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            }),
                          );
                        }
                          setState(() {
                            for(int i=0;i<listOfDatesapi.length;i++){
                              selecteddates[i]=false;
                              alldateselected=false;

                            }

                          });

                      },
                child: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(10.00),
                  ),
                  child: Text( "Approve",style: TextStyle(fontSize: 15,color: Colors.white),),
                ),
              ):SizedBox(),
            ],
          ),
        ),
        // drawer: Drawer(
        //   child: Menu(),
        // ),
        body: Stack(
          children: [
            BackGround(),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50.0),
                  ),
                  Container(
                    margin: EdgeInsets.all(10.00),
                    padding: EdgeInsets.all(10.00),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.00),
                      color: containerscolor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            currentuser.roleid == 5 || currentuser.roleid == 2
                                ? timesheet.empname
                                : DBrequestdata.empname,
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        Row(
                          children: [
                            Text(
                              "Merchandiser ID :",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                                currentuser.roleid == 5 ||
                                        currentuser.roleid == 2
                                    ? timesheet.empid
                                    : DBrequestdata.receivedempid,
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                          ],
                        ),
                        pressAttentionYTB
                            ? selectedDate != null
                                ? Text(
                                    "Time sheet for ${DateFormat('yMMMM').format(selectedDate)}",
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  )
                                : SizedBox()
                            : SizedBox(),
                      ],
                    ),
                  ),

                  pressAttentionMTB == true
                      ? SafeArea(child: Timesheetmonthly())
                      : pressAttentionYTB == true
                          ? SafeArea(
                              child: selectedDate != null
                                  ? Timesheetyearly()
                                  : Text("Please choose the Month"))
                          : SizedBox(
                              height: MediaQuery.of(context).size.height / 1.43,
                              width: double.infinity,
                              child: ListView.builder(
                                  //shrinkWrap: false,
                                  itemCount:
                                      TimeSheetdatadaily.checkintime.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    outletindex = index;
                                    return GestureDetector(
                                      onTap: () async {
                                        for (int i = 0;
                                            i <
                                                TimeSheetdatadaily
                                                    .checkintime.length;
                                            i++) {
                                          outletnameSS.add("");
                                        }
                                        outletnameSS[outletindex] =
                                            TimeSheetdatadaily
                                                .outletname[index];
                                        currenttimesheetid =
                                            TimeSheetdatadaily.tsid[index];

                                        print(
                                            "TS is for SS:${currenttimesheetid}");

                                        setState(() {
                                          isApiCallProcess = true;
                                        });

                                        await getTotalJnyTime();

                                        setState(() {
                                          isApiCallProcess = false;
                                        });

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        TimeSheetListSS()));
                                      },
                                      child: Container(
                                          height: 100,
                                          padding: EdgeInsets.all(10.0),
                                          margin: EdgeInsets.fromLTRB(
                                              10.0, 0, 10.0, 10.0),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10.00)),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Row(children: [
                                                  Text('Outlet Name : ',
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                      )),
                                                  Text(
                                                      '${TimeSheetdatadaily.outletname[index]}',
                                                      style: TextStyle(
                                                          color: orange,
                                                          fontSize: 16.0)),
                                                ]),
                                                Row(children: [
                                                  Text('CheckIn Time : ',
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                      )),
                                                  Text(
                                                      '${TimeSheetdatadaily.checkintime[index]}',
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                      ))
                                                ]),
                                                Row(children: [
                                                  Text('CheckOut Time : ',
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                      )),
                                                  Text(
                                                      '${TimeSheetdatadaily.checkouttime[index]}',
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                      ))
                                                ]),
                                              ],
                                            ),
                                          )),
                                    );
                                  }),
                            )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Text(
                  //   'Display TimeSheet For',
                  //   style: TextStyle(fontSize: 17,color: Colors.white),
                  // ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            pressAttentionYTB = true;
                            pressAttentionTODAY = false;
                            pressAttentionMTB = false;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Center(
                                child: Text(
                                  'YTB',
                                  style: TextStyle(
                                    color: pressAttentionYTB == true
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Icon(
                                CupertinoIcons.triangle_fill,
                                size: 12,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white, width: 1.0),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            color: pressAttentionYTB == true
                                ? orange
                                : Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            pressAttentionMTB = true;
                            pressAttentionTODAY = false;
                            pressAttentionYTB = false;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Center(
                                child: Text(
                                  'MTB',
                                  style: TextStyle(
                                    color: pressAttentionMTB == true
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              Icon(
                                CupertinoIcons.triangle_fill,
                                size: 12,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white, width: 1.0),
                            // borderRadius: BorderRadius.only(
                            //     topLeft: Radius.circular(10),
                            //     bottomLeft: Radius.circular(10)),
                            color: pressAttentionMTB == true
                                ? orange
                                : Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            pressAttentionTODAY = true;
                            pressAttentionMTB = false;
                            pressAttentionYTB = false;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Center(
                                child: Text(
                                  'Today',
                                  style: TextStyle(
                                    color: pressAttentionTODAY == false
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                              Icon(
                                CupertinoIcons.triangle_fill,
                                size: 12,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.white, width: 1.0),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: pressAttentionTODAY == true
                                ? orange
                                : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButton: pressAttentionYTB
            ? Theme(
                data: ThemeData(
                  primarySwatch: Colors.orange
                ),
                child: Builder(
                  builder: (context) => FloatingActionButton(
                    onPressed: () {
                      showMonthPicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 1, 5),
                        lastDate: DateTime(DateTime.now().year + 1, 9),
                        initialDate: selectedDate ?? initialDate,
                      ).then((date) async {
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                          print(selectedDate);
                          Selectedday = DateFormat('yyyy-MM-dd').format(selectedDate);
                          setState(() {
                            isApiCallProcess = true;
                          });
                          await getSelectedtimesheetmonthly();
                          setState(() {
                            isApiCallProcess = false;
                          });
                          listOfDatesUI = new List<String>.generate(
                              daysInMonthyearly(DateTime(
                                  int.parse(
                                      DateFormat('yyyy').format(selectedDate)),
                                  int.parse(
                                      DateFormat('MM').format(selectedDate)))),
                              (i) =>
                                  "${DateFormat('MMMM').format(selectedDate)} ${'${i + 1}'}");
                        }
                      });
                    },
                    child: Icon(
                      Icons.calendar_today,
                      color: orange,
                    ),
                    backgroundColor: pink,
                  ),
                ))
            : SizedBox(),
      ),
    );
  }
}

int outletindex;
List<String> outletnameSS = [];

class TimeSheetdaily extends StatefulWidget {
  @override
  _TimeSheetdailyState createState() => _TimeSheetdailyState();
}

class _TimeSheetdailyState extends State<TimeSheetdaily> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.43,
      width: double.infinity,
      child: ListView.builder(
          shrinkWrap: false,
          itemCount: TimeSheetdatadaily.checkintime.length,
          itemBuilder: (BuildContext context, int index) {
            outletindex = index;

            return GestureDetector(
              onTap: () async {
                for (int i = 0;
                    i < TimeSheetdatadaily.checkintime.length;
                    i++) {
                  outletnameSS.add("");
                }
                outletnameSS[outletindex] =
                    TimeSheetdatadaily.outletname[index];
                currenttimesheetid = TimeSheetdatadaily.tsid[index];

                print("TS is for SS:${currenttimesheetid}");

                setState(() {
                  isApiCallProcess = true;
                });

                await getTotalJnyTime();

                setState(() {
                  isApiCallProcess = false;
                });

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => TimeSheetListSS()));
              },
              child: Container(
                  height: 100,
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.00)),
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(children: [
                          Text('Outlet Name : ',
                              style: TextStyle(
                                fontSize: 16.0,
                              )),
                          Text('${TimeSheetdatadaily.outletname[index]}',
                              style: TextStyle(color: orange, fontSize: 16.0)),
                        ]),
                        Row(children: [
                          Text('CheckIn Time : ',
                              style: TextStyle(
                                fontSize: 16.0,
                              )),
                          Text('${TimeSheetdatadaily.checkintime[index]}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ))
                        ]),
                        /*Row(children: [
                          Text('Check In Location:',
                              style: TextStyle(
                                fontSize: 13.0,
                              )),
                          SizedBox(width: 10),
                          Text(${TimeSheetdata.[index]}),
                        ]),*/
                        Row(children: [
                          Text('CheckOut Time : ',
                              style: TextStyle(
                                fontSize: 16.0,
                              )),
                          Text('${TimeSheetdatadaily.checkouttime[index]}',
                              style: TextStyle(
                                fontSize: 16.0,
                              ))
                        ]),
                        /* Row(children: [
                          Text('Check Out Location:',
                              style: TextStyle(
                                fontSize: 13.0,
                              )),
                          SizedBox(width: 10),
                          Text('${checkoutlocation[index]}',
                          ),
                        ]),*/
                      ],
                    ),
                  )),
            );
          }),
    );
  }
}
