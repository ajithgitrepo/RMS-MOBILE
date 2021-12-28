import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:merchandising/Constants.dart';
import 'package:merchandising/api/FMapi/merchnamelistapi.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:merchandising/Fieldmanager/FMdashboard.dart';
import'package:merchandising/api/FMapi/outletapi.dart';
import 'package:merchandising/api/FMapi/addjourneyplan.dart';
import 'package:intl/intl.dart';
import 'package:merchandising/api/Journeyplansapi/todayplan/journeyplanapi.dart';
import 'package:merchandising/api/Journeyplansapi/weekly/jpplanned.dart';
import 'package:merchandising/api/api_service.dart';

import 'package:merchandising/Merchandiser/merchandiserscreens/weeklyjpwidgets/weeklyjp.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:merchandising/Fieldmanager/add_week_off.dart';
import 'package:merchandising/api/FMapi/week_off_detailsapi.dart';
import 'fmmapwidget.dart';
import'package:merchandising/api/timesheetapi.dart';
import'package:merchandising/Merchandiser/merchandiserscreens/Customers Activities.dart';
import'package:merchandising/api/avaiablityapi.dart';
import 'package:merchandising/api/customer_activites_api/visibilityapi.dart';
import 'package:merchandising/api/customer_activites_api/promotion_detailsapi.dart';
import'package:merchandising/api/customer_activites_api/planogramdetailsapi.dart';
import'package:merchandising/api/customer_activites_api/share_of_shelf_detailsapi.dart';
import'package:merchandising/api/customer_activites_api/Competitioncheckapi.dart';
import 'package:flutter/material.dart';
import 'package:merchandising/api/api_service.dart';
import 'package:merchandising/main.dart';
import '../Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:merchandising/api/Journeyplansapi/weekly/jpplanned.dart';
import 'package:merchandising/api/FMapi/timesheetdelete.dart';
import 'package:merchandising/Fieldmanager/addoutlets.dart';
import 'package:merchandising/api/customer_activites_api/planogramdetailsapi.dart';
import 'package:merchandising/api/avaiablityapi.dart';
import 'package:merchandising/Constants.dart';
import 'package:merchandising/Fieldmanager/fmcustomeractivites.dart';
import 'package:merchandising/api/customer_activites_api/Competitioncheckapi.dart';
import 'package:merchandising/api/customer_activites_api/visibilityapi.dart';
import 'package:merchandising/api/customer_activites_api/share_of_shelf_detailsapi.dart';
import'package:merchandising/api/customer_activites_api/competition_details.dart';
import'package:merchandising/api/customer_activites_api/promotion_detailsapi.dart';
import 'package:merchandising/Fieldmanager/addjp.dart';
import 'package:merchandising/clients/reports.dart';
import 'package:merchandising/api/clientapi/stockexpirydetailes.dart';
import 'package:merchandising/api/clientapi/clientpromodetailes.dart';

var selectedweekoff;
List outlets = outletdata.outletname.map((String val) {return new DropdownMenuItem<String>(value: val, child: new Text(val),);}).toList();
bool isApiCallProcess = false;
bool sundaytapped = false;
bool mondaytapped = false;
bool tuesdaytapped = false;
bool wednesdaytapped = false;
bool thursdaytapped = false;
bool fridaytapped = false;
bool saturdaytapped = false;
class AddJourneyPlan extends StatefulWidget {
  @override
  _AddJourneyPlanState createState() => _AddJourneyPlanState();
}
class _AddJourneyPlanState extends State<AddJourneyPlan> {
  List merchandisers = merchnamelist.firstname.map((String val) {return new DropdownMenuItem<String>(value: val, child: new Text(val),);}).toList();
  List merchundercde = MerchUnderCDE.firstname.map((String val) {return new DropdownMenuItem<String>(value: val, child: new Text(val),);}).toList();
  String selectedmerchandiser;
  String selectmerchundercde;
  List <int>selectedoutlets;
  bool pressschdlue = false;
  bool pressunschdle = true;
  bool isApiCallProcess = false;

  var _searchview = new TextEditingController();
  bool _firstSearch = true;
  String _query = "";
  List<dynamic> inputlist;
  List<int> _filterList;

  @override
  void initState() {
    super.initState();
    inputlist =  currentuser.roleid==5?merchnamelist.firstname:MerchUnderCDE.firstname;
  }

