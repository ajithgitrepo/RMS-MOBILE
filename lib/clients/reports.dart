import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import "package:merchandising/Constants.dart";
import 'package:merchandising/ProgressHUD.dart';
import 'package:merchandising/clients/clientoutlet_details.dart';
import 'package:merchandising/main.dart';
import 'package:photo_view/photo_view.dart';
import 'package:merchandising/api/avaiablityapi.dart';
import 'package:merchandising/api/customer_activites_api/visibilityapi.dart';
import 'package:merchandising/api/customer_activites_api/share_of_shelf_detailsapi.dart';
import 'package:merchandising/api/clientapi/outletreport.dart';
import 'package:merchandising/api/api_service.dart';
import 'package:merchandising/api/customer_activites_api/competition_details.dart';
import 'package:merchandising/api/customer_activites_api/planogramdetailsapi.dart';
import 'package:merchandising/api/customer_activites_api/promotion_detailsapi.dart';
import 'exportreports.dart';
import 'package:merchandising/api/clientapi/clientpromodetailes.dart';
import 'package:merchandising/api/clientapi/stockexpirydetailes.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:merchandising/api/sendfile.dart';
import 'package:url_launcher/url_launcher.dart';
String day;
String outletname;
bool isavaiability =false;
bool isvisibility =false;
bool issos =false;
bool isplano =false;
bool ispromotion =false;
bool iscomptn =false;
bool isexpiry =false;
bool isApiCallProcess = false;
bool ischecklist =false;
int indexclientselected;
class ClientsReports extends StatefulWidget {
  @override
  _ClientsReportsState createState() => _ClientsReportsState();
}

