import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:merchandising/Constants.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/MenuContent.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:merchandising/main.dart';
import 'package:photo_view/photo_view.dart';
import 'package:merchandising/api/FMapi/merc_leave_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/api/leaveresult.dart';
import 'package:merchandising/Fieldmanager/FMdashboard.dart';
import 'package:merchandising/HR/HRdashboard.dart';
import 'package:merchandising/Fieldmanager/Leavereporting.dart';
import'package:merchandising/api/FMapi/leave_reportapi.dart';
int leave;

class ResponsetoLeave extends StatefulWidget {
  @override
  _ResponsetoLeaveState createState() => _ResponsetoLeaveState();
}

bool isApiCallProcess = false;
class _ResponsetoLeaveState extends State<ResponsetoLeave> {
  String accepted = "2";
  String acceptedbyfm = "1";
  String rejected = "1";
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: containerscolor,
          iconTheme: IconThemeData(color: orange),
          title: Column(
            children: [
              Text(
                'Leave Response',
                style: TextStyle(color: orange),
              ),
              EmpInfo()
            ],
          ),
        ),
        // drawer: Drawer(
        //   child: Menu(),
        // ),
        body: Stack(children: [
          BackGround(),

          DefaultTabController(
            length: 2, // lengt0h of tabs
            initialIndex: 0,
            child:Scaffold(
              backgroundColor: Colors.transparent,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(kToolbarHeight),
                child: Container(
                  margin: EdgeInsets.fromLTRB(10,10,10,0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.white,
                  ),
                  child: TabBar(
                    //    controller: _controller,
                    labelColor: orange,
                    unselectedLabelColor: Colors.black,
                    indicatorColor: orange,
                    tabs: [
                      Tab(text: 'Leave Reporting'),
                      Tab(text: 'Accept / Reject leave\'s'),
                    ],
                  ),
                ),
              ),
              body: TabBarView(
                  children: [
                    LeaveReporting(
                      onsubmit: onsave,
                    ),
                    ListView.builder(
                        itemCount: leavedataResponse.reasons.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              leave = index;
                              print(leavedataResponse.isleaveaccepted[leave]);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) => leaveresult()));
                            },
                            child: Container(
                              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(10))),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Reason : ',
                                        style: TextStyle(
                                            fontSize: 15.0, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: AutoSizeText(
                                          '${leavedataResponse.reasons[index]}',
                                          maxLines: 2,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text('Leave Type:',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          '${leavedataResponse.leavetypes[index]}',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          )),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text('Number of days :',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          leavedataResponse.totnoofdays[index]
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          )),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text('Employee :',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(leavedataResponse.empname[index]
                                          .toString()),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text('Status :',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          )),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          leavedataResponse.isleaveaccepted[index] == accepted
                                              ? 'Accepted'
                                              : leavedataResponse.isleaverejected[index] == rejected
                                              ? 'Rejected'
                                              :  leavedataResponse.isleaveaccepted[index] == acceptedbyfm
                                              ? 'Waiting for hr'
                                              : 'Pending',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          )),
                                      Spacer(),
                                      Icon(
                                        leavedataResponse.isleaveaccepted[index] == accepted
                                            ? CupertinoIcons.check_mark_circled_solid
                                            : leavedataResponse.isleaverejected[index] == rejected ? CupertinoIcons
                                            .clear_circled_solid : CupertinoIcons
                                            .arrow_up_arrow_down_circle_fill,
                                        color: leavedataResponse.isleaveaccepted[index] == accepted
                                            ? Colors.green
                                            : leavedataResponse.isleaverejected[index] == rejected ? Colors.red : Colors.grey,
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                ],
                              ),
                            ),
                          );
                        }),
                  ]),
            ),
          ),
        ]));
  }
  void onsave()async{
    print("1");
    setState(() {
      isApiCallProcess = true;
    });


    // if (selectedReason == "others") {
    //   print(others.text);
    // }
    leaverequestdata.type=selectedReason;
    leaverequestdata.startdate=startDate;
    leaverequestdata.enddate = endDate;
    leaverequestdata.reason = remarks.text;
    leaverequestdata.image = base64doc;

    await leaverequestwithtype();

    setState(() {
      isApiCallProcess = false;
    });
  }
}

class leaveresult extends StatefulWidget {
  @override
  _leaveresultState createState() => _leaveresultState();
}

