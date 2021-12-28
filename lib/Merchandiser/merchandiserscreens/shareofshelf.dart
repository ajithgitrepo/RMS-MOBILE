import 'package:flutter/material.dart';
import '../../Constants.dart';
import 'package:flutter/cupertino.dart';
import '../../ProgressHUD.dart';
import 'Customers Activities.dart';
import 'MenuContent.dart';
import'package:merchandising/api/customer_activites_api/share_of_shelf_detailsapi.dart';
import'package:merchandising/api/customer_activites_api/add_shareofshelfapi.dart';

import 'package:merchandising/api/api_service.dart';



var shareindex;
var actualindex;
List <double> totalshare =[];
List <double> totalshelf =[];
List <double> actualpercent =[];
List<TextEditingController> share = [];
List<TextEditingController> total = [];
List<TextEditingController> actual = [];
List<TextEditingController> reasonforsos = [];

class ShareShelf extends StatefulWidget {
  @override
  _ShareShelfState createState() => _ShareShelfState();
}

class _ShareShelfState extends State<ShareShelf> {
  GlobalKey<FormState> soskey = GlobalKey<FormState>();
  List<String> productlist = ShareData.categoryname;

  List<String> target = ShareData.target;




  var _searchview = new TextEditingController();
  bool _firstSearch = true;
  String _query = "";
  List<String> productdata;
  List<String> _filterList;
  List<String> _filtertarget;
  List<int> _filterindex;
  List<TextEditingController> _filtershare = [];
  List<TextEditingController> _filtertotal = [];
  List<TextEditingController> _filteractual = [];


  @override
  void initState() {
    super.initState();
    productdata = productlist;
    productdata.sort();
  }