class _ClientsReportsState extends State<ClientsReports> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: containerscolor,
        iconTheme: IconThemeData(color: orange),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Activites',
                  style: TextStyle(color: orange),
                ),
                EmpInfo()
              ],
            ),
            // GestureDetector(
            //   onTap: ()async{
            //     // var loadsDirectory = await DownloadsPathPdownrovider.downloadsDirectory;
            //     // print(downloadsDirectory);
            //     Exportall= true;
            //     String newdir = (await getExternalStorageDirectory()).path +"/${clientoutlets.outletname[indexclientselected]}_reports_${DateFormat.Hm().format(DateTime.now())}";
            //     print(newdir);
            //     new Directory(newdir).create().then((Directory directory) {
            //        print(directory.path);
            //        pathtoexport = directory.path;
            //      });
            //     var plano = await ExportPLanogram();
            //     if(plano != null){
            //       Flushbar(
            //         message: 'File was successfully saved at $pathtoexport',
            //         duration: Duration(seconds: 5),
            //       )..show(context);
            //     }
            //   },
            //   child: Container(
            //     margin: EdgeInsets.only(right: 10.00),
            //     padding: EdgeInsets.all(10.0),
            //     decoration: BoxDecoration(
            //       color: Color(0xffFFDBC1),
            //       borderRadius: BorderRadius.circular(10.00),
            //     ),
            //     child: Text(
            //       'Export All',
            //       style: TextStyle(color: Colors.black, fontSize: 15),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      body: Stack(
        children: [
          BackGround(),
          Column(
            children: [
              OutletData(),
              Center(child: Text("Merchandiser activites",style: TextStyle(color: pink),)),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isavaiability = true;
                          isvisibility =false;
                          issos =false;
                          isplano =false;
                          ispromotion =false;
                          iscomptn =false;
                          isexpiry =false;
                          ischecklist =false;;
                        });
                      },
                      child: ActivitesSelector(
                        activityname: "Availability",
                        ontap: isavaiability,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isavaiability = false;
                          isvisibility =true;
                          issos =false;
                          isplano =false;
                          ispromotion =false;
                          iscomptn =false;
                          isexpiry =false;
                          ischecklist =false;
                        });
                      },
                      child: ActivitesSelector(
                        activityname: "Visibility",
                        ontap: isvisibility,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isavaiability = false;
                          isvisibility =false;
                          issos =true;
                          isplano =false;
                          ispromotion =false;
                          iscomptn =false;
                          isexpiry =false;
                          ischecklist =false;
                        });
                      },
                      child: ActivitesSelector(
                        activityname: "Share Of Shelf",
                        ontap: issos,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isavaiability = false;
                          isvisibility =false;
                          issos =false;
                          isplano =true;
                          ispromotion =false;
                          iscomptn =false;
                          isexpiry =false;
                          ischecklist =false;
                        });
                      },
                      child: ActivitesSelector(
                        activityname: "Planogram",
                        ontap: isplano,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isavaiability = false;
                          isvisibility =false;
                          issos =false;
                          isplano =false;
                          ispromotion =true;
                          iscomptn =false;
                          isexpiry =false;
                          ischecklist =false;
                        });
                      },
                      child: ActivitesSelector(
                        activityname: "Promotion Check",
                        ontap: ispromotion,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isavaiability = false;
                          isvisibility =false;
                          issos =false;
                          isplano =false;
                          ispromotion =false;
                          iscomptn =true;
                          isexpiry =false;
                          ischecklist =false;
                        });
                      },
                      child: ActivitesSelector(
                        activityname: "Competitor",
                        ontap: iscomptn,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isavaiability = false;
                          isvisibility =false;
                          issos =false;
                          isplano =false;
                          ispromotion =false;
                          iscomptn =false;
                          isexpiry =true;
                          ischecklist =false;
                        });
                      },
                      child: ActivitesSelector(
                        activityname: "Expiry Information",
                        ontap: isexpiry,
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isavaiability = false;
                          isvisibility =false;
                          issos =false;
                          isplano =false;
                          ispromotion =false;
                          iscomptn =false;
                          isexpiry =false;
                          ischecklist =true;
                        });
                      },
                      child: ActivitesSelector(
                        activityname: "CheckList",
                        ontap: ischecklist,
                      ),
                    ),
                  ],
                ),
              ),
              isavaiability||isvisibility||issos||isplano||ispromotion||iscomptn||ischecklist||isexpiry ? Expanded(
                child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.00),
                      color:pink,
                    ),
                    child: isavaiability?Avaialibility():isvisibility?Visibility():issos?ShareOfShelf():
                    isplano?Planogram():ispromotion?Promotion():iscomptn?Competition():ischecklist?Checklist():isexpiry?ExpiryData():SizedBox()
                ),
              ):SizedBox(),
            ],
          )
        ],
      ),
    );
  }
}

class OutletData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.00),
        color:Colors.white//pink,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('${clientoutlets.outletname[indexclientselected]}',
              style: TextStyle(
                  fontSize: 14.0,fontWeight: FontWeight.bold,color: orange
              )),
          SizedBox(height: 5),
          Text('Date : ${clientoutlets.lastvisiteddate[indexclientselected].toString()}'),
          SizedBox(height: 5),
          Text('Visit Type : ${clientoutlets.isschedulevisit[indexclientselected].toString()== "1"? "Scheduled":"UnScheduled"}'),
          SizedBox(height: 5),
          Text('Checkin Time : ${clientoutlets.checkintime[indexclientselected].toString()}'),
          SizedBox(height: 5),
          Text('Checkout Time : ${clientoutlets.checkouttime[indexclientselected].toString()}'),
          SizedBox(height: 5),
          Text('Checkin Location : ${clientoutlets.checkinlocation[indexclientselected].toString()}'),
          SizedBox(height: 5),
          Text('Checkout Location : ${clientoutlets.checkoutlocation[indexclientselected].toString()}'),
          SizedBox(height: 5),
          Text('Visited By : ${clientoutlets.merchandiserid[indexclientselected].toString()}'),
        ],
      ),
    );
  }
}

class ActivitesSelector extends StatefulWidget {
  ActivitesSelector({this.activityname,this.ontap});
  final String activityname;
  bool ontap = false;
  @override
  _ActivitesSelectorState createState() => _ActivitesSelectorState();
}

