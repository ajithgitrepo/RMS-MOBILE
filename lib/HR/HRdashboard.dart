import 'package:merchandising/Constants.dart';
import 'package:flutter/material.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/MenuContent.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/Leave Request.dart';
import 'package:merchandising/model/leaveresponse.dart';
import 'package:merchandising/HR/empreporting.dart';
import 'package:merchandising/HR/holidays.dart';
import 'package:merchandising/HR/workingday.dart';
import 'package:merchandising/HR/employees.dart';
import 'package:merchandising/api/HRapi/hrdashboardapi.dart';
import 'package:merchandising/api/HRapi/empdetailsapi.dart';
import 'package:merchandising/api/HRapi/empdetailsforreportapi.dart';
import 'package:merchandising/api/holidays.dart';
import 'package:merchandising/api/leavestakenapi.dart';
import 'package:merchandising/api/myattendanceapi.dart';
import 'package:merchandising/model/myattendance.dart';
import 'package:merchandising/api/FMapi/merc_leave_details.dart';
import 'package:merchandising/api/leaverules.dart';
import 'package:merchandising/HR/leaverules.dart';



class HRdashboard extends StatefulWidget {
  @override
  _HRdashboardState createState() => _HRdashboardState();
}
bool isApiCallProcess = false;
class _HRdashboardState extends State<HRdashboard> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        home: ProgressHUD(
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
          child:Scaffold(
            appBar: AppBar(
              backgroundColor: pink,
              iconTheme: IconThemeData(color: orange),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image(
                    height: 30,
                    image: AssetImage('images/rmsLogo.png'),
                  ),
                ],
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
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width/3.2,
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
                                      Icons.calendar_today,
                                      size: 35,
                                      color: iconscolor,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Attendance\nReport',
                                      textAlign: TextAlign.center,style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              setState(()  {
                                isApiCallProcess = true;
                              });
                              await getallempdetails();
                              setState(()  {
                                isApiCallProcess = false;
                              });
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context) => EmployeeDetailes()));

                            },
                            child: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width/3.2,
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
                                        Icons.people_alt,
                                        size: 35,
                                        color: iconscolor,
                                      ),
                                      SizedBox(height: 10),
                                      Text('Employees', textAlign: TextAlign.center,style: TextStyle(fontSize: 12),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              setState(()  {
                                isApiCallProcess = true;
                              });
                              await getempdetailsforreport();
                              await getallempdetails();
                              setState(()  {
                                isApiCallProcess = false;
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Reportingemp()));
                            },
                            child: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width/3.2,
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
                                        Icons.link_rounded,
                                        size: 35,
                                        color: iconscolor,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Reporting',
                                        textAlign: TextAlign.center,style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(5,10,5,10),
                            height:181,
                            width: MediaQuery.of(context).size.width/1.43,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: containerscolor,
                            ),
                            child: Column(
                              children: [
                                Text("Attendance Summary",style: TextStyle(fontSize: 16),),
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
                                              "Employees",style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                '${HRdashboarddata.emptotal}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                'Total',style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                '${HRdashboarddata.emppresent}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Present",style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                '${HRdashboarddata.empabsent}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Absent",style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text(
                                              "Field\nManagers",style: TextStyle(fontSize: 12),textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                '${HRdashboarddata.fmtotal}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Total",style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                '${HRdashboarddata.fmpresent}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Present",style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                '${HRdashboarddata.fmabsent}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Absent",style: TextStyle(fontSize: 10),
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
                                              "Merchandisers",style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                '${HRdashboarddata.merchtotal}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Total",style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                '${HRdashboarddata.merchpresent}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Present",style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                '${HRdashboarddata.merchabsent}',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Absent",style: TextStyle(fontSize: 10),
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
                          Column(
                            children: [
                              Container(
                                height: 100,
                                width: MediaQuery.of(context).size.width/3.8,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: containerscolor,
                                ),
                                child: GestureDetector(
                                  onTap: ()async{
                                    setState(() {
                                      isApiCallProcess = true;
                                    });
                                    await merchleavedetails();
                                    setState(() {
                                      isApiCallProcess = false;
                                    });
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (BuildContext context) => ResponsetoLeave()));
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text('${HRdashboarddata.leaveresponsetotal}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                                      Text("Total Leave Request's",textAlign: TextAlign.center,),
                                    ],
                                  ),
                                ),),
                              SizedBox(height: 5,),
                              Container(
                                height: 76,
                                width: MediaQuery.of(context).size.width/3.8,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: containerscolor,
                                ),
                                child: Center(child: Text("Employee Leave Balance",textAlign: TextAlign.center,)),),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: ()async{
                              setState(() {
                                isApiCallProcess = true;
                              });
                              await holidaysdata();
                              setState(() {
                                isApiCallProcess = false;
                              });
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context) => HoliDays()));
                            },
                            child: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width/3.2,
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
                                        Icons.leave_bags_at_home,
                                        size: 35,
                                        color: iconscolor,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Holidays',
                                        textAlign: TextAlign.center,style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context) => WorkDay()));
                            },
                            child: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width/3.2,
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
                                        'Working days',
                                        textAlign: TextAlign.center,style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{

                              await leaverulesdata1();

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context) => LeaveRules()));
                            },
                            child: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width/3.2,
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
                                        Icons.note_add_rounded,
                                        size: 35,
                                        color: iconscolor,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Leave Rules',
                                        textAlign: TextAlign.center,style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Text("My Activity",style: TextStyle(color: containerscolor,fontSize: 16,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: ()async{
                              setState(() {
                                isApiCallProcess =true;
                              });
                              await getmyattandance();
                              setState(() {
                                isApiCallProcess = false;
                              });
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context) => MyAttendance()));
                            },
                            child: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width/2.6,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: containerscolor,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("My Attendance"),
                                  Text('${HRdashboarddata.attendance}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: ()async{
                              setState(() {
                                isApiCallProcess = true;
                              });
                              await leaveData();
                              setState(() {
                                isApiCallProcess = false;
                              });
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context) => leavestatusPage()));
                            },
                            child: Container(
                              height: 120,
                              width: MediaQuery.of(context).size.width/1.75,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: containerscolor,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Apply Leave"),
                                  Text('${HRdashboarddata.leavebalance}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                                  Text("Total Available Leave's"),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 125,
                        margin: EdgeInsets.only(top: 10,bottom: 10),
                        width: MediaQuery.of(context).size.width / 1.03,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: containerscolor,
                        ),
                        child: Row(
                          children: [
                            Spacer(
                              flex: 2,
                            ),
                            Icon(
                              CupertinoIcons.sun_max,
                              color: Colors.black,
                              size: 50,
                            ),
                            Spacer(flex: 2),
                            Text(
                              'Welcome to the new HR\ninterface of RMS. '
                                  'Hope to have a\ngreat day ahead!',
                              style: new TextStyle(fontSize: 15
                              ),
                            ),
                            Spacer(
                              flex: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

        ),
      ),
    );
  }
}
