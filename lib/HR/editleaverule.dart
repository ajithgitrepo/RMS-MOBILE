import 'package:flutter/painting.dart';
import 'package:merchandising/Constants.dart';
import 'package:flutter/material.dart';
import 'package:merchandising/HR/HRdashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/MenuContent.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:merchandising/api/leaverules.dart';
import 'package:merchandising/HR/leaverules.dart';
import 'package:merchandising/api/HRapi/leaveruleupdate.dart';
import 'package:merchandising/ProgressHUD.dart';




class EditLeaveRules extends StatefulWidget {

  @override
  _EditLeaveRulesState createState() => _EditLeaveRulesState();
}

bool isApiCallProcess = false;


class _EditLeaveRulesState extends State<EditLeaveRules> {


  TextEditingController leavetype = TextEditingController(text:leaverules.leavetype[selectindexofleaverule].toString());
  TextEditingController totaldays = TextEditingController(text:leaverules.total_days_count[selectindexofleaverule].toString());
  TextEditingController remarks = TextEditingController(text:leaverules.remarks[selectindexofleaverule].toString());






  @override
  Widget build(BuildContext context) {



    return MaterialApp(



        home: ProgressHUD(
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: pink,
          iconTheme: IconThemeData(color: orange),
          title: Text("Leave Rules Update",style: TextStyle(color: orange),),
        ),
        drawer: Drawer(
          child: Menu(),
        ),
        body: Stack(
          children: [
            BackGround(),
            Container(
              height: MediaQuery.of(context).size.height/1.9,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color:Color(0xffFEE8DA),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(

                    margin:EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10.0)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Text("Leave Type : ",
                          style: TextStyle(fontSize: 16),
                          ),
                        ),
                       // SizedBox(width: 10),
                        Center(child: Text("${leaverules.leavetype[selectindexofleaverule]} ",style: TextStyle(fontSize: 16),)),
                      ],
                    ),
                  ),



                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Total Days Count"),
                  ),

                  Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.only(left:15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),

                    child: TextFormField(
                      controller:totaldays,
                      cursorColor: grey,

                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusColor: orange,
                        hintText: "days count",
                        hintStyle: TextStyle(
                          color: grey,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),



                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Remarks"),
                  ),


                  Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.only(left:15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller:remarks,
                      cursorColor: grey,

                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        focusColor: orange,
                        hintText: "remarks",
                        hintStyle: TextStyle(
                          color: grey,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),


                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: ()async{
                          updateleaverule.leaveid = leaverules.leaveid[selectindexofleaverule];
                          updateleaverule.totaldays= totaldays.text;
                          updateleaverule.remarks=remarks.text;

                          await leaveruleupdate();


                          setState(() {
                            isApiCallProcess=true;
                          });

                           await leaverulesdata1();

                          LeaveRules();

                           setState(() {

                             isApiCallProcess=false;


                           });


                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (BuildContext context) => LeaveRules()));

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Updated successfully!'),
                            ),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width/3.0,
                          padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.orange[500]),
                            child: Center(child: Text('Update'))),
                      ),
                    ),
                  ),

                ],

              ),
            ),



          ],
        ),
      ),
        )
    );

  }






}