class _ActivitesSelectorState extends State<ActivitesSelector> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.00),
        color: widget.ontap ? orange:pink,
      ),
      child: Text(widget.activityname,style: TextStyle(color:widget.ontap ? pink:orange,fontSize: 16 ),),
    );
  }
}

class Avaialibility extends  StatefulWidget {
  @override
  _AvaialibilityState createState() => _AvaialibilityState();
}

class _AvaialibilityState extends State<Avaialibility> {
  bool pis = false;

  bool pos = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  pressAttentionMTB = true;
                  pressAttentionTODAY = false;
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
                        "INS",
                        style: TextStyle(
                          color: pressAttentionMTB == true
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    Icon(CupertinoIcons.triangle_fill,size: 12,color: Colors.white,),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white,width: 1.0),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
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
                        'OOS',
                        style: TextStyle(
                          color: pressAttentionTODAY == false
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                    Icon(CupertinoIcons.triangle_fill,size: 12,color: Colors.white,),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white,width: 1.0),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: pressAttentionTODAY == true
                      ? orange
                      : Colors.white,
                ),
              ),
            ),
            Spacer(),
            // GestureDetector(
            //   onTap: ()async{
            //     setState(() {
            //       isApiCallProcess = true;
            //     });
            //     String exportedlocation = await Exportavaiablity();
            //     setState(() {
            //       isApiCallProcess = false;
            //     });
            //     if(exportedlocation != null){
            //       Flushbar(
            //         message: 'File was successfully saved at $exportedlocation',
            //         duration: Duration(seconds: 5),
            //       )..show(context);
            //      // OpenFile.open('storage/emulated/0/Android/data/rameolic.merchandising/files/');
            //     }else{
            //       Map<Permission, PermissionStatus> statuses = await [
            //         Permission.storage,
            //       ].request();
            //     }
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom:8),
            //     child: Text("Export to CSV",style: TextStyle(color: orange,fontSize: 16),),
            //   ),
            // ),
          ],
        ),
        SizedBox(height: 10.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom:5.0),
              child: Text("Products Sku(ZREP)",style: TextStyle(color: orange,fontSize: 16),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:5.0),
              child: Text(pressAttentionMTB ? "":"Reason",style: TextStyle(color: orange,fontSize: 16),),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            //physics: const NeverScrollableScrollPhysics(),
             // shrinkWrap: true,
              itemCount: pressAttentionMTB ? Avaiablity.insreason.length : Avaiablity.oosreason.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:5.0),
                          child: SizedBox(
                            width: pressAttentionMTB ? MediaQuery.of(context).size.width/1.25:MediaQuery.of(context).size.width/1.6,
                            child: pressAttentionMTB?Text(Avaiablity.insreason[index]):Text(Avaiablity.oos[index])
                          ),
                        ),
                        pressAttentionMTB ?SizedBox():Text(Avaiablity.oosreason[index])
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                    )
                  ],
                );
              }),
        ),
      ],
    );
  }
}

bool pressAttentionMTB = false;
bool pressAttentionTODAY = true;
class Visibility extends StatefulWidget {
  @override
  _VisibilityState createState() => _VisibilityState();
}