class _leaveresultState extends State<leaveresult> {
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: pink,
          iconTheme: IconThemeData(color: orange),
          title: Text(
            "Leave Response",
            style: TextStyle(color: orange),
          ),
        ),
        drawer: Drawer(
          child: Menu(),
        ),
        body: Stack(
          children: [
            BackGround(),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height/2.3,
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Reason : ',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: AutoSizeText(
                                leavedataResponse.reasons[leave],
                                style: TextStyle( fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Leave Type:',
                                style: TextStyle(
                                  fontSize: 15.0,
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                                leavedataResponse.leavetypes[leave]
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 15.0,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text('total number of days',
                                style: TextStyle(
                                  fontSize: 15.0,
                                )),
                            Text(
                                leavedataResponse.totnoofdays[leave]
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 15.0,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Employee name :',
                                style: TextStyle(
                                  fontSize: 15.0,
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Text(leavedataResponse.empname[leave]
                                .toString()),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Employee ID :',
                                style: TextStyle(
                                  fontSize: 15.0,
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Text(leavedataResponse
                                .empid[leave]
                                .toString()),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Start Date :',
                                style: TextStyle(
                                  fontSize: 15.0,
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Text(leavedataResponse.Startdates[leave]),
                          ],
                        ),
                        Row(
                          children: [
                            Text('End date :',
                                style: TextStyle(
                                  fontSize: 15.0,
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Text(leavedataResponse.enddates[leave]
                                .toString()),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Requested on :',
                                style: TextStyle(
                                  fontSize: 15.0,
                                )),
                            SizedBox(
                              width: 5,
                            ),
                            Text(leavedataResponse.requestedon[leave]
                                .toString()
                                .substring(0, 10)),
                          ],
                        ),
                        leavedataResponse.leavetypes[leave]
                            .toString() ==
                            "Sick_Leave"
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Supported Documents :',
                                style: TextStyle(
                                  fontSize: 15.0,
                                )),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            VeiwImage()));
                              },
                              child: Container(
                                width: 60,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: orange,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(child: Text("Veiw",style: TextStyle(color: Colors.white),)),
                              ),
                            ),
                          ],
                        )
                            : SizedBox(),
                        currentuser.roleid == 3 && leavedataResponse.isleaveaccepted[leave] == '1' && leavedataResponse.isleaverejected[leave] == '0' ? Padding(
                          padding: const EdgeInsets.only(top:20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isApiCallProcess = true;
                                  });
                                  result.id = null;
                                  result.isapproved = null;
                                  result.isrejected = null;
                                  result.isrejected = '1';
                                  currentuser.roleid ==3 ? result.isapproved ="1":result.isapproved ="0";
                                  result.id = leavedataResponse.leaveid[leave];
                                  await leaveacceptorreject();
                                  setState(() {
                                    isApiCallProcess = false;
                                  });
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              HRdashboard()));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Reject Leave",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async{
                                  result.id = null;
                                  result.isapproved = null;
                                  result.isrejected = null;
                                  currentuser.roleid ==3 ? result.isapproved ="2":result.isapproved ="1";
                                  result.id = leavedataResponse.leaveid[leave];
                                  result.isrejected = '0';
                                  await leaveacceptorreject();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              HRdashboard()));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Accept Leave",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ) : SizedBox(),
                        currentuser.roleid == 5 && leavedataResponse.isleaveaccepted[leave] == '0' && leavedataResponse.isleaverejected[leave] == '0' ?
                        Padding(
                          padding: const EdgeInsets.only(top:20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    isApiCallProcess = true;
                                  });
                                  result.id = null;
                                  result.isapproved = null;
                                  result.isrejected = null;
                                  result.isrejected = '1';
                                  currentuser.roleid ==3 ? result.isapproved ="1":result.isapproved ="0";
                                  result.id = leavedataResponse.leaveid[leave];
                                  await leaveacceptorreject();
                                  setState(() {
                                    isApiCallProcess = false;
                                  });
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              FieldManagerDashBoard()));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Reject Leave",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  result.id = null;
                                  result.isapproved = null;
                                  result.isrejected = null;
                                  currentuser.roleid ==3 ? result.isapproved ="2":result.isapproved ="1";
                                  result.id = leavedataResponse.leaveid[leave];
                                  result.isrejected = '0';
                                  await leaveacceptorreject();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              FieldManagerDashBoard()));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "Accept Leave",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                            : SizedBox()
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
    );
  }
}

class VeiwImage extends StatelessWidget {
  String url =
      "https://rms2.rhapsody.ae/leavedocuments/${leavedataResponse.supportdocs[leavedataResponse.supportdocs.length - 1 - leave].toString()}";
  @override
  Widget build(BuildContext context) {
    return PhotoView(
      loadingBuilder: (context, event) => Center(
        child: Container(
          width: 40.0,
          height: 40.0,
          child: CircularProgressIndicator(
          ),
        ),
      ),
      imageProvider: NetworkImage(
        url,
      ),
    );
  }
}