  _AddJourneyPlanState() {

    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {

        setState(() {
          _firstSearch = true;
          _query = "";
        });
      } else {
        setState(() {
          _firstSearch = false;
          _query = _searchview.text;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        child:Scaffold(
          appBar: AppBar(
            backgroundColor: pink,
            iconTheme: IconThemeData(color: orange),
            title: Column(
              children: [
                Text("Journey Plan",style: TextStyle(color: orange),),
                EmpInfo()
              ],
            ),
          ),

          body: Stack(
            children: [
              BackGround(),
              DefaultTabController(
                length: 2, // lengt0h of tabs
                initialIndex: 0,
                child:Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(kToolbarHeight),
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10,10,10,0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                      ),
                      child: TabBar(
                        //    controller: _controller,
                        labelColor: orange,
                        unselectedLabelColor: Colors.black,
                        indicatorColor: orange,
                        tabs: [
                          Tab(text: 'Journey Plan Details'),
                          Tab(text: 'Add Journey Plan'),
                        ],
                      ),
                    ),
                  ),
                  body: TabBarView(
                      children: [

                        Container(
                          margin: EdgeInsets.fromLTRB(10.0,10,10,0),
                          child: new Column(
                            children: <Widget>[
                              _createSearchView(),
                              SizedBox(height: 10.0,),
                              _firstSearch ? _createListView() : _performSearch(),
                            ],
                          ),
                        ),

                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: pink,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              pressschdlue = true;
                                              pressunschdle = false;
                                            });
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 120,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    'Scheduled',
                                                    style: TextStyle(
                                                      color: pressschdlue == true
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
                                              color: pressschdlue == true
                                                  ? orange
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              pressunschdle = true;
                                              pressschdlue = false;
                                            });
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 120,
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    'Unscheduled',
                                                    style: TextStyle(
                                                      color: pressunschdle == false
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
                                              color: pressunschdle == true
                                                  ? orange
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Container(
                                      margin: EdgeInsets.only(top: 5,bottom: 5),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SearchableDropdown.single(

                                        underline: SizedBox(),
                                        items: currentuser.roleid==5?merchandisers:merchundercde,
                                        value: currentuser.roleid==5?selectedmerchandiser:selectmerchundercde,
                                        hint: "Select Merchandiser",
                                        searchHint: "Select Merchandiser",
                                        onChanged: (value) {
                                          setState(() {
                                            selectedweekoff = null;
                                            currentuser.roleid==5?selectedmerchandiser = value:selectmerchundercde=value;
                                            int id = currentuser.roleid==5?int.parse(selectedmerchandiser.replaceAll(RegExp('[^0-9]'), '')):int.parse(selectmerchundercde.replaceAll(RegExp('[^0-9]'), ''));
                                            print(id);
                                            print(Weekoff.empid.length);
                                            var empid;
                                            if(id.toString().length == 2){
                                              empid = "RMS00$id";
                                            }else{
                                              empid = "RMS0$id";
                                            }
                                            for(int i=0;i<Weekoff.empid.length;i++){
                                              if(empid ==Weekoff.empid[i]){
                                                // print('idmatched');
                                                //print('year : ${DateFormat("y").format(DateTime.now())}');
                                                // ignore: unrelated_type_equality_checks
                                                if(DateFormat("y").format(DateTime.now()) == Weekoff.year[i]){
                                                  //   print('yearmatched');
                                                  //  print(DateFormat.MMMM().format(DateTime.now()));
                                                  if(DateFormat.MMMM().format(DateTime.now()) == Weekoff.month[i]){
                                                    selectedweekoff = Weekoff.day[i];
                                                  }
                                                }
                                              }
                                            }
                                          });
                                        },
                                        isExpanded: true,
                                      ),
                                    ),
                                    selectedweekoff != null ? Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Week Off : $selectedweekoff ",style: TextStyle(color: orange),),
                                        ),
                                        Spacer(),
                                      ],
                                    ):SizedBox(),
                                    Container(
                                      margin: EdgeInsets.only(top: 5,bottom: 5),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: SearchableDropdown.multiple(
                                        underline: SizedBox(),
                                        items: outlets,
                                        selectedItems: selectedoutlets,
                                        hint: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text("Select Outlets"),
                                        ),
                                        searchHint: "Select Outlets",
                                        onChanged: (value) {
                                          setState(() {
                                            selectedoutlets = value;
                                            print(selectedoutlets);
                                          });
                                        },
                                        closeButton: (selectedItems) {
                                          return (selectedItems.isNotEmpty
                                              ? "Save ${selectedItems.length == 1 ? '"' + outlets[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
                                              : "Save without selection");
                                        },
                                        isExpanded: true,
                                      ),
                                    ),
                                    pressschdlue == true ? schedulejp() :Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.only(top: 5.0),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: StartDate(),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: GestureDetector(
                                          onTap: () async{
                                            print(pressschdlue);
                                            addunschdulejp.outletid=[];
                                            addschdulejp.outletid=[];
                                            addschdulejp.days = [];
                                            if(pressschdlue == true){
                                              if(selectedoutlets != null &&  currentuser.roleid==5?selectedmerchandiser != null:selectmerchundercde!=null && selectedmonth != null && selectedweekday != null){
                                                for(int u=0;u<selectedoutlets.length;u++){
                                                  addunschdulejp.outletid.add(outletdata.outletid[selectedoutlets[u]]);
                                                  addschdulejp.outletid.add(outletdata.outletid[selectedoutlets[u]]);
                                                }

                                                if(currentuser.roleid==5){
                                                for(int u=0;u<merchnamelist.firstname.length;u++){
                                                  if (merchnamelist.firstname[u] == selectedmerchandiser) {
                                                    addunschdulejp.empid = merchnamelist.employeeid[u];
                                                    addschdulejp.empid = merchnamelist.employeeid[u];
                                                  }}}

                                                else{
                                                  for(int u=0;u<MerchUnderCDE.firstname.length;u++){
                                                    if (MerchUnderCDE.firstname[u] == selectedmerchandiser) {
                                                      addunschdulejp.empid = MerchUnderCDE.employeeid[u];
                                                      addschdulejp.empid = MerchUnderCDE.employeeid[u];
                                                    }}


                                                }
                                                for(int u=0;u<months.length;u++){
                                                  if (months[u] == selectedmonth) {
                                                    addschdulejp.month = u+1;
                                                  }}
                                                for(int u=0;u<selectedweekday.length;u++){
                                                  addschdulejp.days.add("${weekdays[selectedweekday[u]]}");
                                                }
                                                setState(() {
                                                  isApiCallProcess = true;
                                                });
                                                await addschdulejourneypaln();

                                                setState(() {
                                                  isApiCallProcess = false;
                                                });
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                        context) =>
                                                            FieldManagerDashBoard()));
                                              }else{
                                                Flushbar(
                                                  message: selectedoutlets == null ? "Outlet Should not be Empty" : selectedmerchandiser == null ? "Merchandiser cannot be empty":selectmerchundercde==null? "Merchandiser cannot be empty":selectedmonth == null ? "Month cannot be empty" : "days cannot be empty",
                                                  duration:  Duration(seconds: 3),
                                                )..show(context);
                                              }

                                            }else{
                                              setState(() {
                                                isApiCallProcess = true;
                                              });
                                              if(selectedoutlets != null &&  currentuser.roleid==5?selectedmerchandiser != null:selectmerchundercde!=null && selecteddate != null){
                                                for(int u=0;u<selectedoutlets.length;u++){
                                                  addunschdulejp.outletid.add(outletdata.outletid[selectedoutlets[u]]);
                                                  addschdulejp.outletid.add(outletdata.outletid[selectedoutlets[u]]);
                                                }
                                                if(currentuser.roleid==5){
                                                  for(int u=0;u<merchnamelist.firstname.length;u++){
                                                  if (merchnamelist.firstname[u] == selectedmerchandiser) {
                                                    addunschdulejp.empid = merchnamelist.employeeid[u];
                                                    addschdulejp.empid = merchnamelist.employeeid[u];
                                                  }}}
                                                else{
                                                  for(int u=0;u<MerchUnderCDE.firstname.length;u++){
                                                  if (MerchUnderCDE.firstname[u] == selectmerchundercde) {
                                                    addunschdulejp.empid = MerchUnderCDE.employeeid[u];
                                                    addschdulejp.empid = MerchUnderCDE.employeeid[u];
                                                  }}}
                                                addunschdulejp.date =  DateFormat('yyyy-MM-dd').format(selecteddate);
                                                await addunschdulejourneypaln();
                                                setState(() {
                                                  isApiCallProcess = false;
                                                });
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                        context) =>
                                                            FieldManagerDashBoard()));

                                              }else{
                                                Flushbar(
                                                  message: selectedoutlets == null ? "Outlet Should not be Empty" : selectedmerchandiser == null ? "Merchandiser cannot be empty" : "Date cannot be empty",
                                                  duration:  Duration(seconds: 3),
                                                )..show(context);
                                              }
                                            }
                                          },
                                          child: Container(
                                              margin: EdgeInsets.only(top: 10.0),
                                              padding: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: orange,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text("SAVE",style: TextStyle(color: Colors.white),))),
                                    ),


                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),





                      ]
                  ),
                ),
              ),



              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  onTap: ()async{
                   Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext
                            context) =>
                                AddWeekOff()));
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(color: pink,
                    borderRadius: BorderRadius.circular(10.0)),
                      child: Text("Week Off",style: TextStyle(fontSize: 16.0,color: orange),)
                  ),
                ),
              ),


            ],
          ),

        ),
    );
  }

  Widget _createSearchView() {
    return new Container(
      padding: EdgeInsets.only(left: 20.0),
      width: double.infinity,
      decoration: BoxDecoration(color: pink,
          borderRadius: BorderRadius.circular(25.0)),
      child: new TextField(
        style: TextStyle(color: orange),
        controller: _searchview,
        cursorColor:orange,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          focusColor: orange,
          hintText: 'Search by name or EmpID',
          hintStyle: TextStyle(color: orange),
          border: InputBorder.none,
          icon: Icon(CupertinoIcons.search,color: orange,),
          isCollapsed: true,
        ),
      ),
    );
  }
  Widget _createListView() {
    return new Flexible(
      child: new  ListView.builder(
         // shrinkWrap: true,
          itemCount: currentuser.roleid==5?merchnamelist.firstname.length:MerchUnderCDE.firstname.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap:()async{
                // print(merchnamelist.employeeid[index]);
                jpempid =currentuser.roleid==5? merchnamelist.employeeid[index]:MerchUnderCDE.employeeid[index];
                currentid = currentuser.roleid==5?merchnamelist.employeeid[index]:MerchUnderCDE.employeeid[index];
                currentname =currentuser.roleid==5? merchnamelist.name[index]:MerchUnderCDE.name[index];
                print(jpempid);
                for(int i=0;i<Weekoff.empid.length;i++){
                  if(Weekoff.empid[i] == currentid){
                    if(DateFormat("y").format(DateTime.now()) == Weekoff.year[i]){
                      if (Weekoff.month[i] == DateFormat.MMMM().format(DateTime.now())) {
                        weekoffon = Weekoff.day[i];
                      }
                    }
                  }
                }
                setState(() {
                  isApiCallProcess = true;
                });
                currentlysyncing = true;
                await getJourneyPlanweekly();
                setState(() {
                  isApiCallProcess = false;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      // ignore: non_constant_identifier_names
                        builder: (BuildContextcontext) => journeyplanDetails()));
              },
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.fromLTRB(0.0,0,0,10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentuser.roleid==5?'Merchandiser : ${merchnamelist.name[index]}':
                      'Merchandiser : ${MerchUnderCDE.name[index]}',
                          style: TextStyle(
                              fontSize: 16.0,color: orange
                          )),
                      SizedBox(height: 5),
                      Text(currentuser.roleid==5?'Emp ID : ${merchnamelist.employeeid[index]}':
                      'Emp ID : ${MerchUnderCDE.employeeid[index]}',
                          style: TextStyle(
                            fontSize: 14.0,
                          )),
                    ],
                  )),
            );
          }),
    );
  }
  int searchedindex ;
  Widget _performSearch() {
    _filterList = [];
    List<String> currentlist = currentuser.roleid==5?merchnamelist.firstname:MerchUnderCDE.firstname;
    for (int i = 0;i<currentlist.length;i++) {
      var item = currentuser.roleid==5?merchnamelist.firstname[i]:MerchUnderCDE.firstname[i];
      if (item.toLowerCase().contains(_query.toLowerCase())) {
        int searchedindex = currentuser.roleid==5?merchnamelist.firstname.indexOf(item):MerchUnderCDE.firstname.indexOf(item);
        _filterList.add(searchedindex);
      }
    }
    return _createFilteredListView();
  }
  Widget _createFilteredListView() {
    return new Flexible(
      child: new ListView.builder(
          shrinkWrap: true,
          itemCount: _filterList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap:()async{

                jpempid =currentuser.roleid==5? merchnamelist.employeeid[_filterList[index]]:MerchUnderCDE.employeeid[_filterList[index]];
                currentid = currentuser.roleid==5?merchnamelist.employeeid[_filterList[index]]:MerchUnderCDE.employeeid[_filterList[index]];
                currentname =currentuser.roleid==5? merchnamelist.name[_filterList[index]]:MerchUnderCDE.name[_filterList[index]];
                for(int i=0;i<Weekoff.empid.length;i++){
                  print(Weekoff.empid[i]);
                  if(Weekoff.empid[i] == currentid){
                    if(DateFormat("y").format(DateTime.now()) == Weekoff.year[i]){
                      if (Weekoff.month[i] == DateFormat.MMMM().format(DateTime.now())) {
                        weekoffon = Weekoff.day[i];
                      }
                    }
                  }
                }
                setState(() {
                  isApiCallProcess = true;
                });
                currentlysyncing = true;
                await getJourneyPlanweekly();
                setState(() {
                  isApiCallProcess = false;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      // ignore: non_constant_identifier_names
                        builder: (BuildContextcontext) => journeyplanDetails()));
              },
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.fromLTRB(0.0,0,0,10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentuser.roleid==5?'Merchandiser : ${merchnamelist.name[_filterList[index]]}':
                      'Merchandiser : ${MerchUnderCDE.name[_filterList[index]]}',
                          style: TextStyle(
                              fontSize: 16.0,color: orange
                          )),
                      SizedBox(height: 5),
                      Text(currentuser.roleid==5?'Emp ID : ${merchnamelist.employeeid[_filterList[index]]}':
                      'Emp ID : ${MerchUnderCDE.employeeid[_filterList[index]]}',
                          style: TextStyle(
                            fontSize: 14.0,
                          )),
                    ],
                  )),
            );
          }),
    );
  }
}