  _ShareShelfState() {

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
  bool isApicallProcess = false;
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
          automaticallyImplyLeading: false,
          backgroundColor: containerscolor,
          iconTheme: IconThemeData(color: orange),
          title: Row(
            children: [
              Text(
                'Share of Shelf',
                style: TextStyle(color: orange),
              ),
              Spacer(),
              SubmitButton(
                ontap: ()async{
                  if(validateform()==false) {
                    setState(() {
                      isApicallProcess = true;
                    });
                    AddShareData.totalshare = [];
                    AddShareData.share = [];
                    AddShareData.actualpercent = [];
                    AddShareData.actual = [];
                    AddShareData.reason = [];
                    for (int i = 0; i < ShareData.categoryname.length; i++) {
                      AddShareData.totalshare.add(total[i].text);
                      AddShareData.share.add(share[i].text);
                      AddShareData.actual.add(actual[i].text);
                      AddShareData.actualpercent.add(
                          actualpercent[i].toStringAsFixed(2));
                      AddShareData.reason.add(reasonforsos[i].text);
                    }
                    //AddShareData.brandid = ShareData.brandid;
                    // AddShareData.outletid = outletrequestdata.outletidpressed;
                    // AddShareData.timesheetid = checkinoutdata.checkid;
                    AddShareData.categoryname = ShareData.categoryname;
                    AddShareData.categoryid = ShareData.categoryid;
                    AddShareData.target = ShareData.target;
                    AddShareData.totalshare = AddShareData.share;
                    AddShareData.actualpercent = AddShareData.actualpercent;
                    AddShareData.share = AddShareData.actual;
                    await addShareofshelfdata();
                    // shareofshelfcheck = true;
                    setState(() {
                      isApicallProcess = false;
                    });
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => CustomerActivities()));
                  }
                },
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
                inAsyncCall: isApicallProcess,
                child: new Column(
                  children: <Widget>[
                    SizedBox(
                      height: onlinemode.value ?0:25,
                    ),
                    OutletDetails(),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.0,0,10,0),
                      child: _createSearchView(),
                    ),
                    _firstSearch ? _createListView() : _performSearch(),
                  ],
                ),
              ),
              NBlFloatingButton(),

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
          borderRadius: BorderRadius.circular(25.0)),
      child: new TextField(
        style: TextStyle(color: orange),
        controller: _searchview,
        cursorColor:orange,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          focusColor: orange,
          hintText: 'Search by category name',
          hintStyle: TextStyle(color: orange),
          border: InputBorder.none,
          icon: Icon(CupertinoIcons.search,color: orange,),
          isCollapsed: true,
        ),
      ),
    );
  }
  Widget _createListView() {
    return Expanded(
      //height: MediaQuery.of(context).size.height/1.4,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10,0),
        child: new Form(
          key: soskey,
          child: ListView.builder(
             //physics: NeverScrollableScrollPhysics(),
              //shrinkWrap: true,
              itemCount:target.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width:double.infinity,
                  margin: EdgeInsets.only(top:5.0,bottom: 5.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: pink,
                  ),

                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,


                    children: [
                      Text('${ShareData.categoryname[index]}',
                          style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold,color: orange
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(height: 10,),
                          Text("Target: ${target[index]} %",style: TextStyle(
                              fontSize: 15.0
                          )),
                          /*Container(
                            decoration: BoxDecoration(
                              color:Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.all(10.0),
                            margin:EdgeInsets.only(top:10.0),
                            child: Center(
                              child: Center(
                                child: TextFormField(
                                  onChanged: (value){
                                    totalshelf[index]=double.parse(value);
                                    // ignore: unrelated_type_equality_check
                                  },
                                  keyboardType:
                                  TextInputType.number,

                                  controller: total[index],
                                  cursorColor: grey,
                                  validator: (input) => !input
                                      .isNotEmpty
                                      ? "Total should not be empty"
                                      : null,
                                  decoration:
                                  new InputDecoration(
                                    //contentPadding: ,
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                    focusColor: orange,
                                    hintText: "Total in meters",
                                    hintStyle: TextStyle(
                                      color: grey,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),*/


                          Container(
                            decoration: BoxDecoration(
                              color:Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.all(10.0),
                            margin:EdgeInsets.only(top:10.0),
                            child: Center(
                              child: Center(
                                child: TextFormField(

                                  onChanged: (value){
                                    setState(() {
                                      shareindex=totalshare[index];
                                      totalshare[index]=double.parse(value);
                                    });
                                  },
                                  keyboardType:
                                  TextInputType.number,

                                  controller: share[index],
                                  cursorColor: grey,
                                  validator: (input) => !input
                                      .isNotEmpty
                                      ? "Share should not be empty"
                                      : null,
                                  decoration:
                                  new InputDecoration(
                                    //contentPadding: ,
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                    focusColor: orange,
                                    hintText: "Share in meters",
                                    hintStyle: TextStyle(
                                      color: grey,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          totalshare[index] == 0.0 ?SizedBox():Container(
                            decoration: BoxDecoration(
                              color:Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.all(10.0),
                            margin:EdgeInsets.only(top:10.0),
                            child: Center(
                              child: Center(
                                child: TextFormField(
                                  onChanged: (value){
                                    // ignore: unrelated_type_equality_checks
                                    if(double.parse(value) <= double.parse(share[index].text)){
                                      setState(() {
                                        actualpercent[index] = (double.parse(value)/double.parse(share[index].text))*100;
                                      });
                                    }else{
                                      setState(() {
                                        actualpercent[index] = 101;
                                      });
                                    }
                                  },
                                  keyboardType:
                                  TextInputType.number,

                                  controller: actual[index],
                                  cursorColor: grey,
                                  validator: (input) => !input
                                      .isNotEmpty
                                      ? "actual should not be empty"
                                      : null,
                                  decoration:
                                  new InputDecoration(
                                    //contentPadding: ,
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                    focusColor: orange,
                                    hintText: "Actual in meters",
                                    hintStyle: TextStyle(
                                      color: grey,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 10),
                          actualpercent[index]<100?Text("Actual Percent: ${actualpercent[index].toStringAsFixed(2)}%",style: TextStyle(color: double.parse(target[index])> actualpercent[index]?Colors.red:Colors.green),):

                          actualpercent[index] == 101 ?Text("Actual Percent : actual cannot be greater than share",style: TextStyle(color: Colors.red),):Text("Actual Percent : "
                              "${actualpercent[index].toStringAsFixed(2)}%",style: TextStyle(color: Colors.green),),

                          double.parse(target[index])> actualpercent[index] && actualpercent[index]!=0.0?Container(
                            decoration: BoxDecoration(
                              color:Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.all(10.0),
                            margin:EdgeInsets.only(top:10.0),
                            child: Center(
                              child: Center(
                                child: TextFormField(
                                  keyboardType:
                                  TextInputType.text,

                                  controller: reasonforsos[index],
                                  cursorColor: grey,
                                  validator: (input) => !input
                                      .isNotEmpty
                                      ? "reason should not be empty"
                                      : null,
                                  decoration:
                                  new InputDecoration(
                                    //contentPadding: ,
                                    isCollapsed: true,
                                    border: InputBorder.none,
                                    focusColor: orange,
                                    hintText: "Enter Your Reason",
                                    hintStyle: TextStyle(
                                      color: grey,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ):SizedBox()
                        ],
                      ),
                    ],
                  ),

                );
              }),
        ),
      ),
    );
  }

  Widget _performSearch() {
    _filterList = [];
    _filtertotal = [];
    _filtertarget = [];
    _filteractual = [];
    _filtershare = [];
    _filterindex = [];

    for (int i = 0; i <ShareData.categoryname.length; i++) {
      var item = ShareData.categoryname[i];
      if (item.toLowerCase().contains(_query.toLowerCase())) {
        _filterList.add(item);
        _filterindex.add(i);

        int index = ShareData.categoryname.indexOf(item);
        _filtertotal.add(total[index]);
        _filtertarget.add(target[index]);
        _filteractual.add(actual[index]);
        _filtershare.add(share[index]);
        _filtershare.add(share[index]);



      }
    }
    return _createFilteredListView();
  }

  Widget _createFilteredListView() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10,0),
        child: new ListView.builder(
            //physics: NeverScrollableScrollPhysics(),
            //shrinkWrap: true,
            itemCount:_filterList.length,
            itemBuilder: (BuildContext context, int index) {
              _filtertotal.add(TextEditingController());
              _filtershare.add(TextEditingController());
              _filteractual.add(TextEditingController());
              return Container(
                width:double.infinity,
                margin: EdgeInsets.only(top:10.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: pink,
                ),
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                    Text('Category :${_filterList[index]}',
                        style: TextStyle(fontSize: 17.0,fontWeight: FontWeight.bold,color: orange
                        )),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(height: 10,),
                        Text("Target: ${_filtertarget[index]} %",style: TextStyle(
                            fontSize: 15.0
                        )),
                        Container(
                          decoration: BoxDecoration(
                            color:Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(10.0),
                          margin:EdgeInsets.only(top:10.0),
                          child: Center(
                            child: Center(
                              child: TextFormField(
                                onChanged: (value){
                                  setState(() {
                                    totalshare[index]=double.parse(value);
                                  });
                                },
                                keyboardType:
                                TextInputType.number,

                                controller: _filtershare[index],
                                cursorColor: grey,
                                validator: (input) => !input
                                    .isNotEmpty
                                    ? "Share should not be empty"
                                    : null,
                                decoration:
                                new InputDecoration(
                                  //contentPadding: ,
                                  isCollapsed: true,
                                  border: InputBorder.none,
                                  focusColor: orange,
                                  hintText: "Share in meters",
                                  hintStyle: TextStyle(
                                    color: grey,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),


                        totalshare[index] == 0.0 ?SizedBox():Container(
                          decoration: BoxDecoration(
                            color:Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(10.0),
                          margin:EdgeInsets.only(top:10.0),
                          child: Center(
                            child: Center(
                              child: TextFormField(
                                onChanged: (value){
                                  // ignore: unrelated_type_equality_checks
                                  if(double.parse(value) <= double.parse(_filteractual[index].text)){
                                    setState(() {
                                      actualpercent[index] = (double.parse(value)/double.parse(_filteractual[index].text))*100;
                                    });
                                  }else{
                                    setState(() {
                                      actualpercent[index] = 101;
                                    });
                                  }
                                },
                                keyboardType:
                                TextInputType.number,

                                controller: _filteractual[index],
                                cursorColor: grey,
                                validator: (input) => !input
                                    .isNotEmpty
                                    ? "actual should not be empty"
                                    : null,
                                decoration:
                                new InputDecoration(
                                  //contentPadding: ,
                                  isCollapsed: true,
                                  border: InputBorder.none,
                                  focusColor: orange,
                                  hintText: "Actual in meters",
                                  hintStyle: TextStyle(
                                    color: grey,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10),
                        actualpercent[_filterindex[index]]<100?Text("Actual Percent: ${actualpercent[_filterindex[index]].toStringAsFixed(2)}%",style: TextStyle(color: Colors.red),):

                        actualpercent[_filterindex[index]] == 101 ?Text("Actual Percent : actual cannot be greater than share",style: TextStyle(color: Colors.red),):Text("Actual Percent : "
                            "${actualpercent[_filterindex[index]].toStringAsFixed(2)}%",style: TextStyle(color: Colors.green),),


                        double.parse(target[_filterindex[index]])> actualpercent[_filterindex[index]] && actualpercent[_filterindex[index]]!=0.0?Container(
                          decoration: BoxDecoration(
                            color:Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.all(10.0),
                          margin:EdgeInsets.only(top:10.0),
                          child: Center(
                            child: Center(
                              child: TextFormField(
                                keyboardType:
                                TextInputType.text,

                                controller: reasonforsos[_filterindex[index]],
                                cursorColor: grey,
                                validator: (input) => !input
                                    .isNotEmpty
                                    ? "reason should not be empty"
                                    : null,
                                decoration:
                                new InputDecoration(
                                  //contentPadding: ,
                                  isCollapsed: true,
                                  border: InputBorder.none,
                                  focusColor: orange,
                                  hintText: "Enter Your Reason",
                                  hintStyle: TextStyle(
                                    color: grey,
                                    fontSize: 16.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ):SizedBox()
                      ],
                    ),
                  ],
                ),

              );
            }),
      ),
    );
  }
  bool validateform() {
    final form = soskey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}






class SubmitButton extends StatelessWidget {
  SubmitButton({this.ontap});
  final ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:ontap,
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
    );
  }
}

