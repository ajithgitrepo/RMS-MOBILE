import 'package:merchandising/Constants.dart';
 import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/MenuContent.dart';
import 'package:merchandising/api/FMapi/merchnamelistapi.dart';
//import 'file:///C:/Users/ramkumar/StudioProjects/RHAPSODY-MERCHANDISING-SERVICES/lib/model/chatscreen.dart';
import'package:merchandising/model/chatscreen.dart';
import 'package:merchandising/api/api_service.dart';
import 'allEmployeechatscreen.dart';
// import 'package:merchandising/model/goupchatscreen.dart';
class ChatUsersformerch extends StatefulWidget {
  @override
  _ChatUsersformerchState createState() => _ChatUsersformerchState();
}

class _ChatUsersformerchState extends State<ChatUsersformerch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pink,
        iconTheme: IconThemeData(color: orange),
        title: Center(
          child: Column(
            children: [
              Text("HQ Communication",style: TextStyle(color: orange),),
              EmpInfo()
            ],
          ),
        ),
      ),
      // drawer: Drawer(
      //   child: Menu(),
      // ),
      body: Stack(
        children: [
          BackGround(),
          Column(
            children: [
              SizedBox(height: 10.0,),
              GestureDetector(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        // ignore: non_constant_identifier_names
                          builder: (BuildContextcontext) => AllChatScreen()));
                },
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.fromLTRB(10.0,0,10,10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rhapsody Merchandising Services',
                            style: TextStyle(
                                fontSize: 16.0,color: orange
                            )),
                        SizedBox(height: 5 ,),
                        Text('participants : All',
                            style: TextStyle(
                                fontSize: 14.0,color: grey
                            )),
                      ],
                    )),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    ischatscreen =1;
                    newmsgavaiable = false;
                    chat.receiver = fieldmanagerofcurrentmerch;
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatScreen()));
                },
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.fromLTRB(10.0,0,10,10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Field Manager',
                            style: TextStyle(
                                fontSize: 16.0,color: orange
                            )),
                        SizedBox(height: 5 ,),
                        Text('participants : $fieldmanagernameofcurrentmerch',
                            style: TextStyle(
                                fontSize: 14.0,color: grey
                            )),
                      ],
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


