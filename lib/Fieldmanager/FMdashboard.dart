import 'package:merchandising/Constants.dart';
import 'package:flutter/material.dart';
import 'package:merchandising/Fieldmanager/products.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/Fieldmanager/rel_details.dart';
import 'package:merchandising/api/api_service.dart';
import 'package:merchandising/api/cde%20api/cdedashboard.dart';
import 'package:merchandising/api/customer_activites_api/competition_details.dart';
import 'Outlets.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/MenuContent.dart';
import 'package:merchandising/model/leaveresponse.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/Leave Request.dart';
import 'package:merchandising/api/FMapi/fmdbapi.dart';
import 'package:merchandising/api/FMapi/relieverdet_api.dart';
import 'package:merchandising/Fieldmanager/addjp.dart';
import 'package:merchandising/api/leavestakenapi.dart';
import 'merchandiserslist.dart';
import 'package:merchandising/api/FMapi/merc_leave_details.dart';
import 'chatusers.dart';
import 'package:merchandising/clients/clientoutlet_details.dart';
import 'package:merchandising/model/myattendance.dart';
import'package:merchandising/api/noti_detapi.dart';
import'package:merchandising/api/FMapi/merchnamelistapi.dart';
import'package:merchandising/api/Journeyplansapi/weekly/jpplanned.dart';
import 'package:merchandising/main.dart';
import 'package:merchandising/api/FMapi/cdereportapi.dart';
import'package:merchandising/Fieldmanager/reporting.dart';
import'package:merchandising/Merchandiser/merchandiserscreens/timesheetmonthly.dart';
import'package:merchandising/Merchandiser/merchandiserscreens/Time Sheet.dart';




class FieldManagerDashBoard extends StatefulWidget {
  @override
  _FieldManagerDashBoardState createState() => _FieldManagerDashBoardState();
}

