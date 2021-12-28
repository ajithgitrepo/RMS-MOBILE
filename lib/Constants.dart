import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/widgets.dart';
import 'main.dart';
import 'api/api_service.dart';
import 'dart:io';
import 'api/FMapi/nbl_detailsapi.dart';
import 'package:flushbar/flushbar.dart';
import 'dart:ui';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:merchandising/offlinedata/syncsendapi.dart';
import 'package:intl/intl.dart';
import 'package:merchandising/offlinedata/sharedprefsdta.dart';
import 'package:merchandising/offlinedata/syncreferenceapi.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:shared_preferences/shared_preferences.dart';
import'package:merchandising/Merchandiser/merchandiserscreens/logs.dart';

List<String> logreportstatus = [];
ValueNotifier<bool> onlinemode = new ValueNotifier(true);
ValueNotifier<int> progress = new ValueNotifier(0);
bool currentlysyncing = false;
List<String> logreport = [];
List<String> logtime = [];
String appversionnumber = "v3.3.3";
String logoutmessage;
createlog(message, status) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  logreport = prefs.getStringList('logdata');
  if (logreport == null) {
    logreport = [];
    logreportstatus = [];
    logtime = [];
  } else {
    logtime = prefs.getStringList('logtime');
    logreportstatus = prefs.getStringList('status');
  }
  print("current length of logs : ${logreport.length}");
  if (logreport.length < 500) {
    logreport.add(message);
    logtime.add(DateFormat.yMd().add_jm().format(DateTime.now()).toString());
    logreportstatus.add("$status");
    await savelogreport(logreport, logtime, logreportstatus);
  } else {
    await smtpExample('automatic >500 Log details for empid ${DBrequestdata.receivedempid}');
    logreport = [];
    logreportstatus = [];
    logtime = [];
    logreport.add("auto clear 500 limit reached");
    logtime.add(DateFormat.yMd().add_jm().format(DateTime.now()).toString());
    logreportstatus.add("true");
    //removelogdatafromlocal();
    // logreport.removeAt(0);
    // logtime.removeAt(0);
    // logreportstatus.removeAt(0);
    logreport.add(message);
    logtime.add(DateFormat.yMd().add_jm().format(DateTime.now()).toString());
    logreportstatus.add(status);
    await savelogreport(logreport, logtime, logreportstatus);
  }
}

String nblfile = Uri.encodeFull(
    "https://rms2.rhapsody.ae/nbl_file/${NBLDetData.fileurl.last}");

//bool onlinemode = true;
//bool alreadycheckedin = false;
final containerscolor = Color(0xffFAECE3);
final alertboxcolor = Colors.white;
final transparentwhite = Colors.white.withOpacity(0.18);
final iconscolor = Color(0xff424B4D);
const grey = Color(0xFFB4B5B9);
const orange = Color(0xFFF58426);
const pink = Color(0xffFEE8DA);

class BackGround extends StatelessWidget {
  BackGround({this.child});
  final child;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFB4B5B9), Color(0xFFF58426)])),
      child: child,
    );
  }
}

String outletid = chekinoutlet.checkinoutletid;

//ignore: must_be_immutable
class OutletDetails extends StatelessWidget {
  String outletid = chekinoutlet.checkinoutletid;
  String outletname = chekinoutlet.checkinoutletname;
  String outletarea = chekinoutlet.checkinarea;
  String outletcity = chekinoutlet.checkincity;
  String outletstate = chekinoutlet.checkinstate;
  String outletcountry = chekinoutlet.checkincountry;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(5.00),
      decoration: BoxDecoration(
          color: pink, borderRadius: BorderRadiusDirectional.circular(10)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 10.0),
            Icon(
              Icons.house_sharp,
              color: iconscolor,
              size: 40,
            ),
            SizedBox(width: 5.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "[$outletid]",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      outletname,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    '$outletarea,$outletcity,$outletstate,$outletcountry',
                  ),
                )
                // AutoSizeText('$outletarea,$outletcity,$outletstate,$outletstate,$outletcountry',
                //   //style: TextStyle(fontSize:15),
                //   maxLines: 1,
                //   minFontSize: 12,
                //   overflow: TextOverflow.ellipsis,
                //   maxFontSize: double.infinity,
                // ),
              ],
            ),
            SizedBox(width: 20.0),
          ],
        ),
      ),
    );
  }
}