class _VisibilityState extends State<Visibility> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                print("INS/OOS");
                print(VisibilityData.ooscatdata);
                setState(() {
                  pressAttentionMTB = true;
                  pressAttentionTODAY = false;
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
                        "INS",
                        style: TextStyle(
                          color: pressAttentionMTB == true
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                    Icon(CupertinoIcons.triangle_fill,size: 12,color: Colors.white,),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white,width: 1.0),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
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
                        'OOS',
                        style: TextStyle(
                          color: pressAttentionTODAY == false
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                    ),
                    Icon(CupertinoIcons.triangle_fill,size: 12,color: Colors.white,),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white,width: 1.0),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  color: pressAttentionTODAY == true
                      ? orange
                      : Colors.white,
                ),
              ),
            ),
            Spacer(),
            // GestureDetector(
            //   onTap: ()async{
            //     setState(() {
            //       isApiCallProcess = true;
            //     });
            //     String exportedlocation = await ExportVisibility();
            //     setState(() {
            //       isApiCallProcess = false;
            //     });
            //     if(exportedlocation != null){
            //       Flushbar(
            //         message: 'File was successfully saved at $exportedlocation',
            //         duration: Duration(seconds: 5),
            //       )..show(context);
            //     }else{
            //       Map<Permission, PermissionStatus> statuses = await [
            //         Permission.storage,
            //       ].request();
            //     }
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom:8),
            //     child: Text("Export to CSV",style: TextStyle(color: orange,fontSize: 16),),
            //   ),
            // ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom:5.0),
              child: Text("categories",style: TextStyle(color: orange,fontSize: 16),),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom:5.0,top: 10.0),
              child: Text("status",style: TextStyle(color: orange,fontSize: 16),),
            ),
          ],
        ),
        pressAttentionTODAY ? Expanded(
          child: ListView.builder(
            //physics: const NeverScrollableScrollPhysics(),
            //  shrinkWrap: true,
              itemCount: VisibilityData.ooscatdata.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:5.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width/1.6,
                            child: Text(VisibilityData.ooscatdata[index]),
                          ),
                        ),
                        Text(VisibilityData.oosreason[index])
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                    )
                  ],
                );
              }),
        ) : Expanded(
          child: ListView.builder(
            //physics: const NeverScrollableScrollPhysics(),
             // shrinkWrap: true,
              itemCount: VisibilityData.inscatdata.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:5.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width/1.6,
                            child: Text(VisibilityData.inscatdata[index]),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PreveiwScreen(
                                          input: VisibilityData.insimage[index],
                                        )));
                          },
                          child: Container(
                            height: 30,
                            width: 50,
                            decoration: BoxDecoration(
                              color: orange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(child: Text("Veiw",style: TextStyle(color: Colors.white),)),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                    )
                  ],
                );
              }),
        ),
      ],
    );
  }
}


class PreveiwScreen extends StatelessWidget {
  PreveiwScreen({@required this.input});
  String input;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onVerticalDragEnd: (details) {
            Navigator.pop(context);
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: PhotoView(
              loadingBuilder: (context, event) => Center(
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  child: CircularProgressIndicator(
                    backgroundColor: orange,
                  ),
                ),
              ),
              imageProvider: NetworkImage(input),
            ),
          ),)
      ],
    );
  }
}
Future<void> _launchInBrowser(String url) async {
  if (true) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}
class ShareOfShelf extends StatefulWidget {
  @override
  _ShareOfShelfState createState() => _ShareOfShelfState();
}

class _ShareOfShelfState extends State<ShareOfShelf> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // GestureDetector(
        //   onTap: ()async{
        //     setState(() {
        //       isApiCallProcess = true;
        //     });
        //
        //     // reports.reportfile = await ExportShareofshelf();
        //     // UploadFile();
        //     String downloadurl = await DownloadFile();
        //     _launchInBrowser(downloadurl);
        //     // WidgetsFlutterBinding.ensureInitialized();
        //     // await FlutterDownloader.initialize(
        //     //     debug: true // optional: set false to disable printing logs to console
        //     // );
        //     // var directory = await DownloadsPathProvider.downloadsDirectory;
        //     // final taskId = await FlutterDownloader.enqueue(
        //     //   url: downloadurl,
        //     //   savedDir: directory.path,
        //     //   showNotification: true, // show download progress in status bar (for Android)
        //     //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
        //     // );
        //     // print(taskId);
        //     setState(() {
        //       isApiCallProcess = false;
        //     });
        //   },
        //   child: Padding(
        //     padding: const EdgeInsets.only(bottom:10),
        //     child: Text("Export to CSV",style: TextStyle(color: orange,fontSize: 16),),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(bottom:10.0),
          child: Table(
            columnWidths: {
              0: FlexColumnWidth(3),
            },
            children: [
              TableRow(
                children: [
                  Text("Category",style: TextStyle(color: orange),),
                  Center(child: Text("Target",style: TextStyle(color: orange),)),
                  Center(child: Text("Share",style: TextStyle(color: orange),)),
                  Center(child: Text("Actual",style: TextStyle(color: orange),)),
                ]
              )
            ],
          ),
        ),
        ShareData.actualpercent.length!=0?
        Expanded(
          child: ListView.builder(
            //physics: const NeverScrollableScrollPhysics(),
              //shrinkWrap: true,
              itemCount: ShareData.actualpercent.length,
              itemBuilder: (BuildContext context, int index) {
                return ShareData.actualpercent.toString() != "[null]" ?Column(
                  children: [

                    Table(
                      columnWidths: {
                        0: FlexColumnWidth(3),
                      },
                      children: [
                        TableRow(
                            children: [
                              Text(ShareData.categoryname[index]),
                              Center(child: Text("${ShareData.target[index]} %")),
                              Center(child: Text(ShareData.actualpercent[index] != null ?'${ShareData.share[index]} m':"No Data")),
                              Center(child: Text(ShareData.actualpercent[index] != null ?'${double.parse(ShareData.actualpercent[index]).toStringAsFixed(0)} %':"No Data")),
                            ]
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                    )
                  ],
                ):SizedBox();
              }),
        ):SizedBox()
      ],
    );
  }
}

