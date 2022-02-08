import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:merchandising/Fieldmanager/FMdashboard.dart';
import 'package:merchandising/main.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:merchandising/Constants.dart';
import 'package:merchandising/api/FMapi/merchnamelistapi.dart';
import '../Constants.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import'package:merchandising/api/FMapi/leave_reportapi.dart';
import 'package:flushbar/flushbar.dart';
import'package:merchandising/api/leavestakenapi.dart';


class LeaveReporting extends StatefulWidget {
  Function onsubmit;
  LeaveReporting({@required this.onsubmit});
  @override
  _LeaveReportingState createState() => _LeaveReportingState();
}
List merchandisers = merchnamelist.firstname.map((String val) {
  return new DropdownMenuItem<String>(
    value: val,
    child: new Text(val),
  );
}).toList();
List merchundercde = MerchUnderCDE.firstname.map((String val) {
  return new DropdownMenuItem<String>(
    value: val,
    child: new Text(val),
  );
}).toList();
String selectedmerchandiser;
String selectmerchundercde;
String Res_Emp;
List<int> selectedoutlets;
class _LeaveReportingState extends State<LeaveReporting> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15, bottom: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: SearchableDropdown.single(
                  underline: SizedBox(),
                  iconEnabledColor: orange,
                  items: currentuser.roleid == 5?merchandisers:merchundercde,
                  value: currentuser.roleid == 5
                      ? selectedmerchandiser
                      : selectmerchundercde,
                  hint: "Select Merchandiser",
                  searchHint: "Select Merchandiser",
                  onChanged: (value) {
                    print("OnChanged ----->  ${value}");
                    if (currentuser.roleid == 5) {
                      selectedmerchandiser = value;
                    } else {
                      selectmerchundercde = value;
                    }
                  },
                  isExpanded: true,
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 10.0),
                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                    underline: SizedBox(),
                    isExpanded: true,
                    iconEnabledColor: orange,
                    elevation: 20,
                    dropdownColor: Colors.white,
                    items: Reasons.map((String val) {
                      return new DropdownMenuItem<String>(
                        value: val,
                        child: new Text(val),
                      );
                    }).toList(),
                    hint: Text("Choose Reason"),
                    value: selectedReason,
                    onChanged: (newVal) {
                      selectedReason = newVal;
                      if (selectedReason == "others") {
                        setState(() {
                          displayothers = true;
                        });
                      } else {
                        setState(() {
                          displayothers = false;
                        });
                      }
                    }),
              ),
              !displayothers
                  ? SizedBox()
                  : Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        maxLines: 3,
                        keyboardType: TextInputType.text,
                        controller: others,
                        cursorColor: grey,
                        decoration: new InputDecoration(
                          //contentPadding: ,
                          isCollapsed: true,
                          border: InputBorder.none,
                          focusColor: orange,
                          hintText: "Type Reason here*",
                          hintStyle: TextStyle(
                            color: grey,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
              selectedReason=="Sick Leave"?Container(
                margin: EdgeInsets.only(bottom: 10.0),
                padding: EdgeInsets.fromLTRB(10.0,0,18,10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text(
                          "Documents",
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () async{
                            FilePickerResult picked = await getFile();
                            if(picked != null){
                              File file = File(picked.files.single.path);
                              var imagebytes = base64Encode(file.readAsBytesSync());
                              base64doc = "data:image/jpg;base64,$imagebytes";
                            }
                          },
                          child: Icon(CupertinoIcons.folder_badge_plus),
                        )
                      ],
                    ),
                    _file != null ?
                    Text(Filepickedname)
                        :SizedBox()
                  ],
                ),
              ):SizedBox(),
              // Container(
              //   margin: EdgeInsets.only(bottom: 10.0),
              //   padding: EdgeInsets.only(left: 8.0, right: 8.0),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: Row(
              //     children: [
              //       Text(
              //         "Select Dates",
              //         style: TextStyle(fontSize: 16),
              //       ),
              //       Spacer(),
              //       Text(
              //         Selecteddate != null
              //             ? Selecteddate
              //             : "",
              //         style: TextStyle(fontSize: 16),
              //       ),
              //       IconButton(
              //         icon: Icon(CupertinoIcons.calendar,color: showdatepicker ? orange:Colors.black,),
              //         onPressed: () {
              //           setState(() {
              //             showdatepicker = !showdatepicker;
              //           });
              //           //_selectDate(context);
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              //
              // showdatepicker ? Container(
              //   margin: EdgeInsets.only(bottom: 10.0),
              //   padding: EdgeInsets.only(left: 8.0, right: 8.0),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   child: SfDateRangePicker(
              //     view: DateRangePickerView.month,
              //     selectionMode: DateRangePickerSelectionMode.range,
              //     monthViewSettings:
              //     DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
              //     onSelectionChanged: _onSelectionChanged,
              //   ),
              // ):SizedBox(),
              StartDate(),
              EndDate(),

              Container(
                margin: EdgeInsets.only(top:10.0),
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextFormField(
                  maxLines: 3,
                  keyboardType: TextInputType.text,
                  controller: remarks,
                  cursorColor: grey,
                  decoration: new InputDecoration(
                    //contentPadding: ,
                    isCollapsed: true,
                    border: InputBorder.none,
                    focusColor: orange,
                    hintText: "Remarks*",
                    hintStyle: TextStyle(
                      color: grey,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () async {
                    if (currentuser.roleid == 5 && selectedmerchandiser == null) {
                      Flushbar(
                        message: "Please Choose Merchandiser.",
                        duration: Duration(seconds: 3),
                      )..show(context);
                    } else if (currentuser.roleid == 2 &&
                        selectmerchundercde == null) {
                      Flushbar(
                        message: "Please Choose Merchandiser.",
                        duration: Duration(seconds: 3),
                      )..show(context);
                    }
                    // else if (Selecteddate == null) {
                    //   Flushbar(
                    //     message: "Please Choose Date.",
                    //     duration: Duration(seconds: 3),
                    //   )..show(context);
                    // }
                    else if (selectedReason == null) {
                      Flushbar(
                        message: "Please Choose Reason.",
                        duration: Duration(seconds: 3),
                      )..show(context);
                    } else if (selectedReason == "others" && others.text.isEmpty) {
                      Flushbar(
                        message: "Reason cannot be Empty.",
                        duration: Duration(seconds: 3),
                      )..show(context);
                    } else {
                     // print(selectedmerchandiser + "ponn");
                      Res_Emp ="";
                      if (currentuser.roleid == 5) {
                        final  names = selectedmerchandiser;
                      } else {
                        final  names = selectmerchundercde;
                      }
                      final  names = selectedmerchandiser;
                      var parts = names.split('(');
                      var prefix = "";
                      if(parts != null)
                        prefix = parts[1].trim();

                      if (prefix != null && prefix.length > 0) {
                        Res_Emp = prefix.substring(0, prefix.length - 1);
                      }
                      leaverequestdata.empid= Res_Emp;   //currentuser.roleid==5?'Emp${selectedmerchandiser.replaceAll(new RegExp(r'[^0-9]'), '')}':'Emp${selectmerchundercde.replaceAll(new RegExp(r'[^0-9]'), '')}';;
                      leaverequestdata.type=selectedReason;
                      leaverequestdata.startdate=startdate.toLocal().toString().substring(0,10);
                      leaverequestdata.enddate = ENDdate.toLocal().toString().substring(0,10);
                      leaverequestdata.reason = remarks.text;
                      leaverequestdata.image = base64doc;

                     // print(leaverequestdata + 'pon');

                      await leaverequestwithtype();
                      // widget.onsubmit();

                      Flushbar(
                        message: "Leave Report has been submitted",
                        duration: Duration(seconds:3),
                      )..show(context);

                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    FieldManagerDashBoard()));
                      });

                    }
                  },
                  style:
                      ButtonStyle(backgroundColor: MaterialStateProperty.all(pink)),
                  child: Text(
                    "Submit",
                    style: TextStyle(color: orange),
                  ))


            ],
          ),
        ),
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // TODO: implement your code here
    if(args.value.toString().length ==72) {
      startDate = args.value.toString().substring(33, 43);
      endDate = null;
      setState(() {
        Selecteddate = startDate;
      });
    }else{
      Map data = {
        "startDate" : "${args.value.toString().substring(33,43)}",
        "endDate":"${args.value.toString().substring(67, 77)}"
      };
      var selecteddaterange = jsonEncode(data);
      startDate = jsonDecode(selecteddaterange)["startDate"];
      endDate = jsonDecode(selecteddaterange)["endDate"];
      setState(() {
        Selecteddate = "$startDate - $endDate";
      });
    }
  }
  FilePickerResult _file;
  Future getFile()async{
    FilePickerResult file = await FilePicker.platform.pickFiles();
    setState(() {
      _file = file;
      Filepickedname = file.names.toString();
    });
    return _file;
  }
  List<String> Reasons = [ "Week_off","Comp_off","Annual_Leave","Public_holiday","Sick_Leave"];
  DateTime tomoroww = DateTime.now().add(Duration(days: 1));
  DateTime StratDate = DateTime.now().subtract(
      Duration(days: int.parse(DateFormat('dd').format(DateTime.now())) - 1));
  var date = new DateTime(int.parse(DateFormat('yyyy').format(DateTime.now())),
      int.parse(DateFormat('MM').format(DateTime.now())) + 1, 0);
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate:
          DateTime(int.parse(DateFormat('yyyy').format(DateTime.now())) - 10),
      lastDate:
          DateTime(int.parse(DateFormat('yyyy').format(DateTime.now())) + 10),
      helpText: "Note *You can select only for current month*",
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: orange,
              onPrimary: Colors.white,
              surface: orange,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.grey[100],
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != Selecteddate) {
      setState(() {
        Selecteddate = picked;
      });
    }
  }
}
String startDate;
String endDate;
String selectedReason;
String base64doc;
String Filepickedname;
bool showdatepicker= false;
bool displayothers = false;
var Selecteddate;
var others = new TextEditingController();
var remarks = new TextEditingController();