DateTime selecteddate = DateTime.now();
class StartDate extends StatefulWidget {
  @override
  _StartDateState createState() => _StartDateState();
}

class _StartDateState extends State<StartDate> {
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selecteddate,
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
            dialogBackgroundColor:Colors.grey[100],
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selecteddate)
      setState(() {
        selecteddate = picked;
      });
  }
  @override

  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text("Select Date",style: TextStyle(fontSize: 16),),
          Spacer(),
          Text("${selecteddate.toLocal()}".split(' ')[0],
            style: TextStyle(fontSize: 16),),
          IconButton(
            icon: Icon(CupertinoIcons.calendar,size: 25),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),

    );
  }
}

// ignore: camel_case_types
class schedulejp extends StatefulWidget {
  @override
  _schedulejpState createState() => _schedulejpState();
}
List month = months.map((String val) {return new DropdownMenuItem<String>(value: val, child: new Text(val),);}).toList();
List weekday = weekdays.map((String val) {return new DropdownMenuItem<String>(value: val, child: new Text(val),);}).toList();
List<String> months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
String selectedmonth;
List<String> weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
List<int> selectedweekday;
// ignore: camel_case_types
class _schedulejpState extends State<schedulejp> {
  @override
  Widget build(BuildContext context)  {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 5,bottom: 5),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left:10.0),
            child: SearchableDropdown.single(
              closeButton: SizedBox(),
              underline: SizedBox(),
              items: month,
              value: selectedmonth,
              hint: "Select Month",
              searchHint: "Select Month",
              onChanged: (value) {
                setState(() {
                  selectedmonth = value;
                });
              },
              isExpanded: true,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 5,bottom: 5),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SearchableDropdown.multiple(
            underline: SizedBox(),
            items: weekday,
            selectedItems: selectedweekday,
            hint: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Select Days"),
            ),
            searchHint: "Select Day",
            onChanged: (value) {
              setState(() {
                selectedweekday = value;
                print(selectedweekday);
              });
            },
            closeButton: (selectedItems) {
              return (selectedItems.isNotEmpty
                  ? "Save ${selectedItems.length == 1 ? '"' + weekday[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
                  : "Save without selection");
            },
            isExpanded: true,
          ),
        ),
      ],
    );
  }
}