class Planogram extends StatefulWidget {
  @override
  _PlanogramState createState() => _PlanogramState();
}

class _PlanogramState extends State<Planogram> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // GestureDetector(
        //   onTap: ()async{
        //     setState(() {
        //       isApiCallProcess = true;
        //     });
        //     String exportedlocation = await ExportPLanogram();
        //     setState(() {
        //       isApiCallProcess = false;
        //     });
        //     if(exportedlocation != null){
        //       Flushbar(
        //         message: 'File was successfully saved at $exportedlocation',
        //         duration: Duration(seconds: 5),
        //       )..show(context);
        //     }else{
        //       Map<Permission, PermissionStatus> statuses = await [
        //         Permission.storage,
        //       ].request();
        //     }
        //   },
        //   child: Padding(
        //     padding: const EdgeInsets.only(bottom:10),
        //     child: Text("Export to CSV",style: TextStyle(color: orange,fontSize: 16),),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(bottom:10.0),
          child: Table(
            columnWidths: {
              0: FlexColumnWidth(3),
            },
            children: [
              TableRow(
                  children: [
                    Text("Category",style: TextStyle(color: orange,fontWeight: FontWeight.bold),),
                    //Center(child: Text("Target",style: TextStyle(color: orange,fontWeight: FontWeight.bold),)),
                    Center(child: Text("Before",style: TextStyle(color: orange,fontWeight: FontWeight.bold),)),
                    Center(child: Text("After",style: TextStyle(color: orange,fontWeight: FontWeight.bold),)),
                  ]
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            //physics: const NeverScrollableScrollPhysics(),
             // shrinkWrap: true,
              itemCount: PlanoDetails.categoryname.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Table(
                      columnWidths: {
                        0: FlexColumnWidth(3),
                      },
                      children: [
                        TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top:40.0),
                                child: Text( PlanoDetails.categoryname[index],),
                              ),
                              // GestureDetector(
                              //   onTap: (){
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (BuildContext context) =>
                              //                 PreveiwScreen(
                              //                   input: PlanoDetails.imageurl[index],
                              //                 )));
                              //   },
                              //   child: Center(
                              //     child: Container(
                              //       margin: EdgeInsets.all(10.0),
                              //       height: 80,
                              //       width: 50,
                              //       child: PhotoView(
                              //         loadingBuilder: (context, event) => Center(
                              //           child: Container(
                              //             width: 40.0,
                              //             height: 40.0,
                              //             child: CircularProgressIndicator(
                              //               backgroundColor: orange,
                              //             ),
                              //           ),
                              //         ),
                              //         imageProvider: NetworkImage(  PlanoDetails.imageurl[index]),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              PreveiwScreen(
                                                input: PlanoDetails.beforeimage[index],
                                              )));
                                },
                                child: Center(
                                  child: Container(
                                    margin: EdgeInsets.all(10.0),
                                    height: 80,
                                    width: 50,
                                    child: PhotoView(
                                      loadingBuilder: (context, event) => Center(
                                        child: Container(
                                          width: 40.0,
                                          height: 40.0,
                                          child: CircularProgressIndicator(
                                            backgroundColor: orange,
                                          ),
                                        ),
                                      ),
                                      imageProvider: NetworkImage(  PlanoDetails.beforeimage[index]),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              PreveiwScreen(
                                                input: PlanoDetails.afterimage[index],
                                              )));
                                },
                                child: Center(
                                  child: Container(
                                    margin: EdgeInsets.all(10.0),
                                    height: 80,
                                    width: 50,
                                    child: PhotoView(
                                      loadingBuilder: (context, event) => Center(
                                        child: Container(
                                          width: 40.0,
                                          height: 40.0,
                                          child: CircularProgressIndicator(
                                            backgroundColor: orange,
                                          ),
                                        ),
                                      ),
                                      imageProvider: NetworkImage(  PlanoDetails.afterimage[index]),
                                    ),
                                  ),
                                ),
                              ),
                            ]
                        )
                      ],
                    ),
                    Divider(color: Colors.black,)
                  ],
                );
              }),
        ),
      ],
    );
  }
}

