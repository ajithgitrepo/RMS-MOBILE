import 'package:merchandising/Constants.dart';
import 'package:flutter/material.dart';
import 'package:merchandising/HR/HRdashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/MenuContent.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:merchandising/api/leaverules.dart';
import 'package:merchandising/HR/editleaverule.dart';




int selectindexofleaverule;
class LeaveRules extends StatefulWidget {
  @override
  _LeaveRulesState createState() => _LeaveRulesState();
}

class _LeaveRulesState extends State<LeaveRules> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: pink,
        iconTheme: IconThemeData(color: orange),
        title: Text("Leave Rules",style: TextStyle(color: orange),),
      ),
      drawer: Drawer(
        child: Menu(),
      ),
      body: Stack(
        children: [
          BackGround(),


          ListView.builder(
              itemCount:leaverules.remarks.length,
              itemBuilder: (BuildContext context, int index) {
                //selectindexofleaverule = index;
                return Container(
                  margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  width: MediaQuery.of(context).size.width,
                  child:Row(

                    children: [
                      Container(
                        width:MediaQuery.of(context).size.width/1.4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [



                            Row(
                              children: [
                                Text(
                                  'Leave Type :',
                                  style: TextStyle(
                                      fontSize: 15.0, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                AutoSizeText(
                                  '${leaverules.leavetype[index]}',
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 15.0, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text('Total Days Count :',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('${leaverules.total_days_count[index]}',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    )),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text('Remarks :',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('${leaverules.remarks[index]}',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Container(
                        child: Column(
                          children:[
                            GestureDetector(
                              onTap: (){

                                selectindexofleaverule=index;
                                print(selectindexofleaverule);


                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (BuildContext context) => EditLeaveRules()));
                              },
                              child: Container(
                                  height:30,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.all(Radius.circular(10))),
                                  child: Center(child: Text("EDIT"))),
                            ),
                          ],

                        ),
                      ),
                    ],
                  ),

                );
              }
          ),

        ],
      ),
    );
  }
}