class StartDate extends StatefulWidget {
  @override
  _StartDateState createState() => _StartDateState();
}
DateTime tomoroww = DateTime.now().subtract(Duration(days: 30));
DateTime startdate = DateTime.now().subtract(Duration(days: 30));

class _StartDateState extends State<StartDate> {
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: tomoroww,
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: orange,
              onPrimary: Colors.white,
              surface: orange,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.grey[100],
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != startdate)
      setState(() {
        startdate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        children: [
          Text(
            "Start Date",
            style: TextStyle(fontSize: 16),
          ),
          Spacer(),
          Text(
            "${startdate.toLocal()}".split(' ')[0],
            style: TextStyle(fontSize: 16),
          ),
          IconButton(
            icon: Icon(CupertinoIcons.calendar),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
    );
  }
}



DateTime tomorow = DateTime.now().subtract(Duration(days: 30));

DateTime ENDdate = DateTime.now().subtract(Duration(days: 30));
class EndDate extends StatefulWidget {
  @override
  _EndDateState createState() => _EndDateState();
}

class _EndDateState extends State<EndDate> {

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: tomorow,
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.light(
              primary: orange,
              onPrimary: Colors.white,
              surface: orange,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.grey[100],
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != EndDate)
      setState(() {
        ENDdate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        children: [
          Text(
            "End Date",
            style: TextStyle(fontSize: 16),
          ),
          Spacer(),
          Text(
            "${ENDdate.toLocal()}".split(' ')[0],
            style: TextStyle(fontSize: 16),
          ),
          IconButton(
            icon: Icon(CupertinoIcons.calendar),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
    );
  }
}