var currentname;
var currentid;
var weekoffon;
class journeyplanDetails extends StatefulWidget {
  @override
  _journeyplanDetailsState createState() => _journeyplanDetailsState();
}

class _journeyplanDetailsState extends State<journeyplanDetails> {
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      opacity: 0.3,
      inAsyncCall: isApiCallProcess,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: pink,
          iconTheme: IconThemeData(color: orange),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Journey Plan Details",style: TextStyle(color: orange),),
                  EmpInfo()
                ],
              ),
              GestureDetector(
                onTap: (){
                  selectedmerch = currentname;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext
                          context) =>
                              MapVeiw()));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10.00),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: orange,
                    borderRadius: BorderRadius.circular(10.00),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.location_solid,
                        size: 15,color: Colors.white,
                      ),
                      SizedBox(width: 5,),
                      Text("Map",style: TextStyle(fontSize: 15,color: Colors.white),),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            BackGround(),
            SingleChildScrollView(
              child: Column(
                children: [
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
                        Text(currentname,
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
                            Text(currentid,
                                style: TextStyle(fontSize: 16,))
                          ],
                        ),
                        weekoffon!= null ?Row(
                          children: [
                            Text(
                              "Week off :",
                              style: TextStyle(fontSize: 16,),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(weekoffon,
                                style: TextStyle(fontSize: 16,))
                          ],
                        ):SizedBox(),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.only(left: 10.0,right: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.00),
                        color:containerscolor,
                      ),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      sundaytapped == true
                                          ? CupertinoIcons.arrowtriangle_down_fill
                                          : CupertinoIcons.arrowtriangle_right_fill,
                                      color: orange,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        sundaytapped == true ? sundaytapped = false : sundaytapped = true;
                                      });
                                    }),
                                Text(
                                  "Sunday",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            sundaytapped == true
                                ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: getweeklyjp.sundayaddress.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onLongPress: (){
                                      if(currentuser.roleid ==5 ||currentuser.roleid ==2){
                                        showDialog(
                                            context: context,
                                            builder: (_) =>StatefulBuilder(
                                                builder: (context, setState) {
                                                  return ProgressHUD(
                                                      inAsyncCall: isApiCallProcess,
                                                      opacity: 0.3,
                                                      child: AlertDialog(
                                                        backgroundColor: alertboxcolor,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(10.0))),
                                                        content: Builder(
                                                          builder: (context) {
                                                            // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                            return Container(
                                                              child: SizedBox(
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(
                                                                      "Alert",
                                                                      style: TextStyle(
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 15.00,
                                                                    ),
                                                                    Text(
                                                                        "Are you sure do you want to Delete this TimeSheet?",
                                                                        style: TextStyle(fontSize: 14)),
                                                                    SizedBox(
                                                                      height: 25.00,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: () async {
                                                                            setState(() {
                                                                              isApiCallProcess = true;
                                                                            });
                                                                            timesheetiddel = getweeklyjp.sundayid[index];
                                                                            await deletetimesheet();
                                                                            //updateoutlet.outletedit = true;
                                                                            setState(() {
                                                                              isApiCallProcess = false;
                                                                            });
                                                                            Navigator.pushReplacement(context,
                                                                                MaterialPageRoute(builder: (
                                                                                    BuildContext context) =>
                                                                                    AddJourneyPlan()));
                                                                          },
                                                                          child: Container(
                                                                            height: 40,
                                                                            width: 70,
                                                                            decoration: BoxDecoration(
                                                                              color: orange,
                                                                              borderRadius: BorderRadius
                                                                                  .circular(5),
                                                                            ),
                                                                            margin: EdgeInsets.only(
                                                                                right: 10.00),
                                                                            child: Center(child: Text("yes")),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ));
                                                }));
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      height: 80,
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '[${getweeklyjp.sundaystorecodes[index]}]',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(
                                                    '${getweeklyjp.sundaystorenames[index]}',
                                                    style: TextStyle(
                                                        fontSize: 15.0,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text('${getweeklyjp.sundayaddress[index]}',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                )),
                                          ),
                                          Spacer(),
                                          Table(
                                            children: [
                                              TableRow(children: [
                                                Text('Contact Number :',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                    )),
                                                Text(
                                                    '${getweeklyjp.sundaycontactnumbers[index]}',
                                                    style: TextStyle(color: orange)),
                                              ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                                : SizedBox()
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      mondaytapped == true
                                          ? CupertinoIcons.arrowtriangle_down_fill
                                          : CupertinoIcons.arrowtriangle_right_fill,
                                      color: orange,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        mondaytapped == true ? mondaytapped = false : mondaytapped = true;
                                      });
                                    }),
                                Text(
                                  "Monday",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            mondaytapped == true
                                ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: getweeklyjp.mondayaddress.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: ()async{

                                    },
                                    onLongPress: (){
                                      if(currentuser.roleid ==5){
                                        showDialog(
                                            context: context,
                                            builder: (_) =>StatefulBuilder(
                                                builder: (context, setState) {
                                                  return ProgressHUD(
                                                      inAsyncCall: isApiCallProcess,
                                                      opacity: 0.3,
                                                      child: AlertDialog(
                                                        backgroundColor: alertboxcolor,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(10.0))),
                                                        content: Builder(
                                                          builder: (context) {
                                                            // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                            return Container(
                                                              child: SizedBox(
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(
                                                                      "Alert",
                                                                      style: TextStyle(
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 15.00,
                                                                    ),
                                                                    Text(
                                                                        "Are you sure do you want to Delete this TimeSheet?",
                                                                        style: TextStyle(fontSize: 14)),
                                                                    SizedBox(
                                                                      height: 25.00,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: () async {
                                                                            setState(() {
                                                                              isApiCallProcess = true;
                                                                            });
                                                                            timesheetiddel = getweeklyjp.mondayid[index];
                                                                            await deletetimesheet();
                                                                            //updateoutlet.outletedit = true;
                                                                            setState(() {
                                                                              isApiCallProcess = false;
                                                                            });
                                                                            Navigator.pushReplacement(context,
                                                                                MaterialPageRoute(builder: (
                                                                                    BuildContext context) =>
                                                                                    AddJourneyPlan()));
                                                                          },
                                                                          child: Container(
                                                                            height: 40,
                                                                            width: 70,
                                                                            decoration: BoxDecoration(
                                                                              color: orange,
                                                                              borderRadius: BorderRadius
                                                                                  .circular(5),
                                                                            ),
                                                                            margin: EdgeInsets.only(
                                                                                right: 10.00),
                                                                            child: Center(child: Text("yes")),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ));
                                                }));
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      height: 80,
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '[${getweeklyjp.mondaystorecodes[index]}]',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  '${getweeklyjp.mondaystorenames[index]}',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text('${getweeklyjp.mondayaddress[index]}',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              )),
                                          Spacer(),
                                          Table(
                                            children: [
                                              TableRow(children: [
                                                Text('Contact Number :',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                    )),
                                                Text(
                                                    '${getweeklyjp.mondaycontactnumbers[index]}',
                                                    style: TextStyle(color: orange)),
                                              ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                                : SizedBox()
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      tuesdaytapped == true
                                          ? CupertinoIcons.arrowtriangle_down_fill
                                          : CupertinoIcons.arrowtriangle_right_fill,
                                      color: orange,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        tuesdaytapped == true ? tuesdaytapped = false : tuesdaytapped = true;
                                      });
                                    }),
                                Text(
                                  "Tuesday",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            tuesdaytapped == true
                                ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: getweeklyjp.tuesdayaddress.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: ()async{

                                    },
                                    onLongPress: (){
                                      if(currentuser.roleid ==5){
                                        showDialog(
                                            context: context,
                                            builder: (_) =>StatefulBuilder(
                                                builder: (context, setState) {
                                                  return ProgressHUD(
                                                      inAsyncCall: isApiCallProcess,
                                                      opacity: 0.3,
                                                      child: AlertDialog(
                                                        backgroundColor: alertboxcolor,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(10.0))),
                                                        content: Builder(
                                                          builder: (context) {
                                                            // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                            return Container(
                                                              child: SizedBox(
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(
                                                                      "Alert",
                                                                      style: TextStyle(
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 15.00,
                                                                    ),
                                                                    Text(
                                                                        "Are you sure do you want to Delete this TimeSheet?",
                                                                        style: TextStyle(fontSize: 14)),
                                                                    SizedBox(
                                                                      height: 25.00,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: () async {
                                                                            setState(() {
                                                                              isApiCallProcess = true;
                                                                            });
                                                                            timesheetiddel = getweeklyjp.tuesdayid[index];
                                                                            await deletetimesheet();
                                                                            //updateoutlet.outletedit = true;
                                                                            setState(() {
                                                                              isApiCallProcess = false;
                                                                            });
                                                                            Navigator.pushReplacement(context,
                                                                                MaterialPageRoute(builder: (
                                                                                    BuildContext context) =>
                                                                                    AddJourneyPlan()));
                                                                          },
                                                                          child: Container(
                                                                            height: 40,
                                                                            width: 70,
                                                                            decoration: BoxDecoration(
                                                                              color: orange,
                                                                              borderRadius: BorderRadius
                                                                                  .circular(5),
                                                                            ),
                                                                            margin: EdgeInsets.only(
                                                                                right: 10.00),
                                                                            child: Center(child: Text("yes")),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ));
                                                }));
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      height: 80,
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '[${getweeklyjp.tuesdaystorecodes[index]}]',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  '${getweeklyjp.tuesdaystorenames[index]}',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text('${getweeklyjp.tuesdayaddress[index]}',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              )),
                                          Spacer(),
                                          Table(
                                            children: [
                                              TableRow(children: [
                                                Text('Contact Number :',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                    )),
                                                Text(
                                                    '${getweeklyjp.tuesdaycontactnumbers[index]}',
                                                    style: TextStyle(color: orange)),
                                              ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                                : SizedBox()
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      wednesdaytapped == true
                                          ? CupertinoIcons.arrowtriangle_down_fill
                                          : CupertinoIcons.arrowtriangle_right_fill,
                                      color: orange,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        wednesdaytapped == true ? wednesdaytapped = false : wednesdaytapped = true;
                                      });
                                    }),
                                Text(
                                  "Wednesday",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            wednesdaytapped == true
                                ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: getweeklyjp.wednesdayaddress.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: ()async{

                                    },
                                    onLongPress: (){
                                      if(currentuser.roleid ==5){
                                        showDialog(
                                            context: context,
                                            builder: (_) =>StatefulBuilder(
                                                builder: (context, setState) {
                                                  return ProgressHUD(
                                                      inAsyncCall: isApiCallProcess,
                                                      opacity: 0.3,
                                                      child: AlertDialog(
                                                        backgroundColor: alertboxcolor,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(10.0))),
                                                        content: Builder(
                                                          builder: (context) {
                                                            // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                            return Container(
                                                              child: SizedBox(
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(
                                                                      "Alert",
                                                                      style: TextStyle(
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 15.00,
                                                                    ),
                                                                    Text(
                                                                        "Are you sure do you want to Delete this TimeSheet?",
                                                                        style: TextStyle(fontSize: 14)),
                                                                    SizedBox(
                                                                      height: 25.00,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: () async {
                                                                            setState(() {
                                                                              isApiCallProcess = true;
                                                                            });
                                                                            timesheetiddel = getweeklyjp.wednesdayid[index];
                                                                            await deletetimesheet();
                                                                            //updateoutlet.outletedit = true;
                                                                            setState(() {
                                                                              isApiCallProcess = false;
                                                                            });
                                                                            Navigator.pushReplacement(context,
                                                                                MaterialPageRoute(builder: (
                                                                                    BuildContext context) =>
                                                                                    AddJourneyPlan()));
                                                                          },
                                                                          child: Container(
                                                                            height: 40,
                                                                            width: 70,
                                                                            decoration: BoxDecoration(
                                                                              color: orange,
                                                                              borderRadius: BorderRadius
                                                                                  .circular(5),
                                                                            ),
                                                                            margin: EdgeInsets.only(
                                                                                right: 10.00),
                                                                            child: Center(child: Text("yes")),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ));
                                                }));
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      height: 80,
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '[${getweeklyjp.wednesdaystorecodes[index]}]',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  '${getweeklyjp.wednesdaystorenames[index]}',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text('${getweeklyjp.wednesdayaddress[index]}',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              )),
                                          Spacer(),
                                          Table(
                                            children: [
                                              TableRow(children: [
                                                Text('Contact Number :',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                    )),
                                                Text(
                                                    '${getweeklyjp.wednesdaycontactnumbers[index]}',
                                                    style: TextStyle(color: orange)),
                                              ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                                : SizedBox()
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      thursdaytapped == true
                                          ? CupertinoIcons.arrowtriangle_down_fill
                                          : CupertinoIcons.arrowtriangle_right_fill,
                                      color: orange,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        thursdaytapped == true ? thursdaytapped = false : thursdaytapped = true;
                                      });
                                    }),
                                Text(
                                  "Thursday",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            thursdaytapped == true
                                ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: getweeklyjp.thrusdayaddress.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: ()async{

                                    },
                                    onLongPress: (){
                                      if(currentuser.roleid ==5){
                                        showDialog(
                                            context: context,
                                            builder: (_) =>StatefulBuilder(
                                                builder: (context, setState) {
                                                  return ProgressHUD(
                                                      inAsyncCall: isApiCallProcess,
                                                      opacity: 0.3,
                                                      child: AlertDialog(
                                                        backgroundColor: alertboxcolor,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(10.0))),
                                                        content: Builder(
                                                          builder: (context) {
                                                            // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                            return Container(
                                                              child: SizedBox(
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(
                                                                      "Alert",
                                                                      style: TextStyle(
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 15.00,
                                                                    ),
                                                                    Text(
                                                                        "Are you sure do you want to Delete this TimeSheet?",
                                                                        style: TextStyle(fontSize: 14)),
                                                                    SizedBox(
                                                                      height: 25.00,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: () async {
                                                                            setState(() {
                                                                              isApiCallProcess = true;
                                                                            });
                                                                            timesheetiddel = getweeklyjp.thrusdayid[index];
                                                                            await deletetimesheet();
                                                                            //updateoutlet.outletedit = true;
                                                                            setState(() {
                                                                              isApiCallProcess = false;
                                                                            });
                                                                            Navigator.pushReplacement(context,
                                                                                MaterialPageRoute(builder: (
                                                                                    BuildContext context) =>
                                                                                    AddJourneyPlan()));
                                                                          },
                                                                          child: Container(
                                                                            height: 40,
                                                                            width: 70,
                                                                            decoration: BoxDecoration(
                                                                              color: orange,
                                                                              borderRadius: BorderRadius
                                                                                  .circular(5),
                                                                            ),
                                                                            margin: EdgeInsets.only(
                                                                                right: 10.00),
                                                                            child: Center(child: Text("yes")),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ));
                                                }));
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      height: 80,
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '[${getweeklyjp.thrusdaystorecodes[index]}]',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  '${getweeklyjp.thrusdaystorenames[index]}',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text('${getweeklyjp.thrusdayaddress[index]}',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              )),
                                          Spacer(),
                                          Table(
                                            children: [
                                              TableRow(children: [
                                                Text('Contact Number :',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                    )),
                                                Text(
                                                    '${getweeklyjp.thrusdaycontactnumbers[index]}',
                                                    style: TextStyle(color: orange)),
                                              ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                                : SizedBox()
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      fridaytapped == true
                                          ? CupertinoIcons.arrowtriangle_down_fill
                                          : CupertinoIcons.arrowtriangle_right_fill,
                                      color: orange,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        fridaytapped == true ? fridaytapped = false : fridaytapped = true;
                                      });
                                    }),
                                Text(
                                  "Friday",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            fridaytapped == true
                                ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: getweeklyjp.fridayaddress.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: ()async{

                                    },
                                    onLongPress: (){
                                      if(currentuser.roleid ==5){
                                        showDialog(
                                            context: context,
                                            builder: (_) =>StatefulBuilder(
                                                builder: (context, setState) {
                                                  return ProgressHUD(
                                                      inAsyncCall: isApiCallProcess,
                                                      opacity: 0.3,
                                                      child: AlertDialog(
                                                        backgroundColor: alertboxcolor,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(10.0))),
                                                        content: Builder(
                                                          builder: (context) {
                                                            // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                            return Container(
                                                              child: SizedBox(
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(
                                                                      "Alert",
                                                                      style: TextStyle(
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 15.00,
                                                                    ),
                                                                    Text(
                                                                        "Are you sure do you want to Delete this TimeSheet?",
                                                                        style: TextStyle(fontSize: 14)),
                                                                    SizedBox(
                                                                      height: 25.00,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: () async {
                                                                            setState(() {
                                                                              isApiCallProcess = true;
                                                                            });
                                                                            timesheetiddel = getweeklyjp.fridayid[index];
                                                                            await deletetimesheet();
                                                                            //updateoutlet.outletedit = true;
                                                                            setState(() {
                                                                              isApiCallProcess = false;
                                                                            });
                                                                            Navigator.pushReplacement(context,
                                                                                MaterialPageRoute(builder: (
                                                                                    BuildContext context) =>
                                                                                    AddJourneyPlan()));
                                                                          },
                                                                          child: Container(
                                                                            height: 40,
                                                                            width: 70,
                                                                            decoration: BoxDecoration(
                                                                              color: orange,
                                                                              borderRadius: BorderRadius
                                                                                  .circular(5),
                                                                            ),
                                                                            margin: EdgeInsets.only(
                                                                                right: 10.00),
                                                                            child: Center(child: Text("yes")),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ));
                                                }));
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      height: 80,
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '[${getweeklyjp.fridaystorecodes[index]}]',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  '${getweeklyjp.fridaystorenames[index]}',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text('${getweeklyjp.fridayaddress[index]}',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              )),
                                          Spacer(),
                                          Table(
                                            children: [
                                              TableRow(children: [
                                                Text('Contact Number :',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                    )),
                                                Text(
                                                    '${getweeklyjp.fridaycontactnumbers[index]}',
                                                    style: TextStyle(color: orange)),
                                              ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                                : SizedBox()
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    icon: Icon(
                                      saturdaytapped == true
                                          ? CupertinoIcons.arrowtriangle_down_fill
                                          : CupertinoIcons.arrowtriangle_right_fill,
                                      color: orange,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        saturdaytapped == true ? saturdaytapped = false : saturdaytapped = true;
                                      });
                                    }),
                                Text(
                                  "Saturday",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                            saturdaytapped == true
                                ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: getweeklyjp.saturdaystorenames.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: ()async{

                                    },
                                    onLongPress: (){
                                      if(currentuser.roleid ==5){
                                        showDialog(
                                            context: context,
                                            builder: (_) =>StatefulBuilder(
                                                builder: (context, setState) {
                                                  return ProgressHUD(
                                                      inAsyncCall: isApiCallProcess,
                                                      opacity: 0.3,
                                                      child: AlertDialog(
                                                        backgroundColor: alertboxcolor,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(10.0))),
                                                        content: Builder(
                                                          builder: (context) {
                                                            // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                            return Container(
                                                              child: SizedBox(
                                                                child: Column(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  crossAxisAlignment: CrossAxisAlignment
                                                                      .start,
                                                                  children: [
                                                                    Text(
                                                                      "Alert",
                                                                      style: TextStyle(
                                                                          fontSize: 16,
                                                                          fontWeight: FontWeight.bold),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 15.00,
                                                                    ),
                                                                    Text(
                                                                        "Are you sure do you want to Delete this TimeSheet?",
                                                                        style: TextStyle(fontSize: 14)),
                                                                    SizedBox(
                                                                      height: 25.00,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .center,
                                                                      children: [
                                                                        GestureDetector(
                                                                          onTap: () async {
                                                                            setState(() {
                                                                              isApiCallProcess = true;
                                                                            });
                                                                            timesheetiddel = getweeklyjp.saturdayid[index];
                                                                            await deletetimesheet();
                                                                            //updateoutlet.outletedit = true;
                                                                            setState(() {
                                                                              isApiCallProcess = false;
                                                                            });
                                                                            Navigator.pushReplacement(context,
                                                                                MaterialPageRoute(builder: (
                                                                                    BuildContext context) =>
                                                                                    AddJourneyPlan()));
                                                                          },
                                                                          child: Container(
                                                                            height: 40,
                                                                            width: 70,
                                                                            decoration: BoxDecoration(
                                                                              color: orange,
                                                                              borderRadius: BorderRadius
                                                                                  .circular(5),
                                                                            ),
                                                                            margin: EdgeInsets.only(
                                                                                right: 10.00),
                                                                            child: Center(child: Text("yes")),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ));
                                                }));
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
                                      padding: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                      height: 80,
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '[${getweeklyjp.saturdaystorecodes[index]}]',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  '${getweeklyjp.saturdaystorenames[index]}',
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text('${getweeklyjp.saturdayaddress[index]}',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              )),
                                          Spacer(),
                                          Table(
                                            children: [
                                              TableRow(children: [
                                                Text('Contact Number :',
                                                    style: TextStyle(
                                                      fontSize: 13.0,
                                                    )),
                                                Text(
                                                    '${getweeklyjp.saturdaycontactnumbers[index]}',
                                                    style: TextStyle(color: orange)),
                                              ]),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                })
                                : SizedBox()
                          ],
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

