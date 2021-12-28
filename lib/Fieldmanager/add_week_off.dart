import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/Constants.dart';
import 'package:merchandising/Fieldmanager/FMdashboard.dart';
import 'package:merchandising/HR/HRdashboard.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/MenuContent.dart';
import 'package:merchandising/api/FMapi/add_brandapi.dart';
import 'package:merchandising/api/FMapi/merchnamelistapi.dart';
import'package:merchandising/api/FMapi/add_weekoff_api.dart';
import 'package:merchandising/api/FMapi/week_off_detailsapi.dart';
import 'package:merchandising/main.dart';


class AddWeekOff extends StatefulWidget {
  @override
  _AddWeekOffState createState() => _AddWeekOffState();
}

class _AddWeekOffState extends State<AddWeekOff> {

  // ignore: non_constant_identifier_names
  //String brands;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: containerscolor,
            iconTheme: IconThemeData(color: orange),
            title: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Week Off',
                      style: TextStyle(color: orange),
                    ),
                    EmpInfo()
                  ],
                ),
              ],
            ),
          ),
          // drawer: Drawer(
          //   child: Menu(),
          // ),
          body: Stack(
            children: [
              BackGround(),
              SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: pink,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectMerch(),
                        SizedBox(height:10),
                        SelectMonth(),
                        SelectDay(),
                        SelectYear(),
                        Center(
                          child: GestureDetector(
                            onTap: () async{
                              Addweekoff.empid  = 'RMS${dropdownmerch.replaceAll(new RegExp(r'[^0-9]'), '')}';
                              Addweekoff.month = dropdownmonth;
                              Addweekoff.day = dropdowndays;
                              Addweekoff.year = dropdownyear;

                              await addweekoff();
                              await getWeekoffdetails();
                              {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            FieldManagerDashBoard()));
                              }


                              },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10, top: 10),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text('ADD'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          )),
    );
  }
}


String dropdownmerch;
class SelectMerch extends StatefulWidget {
  @override
  _SelectMerchState createState() => _SelectMerchState();
}

class _SelectMerchState extends State<SelectMerch> {

  static List DropDownItems  = currentuser.roleid == 5?merchnamelist.firstname.map((String val) {return new DropdownMenuItem<String>(value: val, child: new Text(val),);}).toList():MerchUnderCDE.firstname.map((String val) {return new DropdownMenuItem<String>(value: val, child: new Text(val),);}).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:10.0),
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10.0)),
      child: DropdownButton(
        elevation: 0,
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: Container(color: Colors.transparent),
        iconEnabledColor: orange,
        iconSize: 35.0,
        value: dropdownmerch,
        onChanged: (newVal){
          setState(() {
            dropdownmerch = newVal;
          });
        },
        items: DropDownItems,
        hint: Text("Select Merchandiser",style: TextStyle(color: Colors.grey),),
      ),
    );
  }
}


String dropdownmonth;
class SelectMonth extends StatefulWidget {
  @override
  _SelectMonthState createState() => _SelectMonthState();
}

class _SelectMonthState extends State<SelectMonth> {

  static List DropDownItems  = ["January","February","March","April","May","June","July",
  "August","September","October","November","December"].map((String val) {return new DropdownMenuItem<String>(value: val, child: new Text(val),);}).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10.0)),
      child: DropdownButton(
        elevation: 0,
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: Container(color: Colors.transparent),
        iconEnabledColor: orange,
        iconSize: 35.0,
        value: dropdownmonth,
        onChanged: (newVal){
          setState(() {
            dropdownmonth = newVal;
          });
        },
        items: DropDownItems,
        hint: Text("Select Month",style: TextStyle(color: Colors.grey),),
      ),
    );
  }
}

String dropdowndays;
class SelectDay extends StatefulWidget {
  @override
  _SelectDayState createState() => _SelectDayState();
}

class _SelectDayState extends State<SelectDay> {

  static List DropDownItems  = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"].map((String val) {return new DropdownMenuItem<String>(value: val, child: new Text(val),);}).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:10.0),
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10.0)),
      child: DropdownButton(
        elevation: 0,
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: Container(color: Colors.transparent),
        iconEnabledColor: orange,
        iconSize: 35.0,
        value: dropdowndays,
        onChanged: (newVal){
          setState(() {
            dropdowndays = newVal;
          });
        },
        items: DropDownItems,
        hint: Text("Select Day",style: TextStyle(color: Colors.grey),),
      ),
    );
  }
}

String dropdownyear;
class SelectYear extends StatefulWidget {
  @override
  _SelectYearState createState() => _SelectYearState();
}

class _SelectYearState extends State<SelectYear> {

  static List DropDownItems  = ["2021","2022","2023","2024","2025"].map((String val) {return new DropdownMenuItem<String>(value: val, child: new Text(val),);}).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:10.0),
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10.0)),
      child: DropdownButton(
        elevation: 0,
        dropdownColor: Colors.white,
        isExpanded: true,
        underline: Container(color: Colors.transparent),
        iconEnabledColor: orange,
        iconSize: 35.0,
        value: dropdownyear,
        onChanged: (newVal){
          setState(() {
            dropdownyear = newVal;
          });
        },
        items: DropDownItems,
        hint: Text("Select Year",style: TextStyle(color: Colors.grey),),
      ),
    );
  }
}













