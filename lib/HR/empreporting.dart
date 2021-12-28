import 'package:merchandising/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/MenuContent.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:merchandising/HR/addreport.dart';
import 'package:merchandising/api/HRapi/empdetailsforreportapi.dart';


class Reportingemp extends StatefulWidget {
  @override
  _ReportingempState createState() => _ReportingempState();
}

class _ReportingempState extends State<Reportingemp> {
  var _searchview = new TextEditingController();
  bool _firstSearch = true;
  String _query = "";
  List<dynamic> inputlist;
  List<String> _filterList;
  List<String> _filterreportingList;
  List<String> _filterstartList;
  List<String> _filterendList;
  @override
  void initState() {
    super.initState();
    inputlist =  reporting.merchandisers;
  }

  _ReportingempState() {

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
    return GestureDetector(
      onTap: (){
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: pink,
          iconTheme: IconThemeData(color: orange),
          title: Text("Reporting",style: TextStyle(color: orange),),
        ),
        drawer: Drawer(
          child: Menu(),
        ),
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
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.all(15.0),
                child: FloatingActionButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext
                            context) =>
                                addreporting()));
                  },
                  backgroundColor: pink,
                  elevation: 8.0,
                  child: Icon(Icons.add,color: orange,),
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
      child: new ListView.builder(
          itemCount: reporting.merchandisers.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 130,
              margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: AutoSizeText(reporting.merchandisers[index],
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('reporting to:',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text(reporting.feildmanager[index],
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Start Date :',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text(reporting.startdate[index],
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('End Date :',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text('${reporting.enddate[index]}',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                    ],
                  ),
                ],
              ),
            );
          }
      ),
    );
  }

  Widget _performSearch() {
    _filterList = [];
    _filterendList =[];
    _filterstartList =[];
    _filterreportingList=[];
    for (int i = 0; i <reporting.merchandisers.length; i++) {
      var item = reporting.merchandisers[i];
      if (item.toLowerCase().contains(_query.toLowerCase())) {
        _filterList.add(item);
        int index = reporting.merchandisers.indexOf(item);
        _filterreportingList.add(reporting.feildmanager[index]);
        _filterstartList.add(reporting.startdate[index]);
        _filterendList.add(reporting.enddate[index]);
      }
    }
    return _createFilteredListView();
  }

  Widget _createFilteredListView() {
    return new Flexible(
      child: new ListView.builder(
          itemCount: _filterList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 120,
              margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: AutoSizeText(_filterList[index],
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('reporting to:',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text(_filterreportingList[index],
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Start Date :',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text(_filterstartList[index],
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('End Date :',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text('${_filterendList[index]}',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                    ],
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}