class Promotion extends StatefulWidget {
  @override
  _PromotionState createState() => _PromotionState();
}

class _PromotionState extends State<Promotion> {

  bool pressAttentionMTB = true;
  bool pressAttentionTODAY = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    pressAttentionMTB = true;
                    pressAttentionTODAY = false;
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
                          "INS",
                          style: TextStyle(
                            color: pressAttentionMTB == true
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      Icon(CupertinoIcons.triangle_fill,size: 12,color: Colors.white,),
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white,width: 1.0),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
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
                          'OOS',
                          style: TextStyle(
                            color: pressAttentionTODAY == false
                                ? Colors.black
                                : Colors.white,
                          ),
                        ),
                      ),
                      Icon(CupertinoIcons.triangle_fill,size: 12,color: Colors.white,),
                    ],
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white,width: 1.0),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    color: pressAttentionTODAY == true
                        ? orange
                        : Colors.white,
                  ),
                ),
              ),
              Spacer(),
              // GestureDetector(
              //   onTap: ()async{
              //     setState(() {
              //       isApiCallProcess = true;
              //     });
              //     String exportedlocation = await Exportpromotion();
              //     setState(() {
              //       isApiCallProcess = false;
              //     });
              //     if(exportedlocation != null){
              //       Flushbar(
              //         message: 'File was successfully saved at $exportedlocation',
              //         duration: Duration(seconds: 5),
              //       )..show(context);
              //     }else{
              //       Map<Permission, PermissionStatus> statuses = await [
              //         Permission.storage,
              //       ].request();
              //     }
              //   },
              //   child: Padding(
              //     padding: const EdgeInsets.only(bottom:10),
              //     child: Text("Export to CSV",style: TextStyle(color: orange,fontSize: 16),),
              //   ),
              // ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom:5.0),
                child: Text("Product :",style: TextStyle(color: orange,fontSize: 16),),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom:5.0,top: 10.0),
                child: Text(pressAttentionTODAY ?"Reason":"Image",style: TextStyle(color: orange,fontSize: 16),),
              ),
            ],
          ),
          pressAttentionTODAY ? ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount:clientpromo.reason.length,
              itemBuilder: (BuildContext context, int index) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:5.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width/1.6,
                              child: Text(clientpromo.productnameoos[index]),
                            ),
                          ),
                          Text(clientpromo.reason[index])
                        ],
                      ),
                      Divider(
                        color: Colors.black,
                      ),
                    ],
                  ),
                );
              }) : ListView.builder(
            //physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: clientpromo.productname.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:5.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width/1.6,
                            child: Text(clientpromo.productname[index]),
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        PreveiwScreen(
                                          input: clientpromo.imageurl[index],
                                        )));
                          },
                          child: SizedBox(
                            height: 80,
                            width: 50,
                            child: PhotoView(
                              loadingBuilder: (context, event) => Center(
                                child: Container(
                                  width: 40.0,
                                  height: 40.0,
                                  child: CircularProgressIndicator(
                                    backgroundColor: orange,
                                  ),
                                ),
                              ),
                              imageProvider: NetworkImage(clientpromo.imageurl[index]),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}

class Competition extends StatefulWidget {
  @override
  _CompetitionState createState() => _CompetitionState();
}

class _CompetitionState extends State<Competition> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Competitor Info :",style: TextStyle(color: orange,fontSize: 16),),

            // GestureDetector(
            //   onTap: ()async{
            //     setState(() {
            //       isApiCallProcess = true;
            //     });
            //     String exportedlocation = await ExportCompetation();
            //     setState(() {
            //       isApiCallProcess = false;
            //     });
            //     if(exportedlocation != null){
            //       Flushbar(
            //         message: 'File was successfully saved at $exportedlocation',
            //         duration: Duration(seconds: 5),
            //       )..show(context);
            //     }else{
            //       Map<Permission, PermissionStatus> statuses = await [
            //         Permission.storage,
            //       ].request();
            //     }
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom:10),
            //     child: Text("Export to CSV",style: TextStyle(color: orange,fontSize: 16),),
            //   ),
            // ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            //physics: const NeverScrollableScrollPhysics(),
             // shrinkWrap: true,
              itemCount:CompetitionData.brandname.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(top:10.0),
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 140,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${CompetitionData.itemname[index]}",style: TextStyle(color: orange,fontSize: 16),),
                          Text("Company : ${CompetitionData.companyname[index]}"),

                          Text("Category : ${CompetitionData.brandname[index]}"),

                          Text("Regular Price :${CompetitionData.mrp[index].toString()} AED"),

                          Text("Selling Price : ${CompetitionData.sellingprice[index].toString()} AED"),

                          Text("Promotion type : ${CompetitionData.promotype[index].toString()}"),

                          Text("Promotion description : ${CompetitionData.promodesc[index].toString()}"),
                        ],
                      ),

                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    PreveiwScreen(
                                      input:CompetitionData.captureimg[index],
                                    )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0,10,5,0),
                        child: SizedBox(
                          height: 100,
                          width: 80,
                          child: PhotoView(
                            loadingBuilder: (context, event) => Center(
                              child: Container(
                                width: 40.0,
                                height: 40.0,
                                child: CircularProgressIndicator(
                                  backgroundColor: orange,
                                ),
                              ),
                            ),
                            imageProvider: NetworkImage('${CompetitionData.captureimg[index]}'),
                          ),
                        ),
                      ),
                    ),
                  ],
                  ),
                );
              }
          ),
        ),
      ],
    );
  }
}


