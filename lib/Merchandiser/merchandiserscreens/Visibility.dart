import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import '../../Constants.dart';
import 'Customers Activities.dart';
import 'package:merchandising/api/api_service.dart';
import 'MenuContent.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:merchandising/ProgressHUD.dart';
import 'package:merchandising/model/camera.dart';
import 'package:camera/camera.dart';
import 'package:photo_view/photo_view.dart';
import 'package:merchandising/api/customer_activites_api/visibilityapi.dart';
import 'package:merchandising/api/customer_activites_api/add_visibilityapi.dart';
import 'dart:convert';
int num=0;
bool txtctrl = false;
List<List<String>> addGarea;
List<List<String>> addmainaisle;
List<List<String>> addpois;
class selected {
  static int index;
}
List<int>checkvaluevisibility =[];
List<String> listitems = VisibilityData.categoryname;
List<File> images = [];
// List<String>addGarea=[];
List<String>addMain=[];
List<String>addPOI=[];
class VisibilityOne extends StatefulWidget {
  @override
  _VisibilityOneState createState() => _VisibilityOneState();
}

class _VisibilityOneState extends State<VisibilityOne> {
  var _searchview = new TextEditingController();
  List<TextEditingController> gareatextfeild = [];
  List<TextEditingController> mainaisletextfeild = [];
  List<TextEditingController> poistextfeild = [];

  bool _firstSearch = true;
  String _query = "";
  List<String> _filterList;
  List<int> _filterindex;
  List<TextEditingController> _filtergareatextfeild = [];
  List<TextEditingController> _filtermainaisletextfeild = [];
  List<TextEditingController> _filterpoistextfeild = [];
  @override
  void initState() {
    super.initState();
    listitems.sort();
  }