class _FieldManagerDashBoardState extends State<FieldManagerDashBoard> {
  void initState() {
    if(fromloginscreen){
      Future.delayed(
          const Duration(seconds: 2), (){
        showDialog(
            context: context,
            builder: (_) => StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    backgroundColor: pink,//alertboxcolor,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.all(
                            Radius.circular(10.0))),
                    content: Builder(
                      builder: (context) {
                        // Get available height and width of the build area of this widget. Make a choice depending on the size.
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(greetingMessage(),style: TextStyle(color: orange,fontSize: 20),),
                            Divider(color: Colors.black,),
                            Text("Wish you have a great day ahead 😀",textAlign: TextAlign.center,),
                            SizedBox(height: 5,),
                            Text(DBrequestdata.empname,textAlign: TextAlign.center,style: TextStyle(color: orange,fontSize: 14),),
                            SizedBox(height: 20,),
                            Row(
                              children: [
                                Spacer(),
                                Image(
                                  height: 30,
                                  image: AssetImage('images/rmsLogo.png'),
                                ),
                              ],
                            )

                          ],
                        );
                      },
                    ),
                  );
                }));
      });
      fromloginscreen = false;
    }
    //super.initState();
  }
  bool isApiCallProcess = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ProgressHUD(
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: pink,
              iconTheme: IconThemeData(color: orange),
              title: Column(
                children: [
                  Image(
                  height: 30,
                  image: AssetImage('images/rmsLogo.png'),
            ),
                  EmpInfo()
                ],
              ),
            ),
            drawer: GestureDetector(
              onTap: ()async{
                print("Menu Tapped");
                // setState(() {
                //   isApiCallProcess=true;
                // });
                //
                // await getNotificationDetails();
                // setState(() {
                //   isApiCallProcess=false;
                // });


              },
              child: Drawer(
                child: Menu(),
              ),
            ),

            body: Stack(
              children: [
                BackGround(),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      GestureDetector(
                        onTap: () async{
                          // setState(() {
                          //   isApiCallProcess = true;
                          // });
                          // await getmerchnamelist();
                          // await getFMoutletdetails();
                          // await getWeekoffdetails();
                          // setState(() {
                          //   isApiCallProcess = false;
                          // });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AddJourneyPlan()));

                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
                          height: 181,
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: containerscolor,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Text("Performance Indicator", style: TextStyle(
                                    fontSize: 16),),
                                SizedBox(height: 10,),
                                Table(
                                  border: TableBorder.symmetric(
                                    inside: BorderSide(color: Colors.grey),
                                  ),
                                  columnWidths: {
                                    0: FractionColumnWidth(.35),
                                  },
                                  children: [
                                    TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 14.0),
                                          child: Center(
                                            child: Text(
                                              "Merchandisers",
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              Text(currentuser.roleid==5?
                                                FMdashboarddata.merchtotal.toString():CDEDBdata.merchtotal.toString(), style: TextStyle(fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Total",
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              Text(currentuser.roleid==5?FMdashboarddata.merchpresent.toString()
                                                :CDEDBdata.merchpresent.toString(), style: TextStyle(fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Present",
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              Text(currentuser.roleid==5?
                                                FMdashboarddata.merchabsent.toString():CDEDBdata.merchabsent.toString(), style: TextStyle(fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Absent",
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 14.0),
                                          child: Center(
                                            child: Text(
                                              "Total Outlets",
                                              style: TextStyle(fontSize: 12),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              Text(
                                                currentuser.roleid==5?
                                                FMdashboarddata.mtotaloutlets.toString():
                                                CDEDBdata.mtotaloutlets.toString(), style: TextStyle(fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Total",
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              Text(
                                                currentuser.roleid==5?
                                                FMdashboarddata.mcompoutlets.toString():
                                                CDEDBdata.mcompoutlets.toString(), style: TextStyle(fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Completed",
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              Text( currentuser.roleid==5?
                                                FMdashboarddata.mpendingoutlets.toString():
                                                CDEDBdata.mpendingoutlets.toString(), style: TextStyle(fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Pending",
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 14.0),
                                          child: Center(
                                            child: Text(
                                              "Today Outlets",
                                              style: TextStyle(fontSize: 12),
                                            )
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              Text( currentuser.roleid==5?
                                                FMdashboarddata.totaloulets.toString():
                                                CDEDBdata.totaloulets.toString(), style: TextStyle(fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Total",
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              Text( currentuser.roleid==5?
                                                FMdashboarddata.compoutlets.toString():CDEDBdata.compoutlets.toString(), style: TextStyle(fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Completed",
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              Text( currentuser.roleid==5?
                                                FMdashboarddata.pendingoutlets.toString():
                                                CDEDBdata.pendingoutlets.toString(), style: TextStyle(fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Pending",
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap:() async{
                              // setState(() {
                              //   isApiCallProcess = true;
                              // });
                              // await getFMoutletdetails();
                              // setState(() {
                              //   isApiCallProcess = false;
                              // });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Oulets()));
                            },
                            child: Container(
                              height: 120,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 3.2,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: containerscolor,
                              ),
                              child: Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.building_2_fill,
                                        size: 35,
                                        color: iconscolor,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Outlets',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 15,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              // setState(() {
                              //   isApiCallProcess = true;
                              // });
                              // await getmerchnamelist();
                              // await getFMoutletdetails();
                              // await getWeekoffdetails();
                              // setState(() {
                              //   isApiCallProcess = false;
                              // });

                              setState(() {
                                isApiCallProcess=true;
                              });
                              // await merchnamelistunderCDE();
                              await getJourneyPlanweekly();
                              currentuser.roleid == 5? await getmerchnamelist(): await merchnamelistunderCDE();

                              setState(() {
                                isApiCallProcess=false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          AddJourneyPlan()));
                            },
                            child: Container(
                              height: 120,
                              width:MediaQuery
                                  .of(context)
                                  .size
                                  .width / 3.2,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: containerscolor,
                              ),
                              child: Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.bus,
                                        size: 35,
                                        color: iconscolor,
                                      ),

                                      SizedBox(height: 10),
                                      Text('Journey Plan',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: ()async{
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ClientOutletsdata()));
                            },
                            child: Container(
                              height: 120,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 3.2,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: containerscolor,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    CupertinoIcons.doc_chart_fill,
                                    size: 35,
                                    color: iconscolor,
                                  ),
                                  Text("Reports",style: TextStyle(fontSize: 15.0),),
                                ],
                              ),
                            ),
                          ),


                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap:()async{
                              selecteddates=[];
                              for(int i =0; i<listOfDates.length;i++){
                                selecteddates.add(false);
                              }

                              setState(() {
                                isApiCallProcess = true;

                              });

                              // await gettimesheetleavetype();

                              setState(() {
                                isApiCallProcess = false;
                              });
                              // print(selecteddates.length);



                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          MerchandisersList()));
                            },
                            child: Container(
                              height: 120,
                              width:currentuser.roleid==5? MediaQuery
                                  .of(context)
                                  .size
                                  .width / 3.2:MediaQuery.of(context).size.width/2.2,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: containerscolor,
                              ),
                              child: Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_chart,
                                        size: 35,
                                        color: iconscolor,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Time Sheet',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 15,),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: ()async{
                              // setState(() {
                              //   isApiCallProcess = true;
                              // });
                              // await getFMoutletdetails();
                              // await getBrandDetails();
                              // await getemployeestoaddbrand();
                              // await getCategoryDetails();
                              // await getProductDetails();
                              // await getFMoutletdetails();
                              // await getPromoDetails();
                              // setState(() {
                              //   isApiCallProcess = false;
                              // });
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context) => Products()));
                            },
                            child: Container(
                              height: 120,
                              width:currentuser.roleid==5? MediaQuery
                                  .of(context)
                                  .size
                                  .width / 3.2:MediaQuery.of(context).size.width/2.0,

                              padding: EdgeInsets.all(10),

                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: containerscolor,
                              ),
                              child: Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.barcode,
                                        size: 35,
                                        color: iconscolor,
                                      ),

                                      SizedBox(height: 10),
                                      Text(
                                        'Activities',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          currentuser.roleid==5?
                          GestureDetector(
                            onTap:()async{
                              setState(() {
                                isApiCallProcess = true;
                              });
                              await merchleavedetails();
                              setState(() {
                                isApiCallProcess = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ResponsetoLeave()));
                            },
                            child: Container(
                              height: 120,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 3.2,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: containerscolor,
                              ),
                              child: Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(FMdashboarddata.leaveresponsetotal.toString(),style:TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                                      SizedBox(height: 10),
                                      Text(
                                        'Leave Response',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 15,),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ):SizedBox(),

                        ],
                      ),
                      // SizedBox(height: 10,),
                      // Text("My Activities", style: TextStyle(color: containerscolor,
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold),),
                      SizedBox(height: 10),
                     currentuser.roleid==5? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () async{
                              setState(() {
                                isApiCallProcess = true;
                              });
                              await leaveData();
                              setState(() {
                                isApiCallProcess = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext
                                      context) =>
                                          leavestatusPage()));
                            },
                            child: Container(
                              height: 120,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 3.2,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: containerscolor,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(FMdashboarddata.leavebalance.toString(), style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 30),),
                                  Text(" Leave\nBalance",style: TextStyle(fontSize: 15),),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap:()async{
                              // // setState((){
                              // //   isApiCallProcess = true;
                              // // });
                              // // await getStoreDetails();
                              // // setState((){
                              // //   isApiCallProcess = false;
                              // // });
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (BuildContext context) =>
                              //             StoreDetails()));
                              setState(() {
                                isApiCallProcess=true;
                              });
                              await getRelieverDetails();
                              //await getmerchnamelist();
                              setState(() {
                                isApiCallProcess=false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          RelieverDetails()));

                            },
                            child: Container(
                              height: 120,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 3.2,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: containerscolor,
                              ),
                              child: Center(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.person_add_solid,
                                        size: 35,
                                        color: iconscolor,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Reliever',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 15,),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                           GestureDetector(
                            onTap: () async{
                              setState(() {
                                isApiCallProcess = true;
                              });
                              await CDEReportingDetails();
                              setState(() {
                                isApiCallProcess = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext
                                      context) =>
                                          CDEReportScreen()));
                            },
                            child: Container(
                              height: 120,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width / 3.2,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: containerscolor,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    CupertinoIcons.link,
                                    size: 35,
                                    color: iconscolor,
                                  ),

                                  Text(" CDE\nReporting"),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ):SizedBox(),
                      Container(
                        height: 125,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        width: MediaQuery
                            .of(context)
                            .size
                            .width / 1.03,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: containerscolor,
                        ),
                        child: Row(
                          children: [
                            Spacer(flex: 2,),
                            Icon(
                              CupertinoIcons.sun_max,
                              color: Colors.black,
                              size: 50,
                            ),
                            Spacer(flex: 2),
                            currentuser.roleid==5?Text(
                              'Welcome to the new field manager\ninterface of RMS.'
                                  ' Hope you have a\ngreat day ahead!',
                              style: new TextStyle(fontSize: 15
                              ),
                            ):Text('Welcome to the new CDE interface\nof RMS.'
                                ' Hope you have a\ngreat day ahead!',
                              style: new TextStyle(fontSize: 15
                              )),
                            Spacer(
                              flex: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    margin: EdgeInsets.all(15.0),
                    child: FloatingActionButton(
                      onPressed: ()async{
                        // setState(() {
                        //   isApiCallProcess = true;
                        // });
                        // await getmerchnamelist();
                        // setState(() {
                        //   isApiCallProcess = false;
                        // });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext
                                context) =>
                                    ChatUsers()));
                      },
                      backgroundColor: orange,
                      elevation: 10.0,
                      child: Icon(CupertinoIcons.chat_bubble_2_fill,color: pink,),
                    ),
                  ),
                ),
              ],
            ),
          ),

        ),
    );
  }
}



/**/

// TimeSheetdatadaily.timeid = currenttimesheetid;
// print('timesheet id : ${TimeSheetdatadaily.timeid}');
// setState(() {
//   isApiCallProcess = true;
// });
// await getTimeSheetdaily();
//
// setState(() {
//   isApiCallProcess = false;
// });