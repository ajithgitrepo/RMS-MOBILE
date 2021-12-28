import 'package:flutter/material.dart';
import '../../Constants.dart';
import 'package:flutter/cupertino.dart';
import 'MenuContent.dart';
import 'package:merchandising/api/api_service.dart';
import 'package:merchandising/api/timesheetapi.dart';
import 'timesheetmonthly.dart';
import 'package:merchandising/main.dart';
import 'package:merchandising/api/timesheetmonthly.dart';
import'package:merchandising/Fieldmanager/FMdashboard.dart';
import 'package:merchandising/Fieldmanager/merchandiserslist.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/Time Sheet.dart';

class TimeSheetListSS extends StatefulWidget {
  @override
  _TimeSheetListSSState createState() => _TimeSheetListSSState();
}

class _TimeSheetListSSState extends State<TimeSheetListSS> {
  bool pressAttentionMTB = false;
  bool pressAttentionTODAY = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: containerscolor,
        iconTheme: IconThemeData(color: orange),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Split Shift Time Sheet',
                  style: TextStyle(color: orange),
                ),
                Spacer(),
              ],
            ),
            EmpInfo(),
          ],
        ),
      ),
      // drawer: Drawer(
      //   child: Menu(),
      // ),
      body: Stack(
        children: [
          BackGround(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container(
              //   margin: EdgeInsets.all(10.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Text(
              //         'Display TimeSheet For',
              //         style: TextStyle(fontSize: 17,color: Colors.white),
              //       ),
              //
              //     ],
              //   ),
              // ),
              Container(
                margin: EdgeInsets.all(10.00),
                padding: EdgeInsets.all(10.00),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.00),
                  color:containerscolor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentuser.roleid == 5 ? timesheet.empname : DBrequestdata.empname,
                        style: TextStyle(fontSize: 16,)),
                    Row(
                      children: [
                        Text(
                          "Merchandiser ID :",
                          style: TextStyle(fontSize: 16,),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(currentuser.roleid == 5 ? timesheet.empid :DBrequestdata.receivedempid,
                            style: TextStyle(fontSize: 16,))
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Outlet :",
                          style: TextStyle(fontSize: 16,),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(outletnameSS[outletindex],
                            style: TextStyle(fontSize: 16,))
                      ],
                    ),
                    //Text(currentuser.roleid==5?"Total TimeSheet Monthly:${tts}":" ",style: TextStyle(fontSize: 16,))
                  ],
                ),
              ),
             TimeSheetdailySS(),

              // Container(
              //   margin: EdgeInsets.only(bottom:10.0,right: 10.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             normal = true;
              //             splitshit = false;
              //           });
              //         },
              //         child: Container(
              //           height: 40,
              //           width: 100,
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.end,
              //             children: [
              //               Center(
              //                 child: Text(
              //                   'Normal',
              //                   style: TextStyle(
              //                     color: normal == true
              //                         ? Colors.white
              //                         : Colors.black,
              //                   ),
              //                 ),
              //               ),
              //               Icon(CupertinoIcons.triangle_fill,size: 12,color: Colors.white,),
              //             ],
              //           ),
              //           decoration: BoxDecoration(
              //             border: Border.all(color: Colors.white,width: 1.0),
              //             borderRadius: BorderRadius.only(
              //                 topLeft: Radius.circular(10),
              //                 bottomLeft: Radius.circular(10)),
              //             color: normal == true
              //                 ? orange
              //                 : Colors.white,
              //           ),
              //         ),
              //       ),
              //       GestureDetector(
              //         onTap: () {
              //           setState(() {
              //             splitshit = true;
              //             normal = false;
              //           });
              //         },
              //         child: Container(
              //           height: 40,
              //           width: 100,
              //           child: Column(
              //             mainAxisAlignment: MainAxisAlignment.end,
              //             children: [
              //               Center(
              //                 child: Text(
              //                   'Split Shit',
              //                   style: TextStyle(
              //                     color: splitshit == false
              //                         ? Colors.black
              //                         : Colors.white,
              //                   ),
              //                 ),
              //               ),
              //               Icon(CupertinoIcons.triangle_fill,size: 12,color: Colors.white,),
              //             ],
              //           ),
              //           decoration: BoxDecoration(
              //             border: Border.all(color: Colors.white,width: 1.0),
              //             borderRadius: BorderRadius.only(
              //                 topRight: Radius.circular(10),
              //                 bottomRight: Radius.circular(10)),
              //             color: splitshit == true
              //                 ? orange
              //                 : Colors.white,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // pressAttentionMTB == true ? Timesheetmonthly() : TimeSheetdaily()
            ],
          ),
        ],
      ),
    );
  }
}

class TimeSheetdailySS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          //shrinkWrap: false,
          itemCount: TotalJnyTime.id.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                height: 80,
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.fromLTRB(10.0,0,10.0,10.0),
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

                      Row(
                          children: [
                            Text('CheckIn Time : ',style: TextStyle(fontSize: 16.0,)),
                            Text('${TotalJnyTime.checkin[index]}',style: TextStyle(fontSize: 16.0,))
                          ]),

                      Row(children: [
                        Text('CheckOut Time : ',style: TextStyle(fontSize: 16.0,)),
                        Text('${TotalJnyTime.checkout[index]}',style: TextStyle(fontSize: 16.0,))
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
                ));
          }),
    );
  }
}