  _VisibilityOneState() {
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
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: containerscolor,
        iconTheme: IconThemeData(color: orange),
        title: Row(
          children: [
            new Text(
              "Visibility",
              style: TextStyle(color: orange),
            ),
            Spacer(),
            GestureDetector(
              onTap: () async {
                setState(() {
                  isApiCallProcess = true;
                });
                AddVisiData.categoryid = VisibilityData.categoryid;
                AddVisiData.categoryname=VisibilityData.categoryname;
                AddVisiData.outletid = outletrequestdata.outletidpressed;
                AddVisiData.timesheetid = checkinoutdata.checkid;
                AddVisiData.reason = visibilityreasons;
                AddVisiData.outletpdtmap = VisibilityData.mappingid;
                AddVisiData.checkvalue = checkvaluevisibility;
                AddVisiData.area=[];
                AddVisiData.sos=[];
                AddVisiData.poi=[];
                print(addGarea);
                for(int i=0;i<addGarea.length;i++) {
                  print(i);
                  print("addarea");
                  print(addGarea[i]);
                  List<String>temparea = addGarea[i];
                  List<String>tempmain = addmainaisle[i];
                  List<String>temppois = addpois[i];
                  if (temparea.length > 0) {
                    String area = temparea[0];
                    String main = tempmain[0];
                    String pois = temppois[0];
                    for (int u = 1; u < temparea.length; u++) {
                      area = "$area,${temparea[u]}";
                      main = "$main,${tempmain[u]}";
                      pois = "$pois,${temppois[u]}";
                    }
                    AddVisiData.area.add(area);
                    AddVisiData.sos.add(main);
                    AddVisiData.poi.add(pois);
                  }else{
                    AddVisiData.area.add("");
                    AddVisiData.sos.add("");
                    AddVisiData.poi.add("");
                  }
                }
                // visibilitycheck = true;
                await addVisibilitydata();
                setState(() {
                  isApiCallProcess =false;
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => CustomerActivities()));
              },
              child: Container(
                margin: EdgeInsets.only(right: 10.00),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Color(0xffFFDBC1),
                  borderRadius: BorderRadius.circular(10.00),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
      // drawer: Drawer(
      //   child: Menu(),
      // ),
      body: OfflineNotification(
        body: Stack(
          children: [
            BackGround(),
            ProgressHUD(
              opacity: 0.3,
              inAsyncCall: isApiCallProcess,
              child: Column(
                children: [
                  SizedBox(
                    height: onlinemode.value ?0:25,
                  ),
                  OutletDetails(),
                  Expanded(
                    child: Container(
                      child: new Column(
                        children: <Widget>[
                          _createSearchView(),
                          _firstSearch ? _createListView() : _performSearch()
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            NBlFloatingButton(),
          ],
        ),
      ),
    );
  }

  Widget _createSearchView() {
    return new Container(
      margin: EdgeInsets.fromLTRB(10.0, 0, 10, 0),
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: new TextField(
              style: TextStyle(color: orange),
              controller: _searchview,
              cursorColor: orange,
              decoration: InputDecoration(
                isCollapsed: true,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                focusColor: orange,
                hintText: 'Search by Category Name',
                hintStyle: TextStyle(color: orange),
                border: InputBorder.none,
                icon: Icon(
                  CupertinoIcons.search,
                  color: orange,
                ),
              ),
            ),
          ),
          GestureDetector(
              onTap: () {
                _searchview.clear();
              },
              child: Icon(
                CupertinoIcons.clear_circled_solid,
                color: orange,
              ))
        ],
      ),
    );
  }

  Widget _createListView() {
    return new Flexible(
      child: new ListView.builder(
          shrinkWrap: true,
          itemCount: VisibilityData.categoryname.length,
          itemBuilder: (BuildContext context, int index) {
            gareatextfeild.add(TextEditingController());
            mainaisletextfeild.add(TextEditingController());
            poistextfeild.add(TextEditingController());
            return Container(
              padding: EdgeInsets.all(5.0),
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: pink, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width/1.7,
                            child: new Text(
                              "${VisibilityData.categoryname[index]}",
                                style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold,color: orange
                                )
                            ),
                          ),
                          SizedBox(height: 10),
                          VisibilitySwitchOne(
                            indexrunning: index,
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                        children: [
                          //SizedBox(height: 30),
                          IconButton(
                            icon: Icon(
                              CupertinoIcons.photo_camera_solid,
                              size: 30,
                            ),
                            onPressed: () {
                              Selectedscreen ="visibility";
                              selected.index = index;
                              _showSelectionDialog(context);
                              /*Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext context) => OpenCamera()));*/
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom:5.0,left: 10.0),
                    child: Text("Add number of Stand off Shelf",style: TextStyle(color: orange,fontSize: 15),),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Table(
                          columnWidths: {
                            0: FractionColumnWidth(.28),
                            1: FractionColumnWidth(.28),
                            2: FractionColumnWidth(.28),
                            3: FractionColumnWidth(.2),
                          },
                          children: [
                            TableRow(
                              children: [
                                Text("Area",textAlign: TextAlign.center,style: TextStyle(color: orange,fontWeight: FontWeight.bold,fontSize: 15),),
                                Text("SOS'S",textAlign: TextAlign.center,style: TextStyle(color: orange,fontWeight: FontWeight.bold,fontSize: 15),),
                                Text("POI'S",textAlign: TextAlign.center,style: TextStyle(color: orange,fontWeight: FontWeight.bold,fontSize: 15),),
                                SizedBox()
                              ]
                            ),
                            TableRow(
                                children: [
                                  ListView.builder(
                                      key: UniqueKey(),
                                      shrinkWrap: true,
                                      itemCount:  addGarea[index].length,
                                      itemBuilder: (BuildContext context, int i) {
                                        List<String>area=addGarea[index];
                                        return Column(
                                          //crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 8),
                                                child: Text(area[i]==null?"":area[i],textAlign: TextAlign.center,)),
                                          ],
                                        );
                                      }),
                                  ListView.builder(
                                      key: UniqueKey(),
                                      shrinkWrap: true,
                                      itemCount:  addmainaisle[index].length,
                                      itemBuilder: (BuildContext context, int i) {
                                        List<String>main=addmainaisle[index];
                                        return Column(
                                         // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(top: 8),
                                              child: Text(main[i]==null?"":main[i],textAlign: TextAlign.center,),
                                            ),
                                          ],
                                        );
                                      }),
                                  ListView.builder(
                                      key: UniqueKey(),
                                      shrinkWrap: true,
                                      itemCount:  addpois[index].length,
                                      itemBuilder: (BuildContext context, int i) {
                                        List<String>poi=addpois[index];
                                        return Column(
                                         // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top:8.0),
                                              child: Text(poi[i]==null?"":poi[i],textAlign: TextAlign.center,),
                                            ),
                                          ],
                                        );
                                      }),
                                  ListView.builder(
                                      key: UniqueKey(),
                                      shrinkWrap: true,
                                      itemCount:  addpois[index].length,
                                      itemBuilder: (BuildContext context, int i) {
                                        return Column(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                              onTap: (){
                                                List<String>area=addGarea[index];
                                                List<String>mainasile=addmainaisle[index];
                                                List<String>pois=addpois[index];
                                                setState(() {
                                                  area.removeAt(i);
                                                  mainasile.removeAt(i);
                                                  pois.removeAt(i);
                                                });
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(top:8,right: 10),
                                                child: Icon(
                                                  CupertinoIcons.delete,
                                                  size: 17,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                ]
                            ),
                            TableRow(
                              children: [
                                Container(
                                  width:MediaQuery.of(context).size.width/5,
                                  margin:EdgeInsets.all(10.0),
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,borderRadius: BorderRadius.circular(10.0)
                                  ),

                                  child: TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: gareatextfeild[index],
                                    cursorColor: grey,
                                    textAlign: TextAlign. center,
                                    validator: (input) => !input
                                        .isNotEmpty
                                        ? "g-area should not be empty"
                                        : null,
                                    decoration:
                                    new InputDecoration(
                                      isCollapsed: true,
                                      border: InputBorder.none,
                                      focusColor: orange,
                                      hintText: "G-Area",
                                      hintStyle: TextStyle(
                                        color: grey,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:MediaQuery.of(context).size.width/5,
                                  margin:EdgeInsets.all(10.0),
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,borderRadius: BorderRadius.circular(10.0)
                                  ),

                                  child: TextFormField(
                                    textAlign: TextAlign. center,
                                    keyboardType: TextInputType.number,
                                    controller: mainaisletextfeild[index],
                                    cursorColor: grey,
                                    validator: (input) => !input
                                        .isNotEmpty
                                        ? "main_aisle should not be empty"
                                        : null,
                                    decoration:
                                    new InputDecoration(
                                      //contentPadding: ,
                                      isCollapsed: true,
                                      border: InputBorder.none,
                                      focusColor: orange,
                                      hintText: "sos",
                                      hintStyle: TextStyle(
                                        color: grey,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width:MediaQuery.of(context).size.width/5,
                                  margin:EdgeInsets.all(10.0),
                                  padding: EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,borderRadius: BorderRadius.circular(10.0)
                                  ),

                                  child: TextFormField(
                                   // enabled: addpoibool[index],
                                    textAlign: TextAlign. center,
                                    keyboardType: TextInputType.number,
                                    controller: poistextfeild[index],
                                    cursorColor: grey,
                                    validator: (input) => !input
                                        .isNotEmpty
                                        ? "pois should not be empty"
                                        : null,
                                    decoration:
                                    new InputDecoration(
                                      //contentPadding: ,
                                      isCollapsed: true,
                                      border: InputBorder.none,
                                      focusColor: orange,
                                      hintText: "POI",
                                      hintStyle: TextStyle(
                                        color: grey,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    // addGarea=[];
                                    // addMain=[];
                                    // addPOI=[];
                                    if(gareatextfeild[index].text != null){
                                      setState(() {
                                        addGarea[index].add(gareatextfeild[index].text);
                                        addmainaisle[index].add(mainaisletextfeild[index].text);
                                        addpois[index].add(poistextfeild[index].text);
                                        gareatextfeild[index].clear();
                                        mainaisletextfeild[index].clear();
                                        poistextfeild[index].clear();
                                      });
                                    }

                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right:10.0,top: 18.0),
                                    child: Icon(
                                      CupertinoIcons.add_circled,
                                      size: 20,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              ]
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }

  Widget _performSearch() {
    _filterList = [];
    _filterindex=[];
    _filtergareatextfeild=[];
    _filtermainaisletextfeild=[];
    _filterpoistextfeild=[];

    for (int i = 0; i < VisibilityData.categoryname.length; i++) {
      var item = VisibilityData.categoryname[i];

      if (item.toLowerCase().contains(_query.toLowerCase())) {
        _filterList.add(item);
        _filterindex.add(i);
        int index = VisibilityData.categoryname.indexOf(item);
        _filtergareatextfeild.add(gareatextfeild[index]);
        _filtermainaisletextfeild.add(mainaisletextfeild[index]);
        _filterpoistextfeild.add(poistextfeild[index]);
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
            return new Container(
              padding: EdgeInsets.all(10.00),
              margin: EdgeInsets.only(top: 10, right: 10, left: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: pink, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width/1.7,
                            child: new Text(
                              "Category: ${_filterList[index]}",
                                style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold,color: orange
                                )
                            ),
                          ),
                          SizedBox(height: 10),
                          VisibilitySwitchOne(
                            indexrunning: _filterindex[index],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          CupertinoIcons.photo_camera_solid,
                          size: 30,
                        ),
                        onPressed: () {
                          Selectedscreen ="visibility";
                          selected.index = _filterindex[index];
                          _showSelectionDialog(context);
                          /*Navigator.push(context,
                                  MaterialPageRoute(builder: (BuildContext context) => OpenCamera()));*/
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom:5.0,left: 10.0),
                    child: Text("Add number of Stand off Shelf's :",style: TextStyle(color: orange,fontSize: 15),),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Table(
                          children: [
                            TableRow(
                                children: [
                                  Text("G Area",textAlign: TextAlign.center,style: TextStyle(color: orange,fontWeight: FontWeight.bold,fontSize: 15),),
                                  Text("Main Asile",textAlign: TextAlign.center,style: TextStyle(color: orange,fontWeight: FontWeight.bold,fontSize: 15),),
                                  Text("POI'S",textAlign: TextAlign.center,style: TextStyle(color: orange,fontWeight: FontWeight.bold,fontSize: 15),)
                                ]
                            ),
                            TableRow(
                                children: [
                                  Text("G Area",textAlign: TextAlign.center,style: TextStyle(color: orange,fontWeight: FontWeight.bold,fontSize: 15),),
                                  Text("Main Asile",textAlign: TextAlign.center,style: TextStyle(color: orange,fontWeight: FontWeight.bold,fontSize: 15),),
                                  Text("POI'S",textAlign: TextAlign.center,style: TextStyle(color: orange,fontWeight: FontWeight.bold,fontSize: 15),)

                                  // Text(gareadata[_filterindex[index]]==null?"":gareadata[_filterindex[index]],textAlign: TextAlign.center,),
                                  // Text(mainasiledata[_filterindex[index]]==null?"":mainasiledata[_filterindex[index]],textAlign: TextAlign.center),
                                  // Text(poidata[_filterindex[index]]==null?"":poidata[_filterindex[index]],textAlign: TextAlign.center)
                                ]
                            ),
                            TableRow(
                                children: [
                                  Container(
                                    width:MediaQuery.of(context).size.width/5,
                                    margin:EdgeInsets.all(10.0),
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,borderRadius: BorderRadius.circular(10.0)
                                    ),

                                    child: TextFormField(

                                      keyboardType: TextInputType.number,
                                      controller: gareatextfeild[_filterindex[index]],
                                      cursorColor: grey,
                                      textAlign: TextAlign. center,
                                      validator: (input) => !input
                                          .isNotEmpty
                                          ? "g-area should not be empty"
                                          : null,
                                      decoration:
                                      new InputDecoration(
                                        isCollapsed: true,
                                        border: InputBorder.none,
                                        focusColor: orange,
                                        hintText: "G Area",
                                        hintStyle: TextStyle(
                                          color: grey,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:MediaQuery.of(context).size.width/5,
                                    margin:EdgeInsets.all(10.0),
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,borderRadius: BorderRadius.circular(10.0)
                                    ),

                                    child: TextFormField(
                                      textAlign: TextAlign. center,
                                      keyboardType: TextInputType.number,
                                      controller: mainaisletextfeild[_filterindex[index]],
                                      cursorColor: grey,
                                      validator: (input) => !input
                                          .isNotEmpty
                                          ? "main_aisle should not be empty"
                                          : null,
                                      decoration:
                                      new InputDecoration(
                                        //contentPadding: ,
                                        isCollapsed: true,
                                        border: InputBorder.none,
                                        focusColor: orange,
                                        hintText: "Main Aisle",
                                        hintStyle: TextStyle(
                                          color: grey,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width:MediaQuery.of(context).size.width/5,
                                    margin:EdgeInsets.all(10.0),
                                    padding: EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,borderRadius: BorderRadius.circular(10.0)
                                    ),

                                    child: TextFormField(
                                     // enabled: addpoibool[index],
                                      textAlign: TextAlign. center,
                                      keyboardType: TextInputType.number,
                                      controller: poistextfeild[_filterindex[index]],
                                      cursorColor: grey,
                                      validator: (input) => !input
                                          .isNotEmpty
                                          ? "pois should not be empty"
                                          : null,
                                      decoration:
                                      new InputDecoration(
                                        //contentPadding: ,
                                        isCollapsed: true,
                                        border: InputBorder.none,
                                        focusColor: orange,
                                        hintText: "POI",
                                        hintStyle: TextStyle(
                                          color: grey,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]
                            )
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                //addGarea[index[_filterindex[index]]="";
                                addMain[_filterindex[index]]="";
                                addPOI[_filterindex[index]]="";
                                addpoibool[_filterindex[index]] = true;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right:10.0,bottom: 25.0),
                              child: Icon(
                                CupertinoIcons.delete,
                                size: 20,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              if(gareatextfeild.isNotEmpty){

                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right:10.0,bottom: 18.0),
                              child: Icon(
                                CupertinoIcons.add_circled,
                                size: 20,
                                color: orange,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
bool isSwitchedVisi = false;
class VisibilitySwitchOne extends StatefulWidget {
  final int indexrunning;

  VisibilitySwitchOne({@required this.indexrunning});
  @override
  _VisibilitySwitchOneState createState() => _VisibilitySwitchOneState();
}

class _VisibilitySwitchOneState extends State<VisibilitySwitchOne> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 10,
          ),
          SizedBox(
            height: 80,
            child: Column(
              children: [
                Text(
                  "Is Available",
                  style: TextStyle(fontSize: 15),
                ),
                Switch(
                  value: checkvaluevisibility[widget.indexrunning]==0?true:false,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedVisi = value;
                      isSwitchedVisi == true ? checkvaluevisibility[widget.indexrunning] = 0  : checkvaluevisibility[widget.indexrunning]=1;
                      images[widget.indexrunning] =File('dummy.txt');
                      print(checkvaluevisibility);
                    });
                  },
                  inactiveTrackColor: orange,
                  activeColor: Colors.red,
                ),
              ],
            ),
          ),
          Spacer(),
          SizedBox(
            height: 88,
            child: Column(
              children: [
                Text(
                  checkvaluevisibility[widget.indexrunning]==0 ? "Reason" : "Capture Image",
                  style: TextStyle(fontSize: 15),
                ),
                checkvaluevisibility[widget.indexrunning]==0
                    ? ReasonDropdown(
                  item: widget.indexrunning,
                )
                    : Container(
                        margin: EdgeInsets.all(10),
                        child:
                            // ignore: unrelated_type_equality_checks
                            images[widget.indexrunning].toString() !=
                                    'File: \'dummy.txt\''
                                ? GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  PreveiwScreen(
                                                    input: widget.indexrunning,
                                                  )));
                                    },
                                    child: Image(
                                      height: 50,
                                      width: 50,
                                      image: FileImage(
                                          images[widget.indexrunning]),
                                    ),
                                  )
                                : Image(
                                    width: 50,
                                    image: AssetImage('images/capture.png'),
                                  ),
                      ),
              ],
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
List<String>visibilityreasons=[];
class ReasonDropdown extends StatefulWidget {
  ReasonDropdown({this.item});
  final item;
  @override
  _ReasonDropdownState createState() => _ReasonDropdownState();
}

List listofreasons =  ["Item Expired","Pending Delivery","Out Of Stock"].map((String val) {return new DropdownMenuItem<String>(value: val, child: new Text(val),);}).toList();
var selectedreason;

class _ReasonDropdownState extends State<ReasonDropdown> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:8.0),
      child: SizedBox(
        height: 50,
        width: 100,
        child: DropdownButton(
          elevation: 0,
          underline: SizedBox(),
          dropdownColor: Colors.white,
          isExpanded: true,
          iconEnabledColor: orange,
          iconSize: 35.0,
          value: visibilityreasons[widget.item] == "" ?null:visibilityreasons[widget.item],
          onChanged: (newVal){
            setState(() {
              selectedreason = newVal;
              visibilityreasons[widget.item]=newVal;
              print(visibilityreasons);
            });
            },
          items: listofreasons,
          hint: Text("Select Reason",style: TextStyle(color: Colors.black,fontSize: 14),),
        ),
      ),
    );
  }
}



Future<void> _showSelectionDialog(BuildContext context) {
  FilePickerResult _file;
  Future getFile() async {
    FilePickerResult file = await FilePicker.platform.pickFiles();
    _file = file;
    return _file;
  }

  return showModalBottomSheet(
      context: context,
      builder: (builder) {
        return new Container(
          height: 180,
          color: Colors.transparent, //could change this to Color(0xFF737373),
          //so you don't have to change MaterialApp canvasColor
          child: new Container(
              padding: EdgeInsets.all(10.0),
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "From where do you want to take the photo?",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      WidgetsFlutterBinding.ensureInitialized();

                      // Obtain a list of the available cameras on the device.
                      final cameras = await availableCameras();

                      // Get a specific camera from the list of available cameras.
                      final firstCamera = cameras.first;
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  TakePictureScreen(
                                  )));
                    },
                    child: Container(
                      color: Colors.white,
                      height: 50,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.camera_fill,
                            size: 40,
                            color: orange,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Camera",
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      FilePickerResult picked = await getFile();
                      if (picked != null) {
                        File file = File(picked.files.single.path);
                        images[selected.index] = file;
                        var imagebytes = file.readAsBytesSync();
                        visibilityreasons[selected.index] = 'data:image/jpeg;base64,${base64Encode(imagebytes)}';
                        print(visibilityreasons);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    VisibilityOne()));
                      }
                    },
                    child: Container(
                      color: Colors.white,
                      height: 50,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.doc_circle_fill,
                            size: 40,
                            color: orange,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text("File Explorer"),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    "Note* If you select File Explorer you have to select the images that contain watermark of date and time ",
                    style: TextStyle(
                      fontSize: 12,
                      color: orange,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              )),
        );
      });
}

class PreveiwScreen extends StatelessWidget {
  PreveiwScreen({@required this.input});
  int input;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          GestureDetector(
            onVerticalDragEnd: (details) {
              Navigator.pop(context);
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: PhotoView(
                  loadingBuilder: (context, event) => Center(
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          child: CircularProgressIndicator(
                            backgroundColor: orange,
                          ),
                        ),
                      ),
                  imageProvider: FileImage(images[input])),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: FloatingActionButton(
                backgroundColor: pink,
                child: Icon(Icons.check,size: 35,color: orange),
                onPressed:(){
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => VisibilityOne()));
                }
              ),
            ),
          )
        ],
      ),
    );
  }
}


class VeiwImage extends StatelessWidget {
  VeiwImage({this.url});
  var url;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PhotoView(
          loadingBuilder: (context, event) => Center(
            child: Container(
              width: 40.0,
              height: 40.0,
              child: CircularProgressIndicator(
              ),
            ),
          ),
          imageProvider: NetworkImage(
            url,
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left :15.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: FloatingActionButton(
                onPressed: (){
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              VisibilityOne()));
                },
                backgroundColor: Colors.black,
                child: Icon(Icons.arrow_back,color: orange,),
              ),
            ),
          ),
        )
      ],
    );
  }
}


List<bool>addpoibool=[];
