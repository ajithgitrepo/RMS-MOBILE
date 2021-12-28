import 'package:merchandising/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/MenuContent.dart';
import 'package:merchandising/api/timesheetapi.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/Time Sheet.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:merchandising/api/timesheetmonthly.dart';
import 'package:merchandising/api/FMapi/merchnamelistapi.dart';
import 'package:merchandising/main.dart';


var tts;

class MerchandisersList extends StatefulWidget {
  @override
  _MerchandisersListState createState() => _MerchandisersListState();
}

class _MerchandisersListState extends State<MerchandisersList> {
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

  _MerchandisersListState() {
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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: pink,
          iconTheme: IconThemeData(color: orange),
          title: Column(
            children: [
              Text("Time Sheet",style: TextStyle(color: orange),),
              EmpInfo()
            ],
          ),
        ),
        // drawer: Drawer(
        //   child: Menu(),
        // ),
        body: Stack(
          children: [
            BackGround(),
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
        // physics: NeverScrollableScrollPhysics(),
        // shrinkWrap: true,
          itemCount: currentuser.roleid==2?MerchUnderCDE.firstname.length:merchnamelist.firstname.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap:()async{
                // alldateselected=false;
                //print(merchnamelist.name[index]);
                timesheet.empid = currentuser.roleid==2?MerchUnderCDE.employeeid[index]:merchnamelist.employeeid[index];
                timesheet.empname = currentuser.roleid==2?MerchUnderCDE.name[index]:merchnamelist.name[index];
                // print(timesheet.empname);
                setState(() {
                  isApiCallProcess = true;
                });
                await getTimeSheetdaily();
                await gettimesheetmonthly();
                setState(() {
                  isApiCallProcess = false;
                });
                // tts=TMmonthly.day5.length;
                // tts = TMmonthly.day1.length+TMmonthly.day2.length+TMmonthly.day3.length+TMmonthly.day4.length+TMmonthly.day5.length
                //     +TMmonthly.day6.length+TMmonthly.day7.length+TMmonthly.day8.length+TMmonthly.day9.length+TMmonthly.day10.length
                //     +TMmonthly.day11.length+TMmonthly.day12.length+TMmonthly.day13.length+TMmonthly.day14.length+TMmonthly.day15.length
                //     +TMmonthly.day16.length+TMmonthly.day17.length+TMmonthly.day18.length+TMmonthly.day19.length+TMmonthly.day20.length
                //     +TMmonthly.day21.length+TMmonthly.day22.length+TMmonthly.day23.length+TMmonthly.day24.length+TMmonthly.day25.length
                //     +TMmonthly.day26.length+TMmonthly.day27.length+TMmonthly.day28.length+TMmonthly.day29.length+TMmonthly.day30.length
                //     +TMmonthly.day31.length;
                //
                // print("tts:${tts}");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      // ignore: non_constant_identifier_names
                        builder: (BuildContextcontext) => TimeSheetList()));
              },
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(top: 10),
                  // margin: index == 0 ? EdgeInsets.fromLTRB(10.0,10,10,10):EdgeInsets.fromLTRB(10.0,0,10,10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentuser.roleid==2?'${MerchUnderCDE.firstname[index]}' :'${merchnamelist.name[index]}',
                          style: TextStyle(
                              fontSize: 16.0,color: orange
                          )),
                      SizedBox(height: 5),
                      Text(currentuser.roleid==2?'Emp ID:${MerchUnderCDE.employeeid[index]}':'Emp ID : ${merchnamelist.employeeid[index]}',
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
      child: new  ListView.builder(
        // physics: NeverScrollableScrollPhysics(),
        // shrinkWrap: true,
          itemCount: _filterList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap:()async{
                //print(merchnamelist.name[index]);
                timesheet.empid = currentuser.roleid==2?MerchUnderCDE.employeeid[_filterList[index]]:merchnamelist.employeeid[_filterList[index]];
                timesheet.empname = currentuser.roleid==2?MerchUnderCDE.name[_filterList[index]]:merchnamelist.name[_filterList[index]];
                print("filtered list");
                print(timesheet.empname);
                setState(() {
                  isApiCallProcess = true;
                });
                await getTimeSheetdaily();
                await gettimesheetmonthly();
                setState(() {
                  isApiCallProcess = false;
                });
                // tts=TMmonthly.day5.length;
                // tts = TMmonthly.day1.length+TMmonthly.day2.length+TMmonthly.day3.length+TMmonthly.day4.length+TMmonthly.day5.length
                //     +TMmonthly.day6.length+TMmonthly.day7.length+TMmonthly.day8.length+TMmonthly.day9.length+TMmonthly.day10.length
                //     +TMmonthly.day11.length+TMmonthly.day12.length+TMmonthly.day13.length+TMmonthly.day14.length+TMmonthly.day15.length
                //     +TMmonthly.day16.length+TMmonthly.day17.length+TMmonthly.day18.length+TMmonthly.day19.length+TMmonthly.day20.length
                //     +TMmonthly.day21.length+TMmonthly.day22.length+TMmonthly.day23.length+TMmonthly.day24.length+TMmonthly.day25.length
                //     +TMmonthly.day26.length+TMmonthly.day27.length+TMmonthly.day28.length+TMmonthly.day29.length+TMmonthly.day30.length
                //     +TMmonthly.day31.length;
                //
                // print("tts:${tts}");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      // ignore: non_constant_identifier_names
                        builder: (BuildContextcontext) => TimeSheetList()));
              },
              child: Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.only(top: 10),
                  // margin: index == 0 ? EdgeInsets.fromLTRB(10.0,10,10,10):EdgeInsets.fromLTRB(10.0,0,10,10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currentuser.roleid==2?'${MerchUnderCDE.firstname[_filterList[index]]}' :'${merchnamelist.name[_filterList[index]]}',
                          style: TextStyle(
                              fontSize: 16.0,color: orange
                          )),
                      SizedBox(height: 5),
                      Text(currentuser.roleid==2?'Emp ID:${MerchUnderCDE.employeeid[_filterList[index]]}':'Emp ID : ${merchnamelist.employeeid[_filterList[index]]}',
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