class Checklist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Task Details",style: TextStyle(color: orange,fontSize: 16),),
            //Text("Status",style: TextStyle(color: orange,fontSize: 16),),
          ],
        ),
        SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            //physics: const NeverScrollableScrollPhysics(),
            // shrinkWrap: true,
              itemCount: fmviewtaskdata.url.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Table(
                      columnWidths: {
                        0: FlexColumnWidth(3),
                      },
                      children: [
                        TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top:40.0),
                                child: Text( "${fmviewtaskdata.list[index].toString()}"),
                              ),
                              // GestureDetector(
                              //   onTap: (){
                              //     Navigator.push(
                              //         context,
                              //         MaterialPageRoute(
                              //             builder: (BuildContext context) =>
                              //                 PreveiwScreen(
                              //                   input: PlanoDetails.imageurl[index],
                              //                 )));
                              //   },
                              //   child: Center(
                              //     child: Container(
                              //       margin: EdgeInsets.all(10.0),
                              //       height: 80,
                              //       width: 50,
                              //       child: PhotoView(
                              //         loadingBuilder: (context, event) => Center(
                              //           child: Container(
                              //             width: 40.0,
                              //             height: 40.0,
                              //             child: CircularProgressIndicator(
                              //               backgroundColor: orange,
                              //             ),
                              //           ),
                              //         ),
                              //         imageProvider: NetworkImage(  PlanoDetails.imageurl[index]),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              PreveiwScreen(
                                                input: fmviewtaskdata.url[index],
                                              )));
                                },
                                child: Center(
                                  child: Container(
                                    margin: EdgeInsets.all(10.0),
                                    height: 80,
                                    width: 50,
                                    child: PhotoView(
                                      loadingBuilder: (context, event) => Center(
                                        child: Container(
                                          width: 40.0,
                                          height: 40.0,
                                          child: CircularProgressIndicator(
                                            backgroundColor: orange,
                                          ),
                                        ),
                                      ),
                                      imageProvider: NetworkImage(fmviewtaskdata.url[index]),
                                    ),
                                  ),
                                ),
                              ),

                            ]
                        )
                      ],
                    ),
                    Divider(color: Colors.black,)
                  ],
                );
              }),
        ),
        // Expanded(
        //   child: ListView.builder(
        //     //physics: const NeverScrollableScrollPhysics(),
        //      // shrinkWrap: true,
        //       itemCount:task.list.length,
        //       itemBuilder: (BuildContext context, int index) {
        //         return Column(
        //           crossAxisAlignment: CrossAxisAlignment.start,
        //           children: [
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //               children: [
        //                 SizedBox(
        //                   width: MediaQuery.of(context).size.width/1.35,
        //                     child: Text("${task.list[index].toString()}")),
        //                // Text(task.iscompleted[index] == 1 ? "done":"pending")
        //               ],
        //             ),
        //             Divider(
        //               color: Colors.black,
        //             )
        //           ],
        //         );}),
        // ),
      ],
    );
  }
}

