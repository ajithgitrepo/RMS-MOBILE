import 'package:merchandising/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/Fieldmanager/FMdashboard.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/MenuContent.dart';
import 'package:merchandising/api/FMapi/merchnamelistapi.dart';
import 'package:merchandising/api/HRapi/empdetailsapi.dart';
import 'package:intl/intl.dart';
import 'package:flushbar/flushbar.dart';
import 'package:merchandising/api/HRapi/addingreportapi.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:merchandising/HR/HRdashboard.dart';
import 'package:merchandising/api/FMapi/addcderepapi.dart';
import'package:merchandising/api/FMapi/cdereportapi.dart';
import 'package:intl/intl.dart';

// ignore: camel_case_types
class pickeddate {
  static String startdate;
  static String enddate;
}

// ignore: must_be_immutable, camel_case_types
class Addreportcdescreen extends StatefulWidget {
  @override
  _AddreportcdescreenState createState() => _AddreportcdescreenState();
}

class _AddreportcdescreenState extends State<Addreportcdescreen> {
  String cde;

  String merchandiser;

  String startdate;

  String enddate;

  bool isApiCallProcess = false;
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: pink,
            iconTheme: IconThemeData(color: orange),
            title: Text(
              "Add Report",
              style: TextStyle(color: orange),
            ),
          ),
          drawer: Drawer(
            child: Menu(),
          ),
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
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          print(merchnamelist.firstname);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SearchableDropdown.single(
                            closeButton: SizedBox(),
                            underline: SizedBox(),
                            items: merchnamelist.firstname.map((String val) {
                              return new DropdownMenuItem<String>(
                                value: val,
                                child: new Text(val),
                              );
                            }).toList(),
                            value: merchandiser,
                            hint: "Select Merchandiser",
                            searchHint: "Select Merchandiser",
                            onChanged: (value) {
                              merchandiser = value;
                            },
                            isExpanded: true,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SearchableDropdown.single(
                          closeButton: SizedBox(),
                          underline: SizedBox(),
                          items: employees.cdenames.map((String val) {
                            return new DropdownMenuItem<String>(
                              value: val,
                              child: new Text(val),
                            );
                          }).toList(),
                          value: cde,
                          hint: "Select CDE",
                          searchHint: "Select CDE",
                          onChanged: (value) {
                            cde = value;
                          },
                          isExpanded: true,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: StartDate(),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: EndDate(),
                      ),
                      GestureDetector(
                        onTap: () async{
                          if (merchandiser == null) {
                            Flushbar(
                              message: "please select merchandiser",
                              duration: Duration(seconds: 3),
                            )..show(context);
                          } else if (cde == null) {
                            Flushbar(
                              message: "please select feild manager",
                              duration: Duration(seconds: 3),
                            )..show(context);
                          } else {
                            setState(() {
                              isApiCallProcess = true;
                            });
                            print('RMS${merchandiser.replaceAll(new RegExp(r'[^0-9]'), '')}');
                            print('RMS${cde.replaceAll(new RegExp(r'[^0-9]'), '')}');
                            Addrepcdedata.cdeid = 'RMS${cde.replaceAll(new RegExp(r'[^0-9]'), '')}';
                            Addrepcdedata.merchandiserid = 'RMS${merchandiser.replaceAll(new RegExp(r'[^0-9]'), '')}';
                            Addrepcdedata.startdate = pickeddate.startdate == null
                                ? DateFormat('"yyyy-MM-dd"')
                                .format(DateTime.now())
                                : pickeddate.startdate;
                            Addrepcdedata.enddate = pickeddate.enddate == null
                                ? DateFormat('"yyyy-MM-dd"')
                                .format(DateTime.now())
                                : pickeddate.enddate;
                            await addreportcde();
                            setState(() {
                              isApiCallProcess = true;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext
                                    context) =>
                                        FieldManagerDashBoard()));
                          }
                        },
                        child: Center(
                          child: Container(
                            margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: orange,
                              borderRadius: BorderRadius.circular(10.00),
                            ),
                            child: Text(
                              'Submit Report',
                              style:
                              TextStyle(color: Colors.black, fontSize: 15),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class StartDate extends StatefulWidget {
  @override
  _StartDateState createState() => _StartDateState();
}

class _StartDateState extends State<StartDate> {
  // ignore: non_constant_identifier_names
  DateTime StartDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: StartDate,
      firstDate: DateTime(2015, 8),
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
    if (picked != null && picked != StartDate)
      setState(() {
        StartDate = picked;
        pickeddate.startdate = DateFormat("yyyy-MM-dd").format(StartDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Start Date",
          style: TextStyle(fontSize: 16),
        ),
        Spacer(),
        Text(
          "${StartDate.toLocal()}".split(' ')[0],
          style: TextStyle(fontSize: 16),
        ),
        IconButton(
          icon: Icon(CupertinoIcons.calendar),
          onPressed: () => _selectDate(context),
        ),
      ],
    );
  }
}

class EndDate extends StatefulWidget {
  @override
  _EndDateState createState() => _EndDateState();
}

class _EndDateState extends State<EndDate> {
  // ignore: non_constant_identifier_names
  DateTime EndDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: EndDate,
      firstDate: DateTime(2015, 8),
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
        EndDate = picked;
        pickeddate.enddate = DateFormat("yyyy-MM-dd").format(EndDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            "End Date",
            style: TextStyle(fontSize: 16),
          ),
          Spacer(),
          Text(
            "${EndDate.toLocal()}".split(' ')[0],
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
