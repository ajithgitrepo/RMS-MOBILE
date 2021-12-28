import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/Fieldmanager/FMdashboard.dart';
import 'package:merchandising/login_page.dart';
import 'package:merchandising/offlinedata/sharedprefsdta.dart';
import 'package:merchandising/offlinedata/syncsendapi.dart';
import '../../Constants.dart';
import 'merchandiserdashboard.dart';
import 'myprofile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:merchandising/model/inappupdate.dart';
import 'package:merchandising/feedbackform.dart';
import 'package:merchandising/offlinedata/syncreferenceapi.dart';
import 'package:merchandising/api/api_service.dart';
import 'package:merchandising/model/rememberme.dart';
import 'package:merchandising/main.dart';
import 'package:merchandising/HR/HRdashboard.dart';
import 'package:merchandising/offlinedata/syncdata.dart';
import 'package:merchandising/model/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:merchandising/model/version deailes.dart';
import 'package:merchandising/api/noti_detapi.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/logs.dart';


final menuitemscolor = Colors.black54;
List<bool> changecoloricon = [];
List<Icon> listoficon = [];

class DrawerHeaderinfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            CupertinoIcons.person_circle_fill,
            color: Colors.white,
            size: 50,
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                DBrequestdata.empname,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w300),
              ),
              Text(
                DBrequestdata.receivedempid,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w300),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class MenuElements extends StatelessWidget {
  MenuElements({@required this.title, @required this.icon});
  final title;
  final icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: menuitemscolor,
          size: 25,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          title,
          style: TextStyle(color: menuitemscolor, fontSize: 15),
        )
      ],
    );
  }
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: orange,
          ),
          child: DrawerHeaderinfo(),
        ),
        ListTile(
          title: MenuElements(
            title: 'My Dashboard',
            icon: Icons.dashboard_rounded,
          ),
          onTap: () {
            // createlog("My DashBoard from Menu tapped", "true");
            currentpagestatus('0', '0', '0','0');

            if (currentuser.roleid == 6) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => DashBoard()));
            } else if (currentuser.roleid == 3) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HRdashboard()));
            } else if (currentuser.roleid == 5||currentuser.roleid == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          FieldManagerDashBoard()));
            }

            }

        ),
        ListTile(
          title: MenuElements(
            title: 'My Profile',
            icon: Icons.person,
          ),
          onTap: () {
            // createlog("My Profile from Menu tapped", "true");
            currentpagestatus('0', '0', '0','0');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Myprofile()));
          },
        ),
       currentuser.roleid==6? ListTile(
          title: MenuElements(title: 'Synchronize', icon: Icons.sync_rounded),
          onTap: () async {
            // createlog("Synchronize from Menu tapped", "true");
            currentpagestatus('0', '0', '0','0');
            SharedPreferences prefs = await SharedPreferences.getInstance();
            message = prefs.getStringList('addtoservermessage');


            if (message == null) {
              message = [];
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SyncScreen()));
          },
        ):SizedBox(),
        // ListTile(
        //   title: MenuElements(
        //     title: 'My Customers',
        //     icon: CupertinoIcons.group_solid,
        //   ),
        //   onTap: () async{
        //     await sendemail();
        //   },
        // ),
        ListTile(
          title: MenuElements(
            title: 'Notifications',
            icon: Icons.notifications_on,
          ),
          onTap: () {
            // createlog("Notifications from Menu tapped", "true");
            currentpagestatus('0', '0', '0','0');
            for (int i = 0; i < NotiDetData.title.length; i++) {
              changecoloricon.add(false);
              listoficon.add(Icon(
                Icons.check,
                color: Colors.black54,
              ));
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => NotificationDetails()));
          },
        ),
        ListTile(
          title: MenuElements(
            title: 'Certificates',
            icon: CupertinoIcons.doc_on_doc_fill,
          ),
          onTap: () async{

          },
        ),
        /*  ListTile(
          title: MenuElements(
            title: 'Settings',
            icon: Icons.settings,
          ),
          onTap: () {},
        ), */

        ListTile(
          title: MenuElements(title: 'RMS Version', icon: Icons.info),
          onTap: () {
            // createlog("RMS Version from Menu tapped", "true");
            currentpagestatus('0', '0', '0','0');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => AppVersion()));
          },
        ),
        currentuser.roleid==6?ListTile(
          title: MenuElements(title: 'Logs', icon: Icons.message),
          onTap: () async {
            // createlog("Logs from Menu tapped", "true");
            currentpagestatus('0', '0', '0','0');
            SharedPreferences prefs = await SharedPreferences.getInstance();
            logreport = prefs.getStringList('logdata');
            print("start");
            if (logreport != null) {
              logtime = prefs.getStringList('logtime');
              logreportstatus = prefs.getStringList('status');
              print(logreportstatus.length);
            } else {
              logreport = [];
              logtime = [];
              logreportstatus = [];
            }
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => VLogs()));
          },
        ):SizedBox(),
        // ListTile(
        //   title: MenuElements(title: 'EOD Summary', icon: Icons.dynamic_form),
        //   onTap: () {},
        // ),
        // ListTile(
        //   title: MenuElements(title: 'check for updates', icon: Icons.system_update),
        //   onTap: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (BuildContext context) => MyApp()));
        //   },
        // ),
        // ListTile(
        //   title: MenuElements(title: 'FeedBack', icon: Icons.pending_actions),
        //   onTap: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (BuildContext context) => FeedbackPage(title: "Report Feedback",)));
        //   },
        // ),
        ListTile(
          title: MenuElements(
            title: 'Log Out',
            icon: Icons.logout,
          ),
          onTap: () async {
            if(currentuser.roleid == 6){
              // createlog("Logout from Menu tapped", "true");
              currentpagestatus('0', '0', '0', '0');
              SharedPreferences prefs = await SharedPreferences.getInstance();
              requireurlstosync = prefs.getStringList('addtoserverurl');
              print(requireurlstosync);
              if (requireurlstosync != null) {
                showDialog(
                    context: context,
                    builder: (_) =>
                        StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            backgroundColor: alertboxcolor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                            content: Builder(
                              builder: (context) {
                                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Alert',
                                      style:
                                      TextStyle(color: orange, fontSize: 20),
                                    ),
                                    Divider(
                                      color: Colors.black,
                                      thickness: 0.8,
                                    ),
                                    Text(
                                      "We found some activites that are need to sync please sync it and try again",
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () async {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (
                                                      BuildContext context) =>
                                                      SyncScreen()));
                                        },
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: orange,
                                            borderRadius:
                                            BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                              child: Text('Go to Synchronize',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }));
              } else {
                print(logoutmessage);
                showDialog(
                    context: context,
                    builder: (_) =>
                        StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            backgroundColor: alertboxcolor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                            content: Builder(
                              builder: (context) {
                                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Note',
                                      style:
                                      TextStyle(color: orange, fontSize: 20),
                                    ),
                                    Divider(
                                      color: Colors.black,
                                      thickness: 0.8,
                                    ),
                                    Text(
                                      logoutmessage == null
                                          ? "App Don't track you, it will only track when user had active check in."
                                          : logoutmessage,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () async {
                                          removeValues();
                                          logout();
                                          chackdata();
                                          loggedin.email = null;
                                          loggedin.password = null;
                                          currentuser.roleid = null;
                                          remembereddata.email = null;
                                          remembereddata.password = null;
                                          DBrequestdata.empname = null;
                                          DBrequestdata.emailid = null;
                                          currentuser.roleid = null;
                                          SharedPreferences prefs = await SharedPreferences
                                              .getInstance();
                                          await prefs.clear();
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (
                                                      BuildContext context) =>
                                                      LoginPage()));
                                        },
                                        child: Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: orange,
                                            borderRadius:
                                            BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                              child: Text('Proceed to Logout',
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }));
              }
            }else{
              loggedin.email = null;
              loggedin.password = null;
              currentuser.roleid = null;
              remembereddata.email = null;
              remembereddata.password = null;
              DBrequestdata.empname = null;
              DBrequestdata.emailid = null;
              currentuser.roleid = null;
              SharedPreferences prefs = await SharedPreferences
                  .getInstance();
              await prefs.clear();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (
                          BuildContext context) =>
                          LoginPage()));
            }
          }
        ),

        /*Image(
          image: AssetImage('images/ttflogo.png'),
          height:40,
        ),*/
      ],
    );
  }
}