class ExpiryData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom:8),
              child: Text("Expiry Details :",style: TextStyle(color: orange,fontSize: 16),),
            ),
            // GestureDetector(
            //   onTap: ()async{
            //     String exported = await ExportStockExpiry();
            //     if(exported != null){
            //         Flushbar(
            //           message: 'File was successfully saved at $exported',
            //           duration: Duration(seconds: 5),
            //         )..show(context);
            //       }else{
            //         Map<Permission, PermissionStatus> statuses = await [
            //           Permission.storage,
            //         ].request();
            //       }
            //   },
            //   child: Padding(
            //     padding: const EdgeInsets.only(bottom:8),
            //     child: Text("Export to CSV",style: TextStyle(color: orange,fontSize: 16),),
            //   ),
            // ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            //physics: const NeverScrollableScrollPhysics(),
              //shrinkWrap: true,
              itemCount:Stockdata.productname.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(top:10.0),
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 250,
                        child: Padding(
                          padding: const EdgeInsets.only(left:5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(child: Text("${Stockdata.productname[index]} [${Stockdata.zrepcode[index]}]",style: TextStyle(color: orange),)),
                              //Text("Outlet : ${Stockdata.outlet[index]}"),
                              Text("Expiry Date : ${Stockdata.expirydate[index].toString()}"),
                              Text("Price : ${Stockdata.pieceperprice[index].toString()} AED"),
                              Text("Near to Expiry : ${Stockdata.nearexpiry[index].toString()}"),
                              Text("Value : ${Stockdata.nearexpiryvalue[index].toString()} AED"),
                              Text("Exposure Quantity : ${Stockdata.exposurequantity[index].toString()}"),
                              Text("Estimated Expiry Value : ${Stockdata.estimateexpiryvalue[index].toString()} AED"),
                              Text("Captured Period : P${Stockdata.period[index]}"),
                              Text("Expiry Period : P${Stockdata.expiryperiod[index] == null ? "3":Stockdata.expiryperiod[index]}"),
                              Text("Remarks : ${Stockdata.remarks[index].toString()}"),
                              Text("Captured By : ${Stockdata.capturedby[index].toString()}"),
                            ],
                          ),
                        ),

                      ),
                    ],
                  ),
                );
              }
          ),
        ),
      ],
    );
  }
}