class OfflineNotification extends StatefulWidget {
  OfflineNotification({@required this.body});
  final body;
  @override
  _OfflineNotificationState createState() => _OfflineNotificationState();
}

class _OfflineNotificationState extends State<OfflineNotification> {
  @override
  Widget build(BuildContext context) {
    return OfflineBuilder(
      connectivityBuilder: (BuildContext context,
          ConnectivityResult connectivity, Widget child) {
        final bool connected = connectivity != ConnectivityResult.none;
        if (connected) {
          Future.delayed(const Duration(seconds: 1), () {
            onlinemode.value = true;
          });
        } else {
          Future.delayed(const Duration(seconds: 1), () {
            createlog("entered to Offline mode", "true");
            onlinemode.value = false;
          });
        }
        return Stack(
          fit: StackFit.expand,
          children: [
            child,
            onlinemode.value
                ? SizedBox()
                : Positioned(
                    left: 0.0,
                    right: 0.0,
                    height: 32.0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color: connected ? orange : Color(0xFFEE4400),
                      child: connected
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "ONLINE",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "OFFLINE",
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  width: 8.0,
                                ),
                                SizedBox(
                                  width: 12.0,
                                  height: 12.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  )
          ],
        );
      },
      child: widget.body,
    );
  }
}

class Containerblock extends StatelessWidget {
  Containerblock(
      {this.numbertext, this.chartext, this.color, this.icon, this.width});
  final icon;
  final color;
  final numbertext;
  final chartext;
  final width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: width,
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
                icon,
                size: 35,
                color: color,
              ),
              SizedBox(height: 5),
              Text(
                numbertext,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  chartext,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmpInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text(
                '${DBrequestdata.empname}(${DBrequestdata.receivedempid})',
                style: TextStyle(fontSize: 8.0, color: orange),
              ),
              if (currentuser.roleid == 5)
                Text(
                  '-FM$appversionnumber',
                  style: TextStyle(fontSize: 8.0, color: orange),
                )
              else if (currentuser.roleid == 6)
                Text(
                  '-MRCH$appversionnumber',
                  style: TextStyle(fontSize: 8.0, color: orange),
                )
              else if (currentuser.roleid == 3)
                Text(
                  '- HR$appversionnumber',
                  style: TextStyle(fontSize: 8.0, color: orange),
                )
              else if (currentuser.roleid == 2)
                Text(
                  '-CDE$appversionnumber',
                  style: TextStyle(fontSize: 8.0, color: orange),
                )
              else
                Text(
                  '-Client$appversionnumber',
                  style: TextStyle(fontSize: 8.0, color: orange),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

bool regularcheckout = true;
bool rmsdownloadsexists = false;
bool filealreadyexists = false;

class NBlFloatingButton extends StatefulWidget {
  @override
  _NBlFloatingButtonState createState() => _NBlFloatingButtonState();
}

class _NBlFloatingButtonState extends State<NBlFloatingButton> {
  Offset _dragOffset = Offset(0, 0);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _dragOffset.dx + MediaQuery.of(context).size.width / 1.2,
      top: _dragOffset.dy + 40,
      child: Draggable(
        child: Container(
            child: FloatingActionButton(
          heroTag: "btn1",
          onPressed: () async {
            createlog("NBL icon tapped tapped", "true");
            print("nbl file: ${NBLDetData.fileurl.toString()}");
            // if (NBLDetData.fileurl.toString() != "[]") {
            //   print(onlinemode.value);
            //   print("https://rms2.rhapsody.ae/nbl_file/${NBLDetData.fileurl.last}");
            //   print(nblfile);
            //   if (Platform.isAndroid) {
            //     filealreadyexists = await File(
            //         "/storage/emulated/0/Download/${NBLDetData.fileurl.last}")
            //         .exists();
            //     print("already exits : $filealreadyexists");
            //     if (filealreadyexists) {
            //       OpenFile.open("/storage/emulated/0/Download/${NBLDetData.fileurl.last}");
            //     } else {
            //       print("here");
            //       await launch("https://rms2.rhapsody.ae/nbl_file/${NBLDetData.fileurl.last}");
            //     }
            //   } else if (Platform.isIOS) {
            //     _launchURL();
            //   }
            // }else{
              if(onlinemode.value){
                print("online mode");
                print(onlinemode.value);
                // await getNBLdetails();
                if (NBLDetData.fileurl.toString() != "[]") {
                  print("https://rms2.rhapsody.ae/nbl_file/${NBLDetData.fileurl.last}");
                  print(nblfile);
                  if (Platform.isAndroid) {
                    filealreadyexists = await File("/storage/emulated/0/Download/${NBLDetData.fileurl.last}")
                        .exists();
                    if (filealreadyexists) {
                      OpenFile.open("/storage/emulated/0/Download/${NBLDetData.fileurl.last}");
                    } else {
                      print("here");
                      await launch("https://rms2.rhapsody.ae/nbl_file/${NBLDetData.fileurl.last}");
                    }
                  } else if (Platform.isIOS) {
                    _launchURL();
                  }
                } else {
                  Flushbar(
                    message: "Nbl Not Found",
                    duration: Duration(seconds: 3),
                  )..show(context);
                }
              }else if (onlinemode.value==false){
                print("online mode");
                print(onlinemode.value);

                if (NBLDetData.fileurl.toString() != "[]"){
                  if (Platform.isAndroid) {
                    filealreadyexists = await File(
                        "/storage/emulated/0/Download/${NBLDetData.fileurl
                            .last}")
                        .exists();
                    if (filealreadyexists) {
                      OpenFile.open(
                          "/storage/emulated/0/Download/${NBLDetData.fileurl
                              .last}");
                    } else {
                      print("internet required check");
                      Flushbar(
                        message: "Active internet connection is required",
                        duration: Duration(seconds: 3),
                      )
                        ..show(context);
                    }
                  }
                } else if (Platform.isIOS) {
                  _launchURL();
                }

              }
            // }

            },

              child: Text(
            "NBL",
            style: TextStyle(color: pink),
          ),
          backgroundColor: orange,
        )),
        childWhenDragging: Container(
          child: Text(""),
        ),
        feedback: Container(
            child: FloatingActionButton(
          heroTag: "btn2",
          onPressed: () {},
          child: Text(
            "NBL",
            style: TextStyle(color: pink),
          ),
          backgroundColor: orange,
        )),
        onDragEnd: (drag) {
          RenderBox renderBox = context.findRenderObject();
          onDragEnd(renderBox.globalToLocal(drag.offset));
        },
      ),
    );
  }

  void onDragEnd(Offset offset) {
    setState(() {
      _dragOffset += offset;
    });
  }
}

void _launchURL() async => await canLaunch(nblfile)
    ? await launch(nblfile)
    : throw 'Could not launch $nblfile';
bool loaded = false;

adddataforsync(url, body, comment) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  requireurlstosync = prefs.getStringList('addtoserverurl');
  if (requireurlstosync == null) {
    requireurlstosync = [];
    requirebodytosync = [];
    message = [];
    requireurlstosync.add(url);
    requirebodytosync.add(body);
    message.add(comment);
    Adddatatoserver(requireurlstosync, requirebodytosync, message);
  } else {
    requireurlstosync = prefs.getStringList('addtoserverurl');
    requirebodytosync = prefs.getStringList('addtoserverbody');
    message = prefs.getStringList('addtoservermessage');
    requireurlstosync.add(url);
    requirebodytosync.add(body);
    message.add(comment);
    Adddatatoserver(requireurlstosync, requirebodytosync, message);
  }
}
