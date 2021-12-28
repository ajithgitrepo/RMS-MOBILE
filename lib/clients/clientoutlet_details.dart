import 'package:flutter/rendering.dart';
import 'package:merchandising/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:merchandising/api/api_service.dart';
import 'package:merchandising/api/clientapi/outletreport.dart';
import 'package:merchandising/clients/reports.dart';
import 'package:merchandising/api/avaiablityapi.dart';
import 'package:merchandising/api/customer_activites_api/visibilityapi.dart';
import 'package:merchandising/api/customer_activites_api/share_of_shelf_detailsapi.dart';
import 'package:merchandising/api/customer_activites_api/competition_details.dart';
import 'package:merchandising/api/customer_activites_api/planogramdetailsapi.dart';
import 'package:merchandising/api/customer_activites_api/promotion_detailsapi.dart';
import 'package:merchandising/api/clientapi/stockexpirydetailes.dart';
import 'package:merchandising/api/clientapi/clientpromodetailes.dart';


bool isApiCallProcess = false;


class ClientOutletsdata extends StatefulWidget {
  @override
  _ClientOutletsdataState createState() => _ClientOutletsdataState();
}

class _ClientOutletsdataState extends State<ClientOutletsdata> {
  var _searchview = new TextEditingController();
  bool _firstSearch = true;
  String _query = "";

  List<int> _filterindex;

  _ClientOutletsdataState() {
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
  bool isApiCallProcess = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: ProgressHUD(
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: pink,
            iconTheme: IconThemeData(color: orange),
            title: Column(
              children: [
                GestureDetector(
                    onTap: (){
                      Addedstockdataforclient();
                    },
                    child: Text("Outlet Details",style: TextStyle(color: orange),)),
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
      ),
    );
  }
  Widget _createSearchView() {
    return new Container(
      padding: EdgeInsets.only(left: 20.0),
      width: double.infinity,
      decoration: BoxDecoration(color: pink,
          borderRadius: BorderRadius.circular(100.0)),
      child: new TextField(
        style: TextStyle(color: orange),
        controller: _searchview,
        cursorColor:orange,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          focusColor: orange,
          hintText: 'Search by Outlet',
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
      child: new ListView.builder(
          shrinkWrap: true,
          itemCount: clientoutlets.outletname.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: ()async{
                  setState(() {
                    isApiCallProcess = true;
                  });
                  indexclientselected = index;
                  currentoutletid = clientoutlets.outletid[index];
                  currenttimesheetid = clientoutlets.timesheetid[index];
                  print("current TSid for Report------->${currenttimesheetid}");
                  FMViewOTDet();
                   getAvaiablitity();
                   getVisibility();
                   getCompetition();
                   getPlanogram();
                   getShareofshelf();
                  Addedstockdataforclient();
                  await getCompetition();
                  await clientpromodata();
                  setState(() {
                    isApiCallProcess = false;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder:
                              (BuildContextcontext) =>
                                  ClientsReports()));
                },
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.only(bottom:5.0,top: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${clientoutlets.outletname[index]}',
                            style: TextStyle(
                                fontSize: 14.0,fontWeight: FontWeight.bold
                            )),
                        SizedBox(height: 5),
                        Text('Date : ${clientoutlets.lastvisiteddate[index].toString()}'),
                        SizedBox(height: 5),
                        Text('Visit Type : ${clientoutlets.isschedulevisit[index].toString()== "1"? "Scheduled":"UnScheduled"}'),
                        SizedBox(height: 5),
                        Text('CheckIn Time : ${clientoutlets.checkintime[index].toString()}'),
                        SizedBox(height: 5),
                        Text('CheckOut Time : ${clientoutlets.checkouttime[index].toString()}'),
                        SizedBox(height: 5),
                        Text('Visited By : ${clientoutlets.merchandiserid[index].toString()}'),
                      ],
                    ))
            );
          }),
    );
  }

  Widget _performSearch() {
    _filterindex = [];
    for (int i = 0; i <clientoutlets.outletname.length; i++) {
      var item = clientoutlets.outletname[i];
      if (item.toLowerCase().contains(_query.toLowerCase())) {
        _filterindex.add(i);
      }
    }
    return _createFilteredListView();
  }

  Widget _createFilteredListView() {
    return new Flexible(
      child: new ListView.builder(
          shrinkWrap: true,
          itemCount: _filterindex.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: ()async{
                  setState(() {
                    isApiCallProcess = true;
                  });
                  indexclientselected = _filterindex[index];
                  currentoutletid = clientoutlets.outletid[_filterindex[index]];
                  currenttimesheetid = clientoutlets.timesheetid[_filterindex[index]];
                  FMViewOTDet();
                  getAvaiablitity();
                  getVisibility();
                  getCompetition();
                  getPlanogram();
                  getShareofshelf();
                  Addedstockdataforclient();
                  await getCompetition();
                  await clientpromodata();
                  setState(() {
                    isApiCallProcess = false;
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder:
                              (BuildContextcontext) =>
                              ClientsReports()));
                },
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsets.only(bottom:5.0,top: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${clientoutlets.outletname[_filterindex[index]]}',
                            style: TextStyle(
                                fontSize: 14.0,fontWeight: FontWeight.bold
                            )),
                        SizedBox(height: 5),
                        Text('Date : ${clientoutlets.lastvisiteddate[_filterindex[index]].toString()}'),
                        SizedBox(height: 5),
                        Text('Visit Type : ${clientoutlets.isschedulevisit[_filterindex[index]].toString()== "1"? "Scheduled":"UnScheduled"}'),
                        SizedBox(height: 5),
                        Text('Checkin time : ${clientoutlets.checkintime[_filterindex[index]].toString()}'),
                        SizedBox(height: 5),
                        Text('Checkout time : ${clientoutlets.checkouttime[_filterindex[index]].toString()}'),
                        SizedBox(height: 5),
                        Text('Visited by : ${clientoutlets.merchandiserid[_filterindex[index]].toString()}'),
                      ],
                    ))
            );
          }),
    );
  }
}
