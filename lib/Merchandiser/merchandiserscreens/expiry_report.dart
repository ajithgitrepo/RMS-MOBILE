import 'package:flutter/painting.dart';
import 'package:merchandising/api/api_service.dart';
import 'package:flutter/rendering.dart';
import 'package:merchandising/HR/HRdashboard.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../Constants.dart';
import 'package:flutter/cupertino.dart';
import 'MenuContent.dart';
import 'package:intl/intl.dart';
import 'Customers Activities.dart';
import 'package:merchandising/model/database.dart';
import 'package:merchandising/api/clientapi/stockexpirydetailes.dart';
var productname = "select from the above";
var packtype = 'Regular';
var range = 'Regular';
List<String> selectedList = [];
String selecttype;
String SelectedPeriod;
String selectpack;
List selecttypelist =
    ["SKU", "ZREP","Product Name","Barcode"].map((String val) {
  return new DropdownMenuItem<String>(
    value: val,
    child: new Text(val),
  );
}).toList();
String selectcode;
List productdetails = Expiry.productdetails.toSet().toList().map((String val) {
  return new DropdownMenuItem<String>(
    value: val,
    child: new Text(val),
  );
}).toList();
List barcode = Expiry.barcode.toSet().toList().map((String val) {
  return new DropdownMenuItem<String>(
    value: val,
    child: new Text(val),
  );
}).toList();
List zrep = Expiry.zrepcodes.toSet().toList().map((String val) {
  return new DropdownMenuItem<String>(
    value: val,
    child: new Text(val),
  );
}).toList();
List sku = Expiry.sku.toSet().toList().map((String val) {
  return new DropdownMenuItem<String>(
    value: val,
    child: new Text(val),
  );
}).toList();

List inputlist = selectedList.map((String val) {
  return new DropdownMenuItem<String>(
    value: val,
    child: new Text(val),
  );
}).toList();

TextEditingController remarks = TextEditingController();

class ExpiryReport extends StatefulWidget {
  @override
  _ExpiryReportState createState() => _ExpiryReportState();
}
bool expirycheck = false;
class _ExpiryReportState extends State<ExpiryReport> {
  bool isApiCallProcess = false;
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
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
                    'Expiry Details',
                    style: TextStyle(color: orange),
                  ),
                  EmpInfo()
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () async{
                  setState(() {
                    isApiCallProcess = true;
                  });
                  for(int u=0; u<addedproductid.length;u++){
                    productid = addedproductid[u];
                    pricepc = addedpriceperitem[u];
                    expirypc = addeditemscount[u];
                    pcexpirydate = addedexpirydate[u];
                    exposureqntypc = addedexposurequnatity[u];
                    remarksifany = addedremarks[u]==""?"no remarks entered":addedremarks[u];
                    int statuscode = await addexpiryproducts();
                    print(statuscode);
                  }
                  await Addedstockdataformerch();
                  setState(() {
                    isApiCallProcess = false;
                  });
                  expirycheck= true;
                  Navigator.pushReplacement(
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
              )
            ],
          ),
        ),
        // drawer: Drawer(
        //   child: Menu(),
        // ),

        body: Stack(
          children: [
            BackGround(),
            DefaultTabController(
              length: 2, // lengt0h of tabs
              initialIndex: 0,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                        Tab(text: 'Add Data'),
                        Tab(text: 'Saved Data'),
                        //Tab(text: 'Submitted Data'),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                    //physics: NeverScrollableScrollPhysics(),
                    // controller: _controller,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              //height: 700,
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: pink,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10.0),
                                    padding: EdgeInsets.only(left: 10.0),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: DropdownButton(
                                      elevation: 0,
                                      dropdownColor: Colors.white,
                                      isExpanded: true,
                                      underline: SizedBox(),
                                      iconEnabledColor: orange,
                                      iconSize: 35.0,
                                      value: selecttype,
                                      onChanged: (newVal) {
                                        setState(() {
                                          selecttype = newVal;
                                          if (newVal == 'Barcode') {
                                            inputlist = barcode;
                                          } else
                                            if (newVal == 'Product Name') {
                                            inputlist = productdetails;
                                          } else if (newVal == 'ZREP') {
                                            inputlist = zrep;
                                          } else {
                                            inputlist = sku;
                                          }
                                        });
                                      },
                                      items: selecttypelist,
                                      hint: Text(
                                        "Filter By ",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.0),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: SearchableDropdown.single(
                                      underline: SizedBox(),
                                      items: inputlist,
                                      value: selectcode,
                                      hint: "Select Product",
                                      searchHint: "Select Product",
                                      onChanged: (value) {
                                        if (value != null) {
                                          setState(() {
                                            isApiCallProcess = true;
                                          });
                                          if (inputlist == barcode) {
                                            productname = Expiry.productdetails[Expiry
                                                .barcode
                                                .indexOf(value)];
                                            print(productname);
                                          } else
                                            if (inputlist ==
                                              sku) {
                                            productname = Expiry.productdetails[Expiry.sku.indexOf(value)];
                                            packtype = Expiry.type[Expiry.sku.indexOf(value)];
                                            range = Expiry.range[Expiry.sku.indexOf(value)];
                                            print(productname);
                                          } else if (inputlist == zrep) {
                                            productname = Expiry.productdetails[Expiry.zrepcodes.indexOf(value)];
                                            packtype = Expiry.type[Expiry.zrepcodes.indexOf(value)];
                                            range = Expiry.range[Expiry.zrepcodes.indexOf(value)];
                                            print(productname);
                                          } else {
                                            productname = value;
                                            packtype = Expiry.type[Expiry.productdetails.indexOf(value)];
                                            range = Expiry.range[Expiry.productdetails.indexOf(value)];
                                          }
                                          setState(() {
                                            selectcode = value;
                                            isApiCallProcess = false;
                                          });
                                        }
                                      },
                                      isExpanded: true,
                                      iconEnabledColor: orange,
                                      iconSize: 25.0,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 5.0, right: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Product : ",
                                              style: TextStyle(color: orange),
                                            ),
                                            Flexible(
                                                child: Text(
                                              productname,
                                              maxLines: 3,
                                              style: TextStyle(color: orange),
                                            )),
                                          ],
                                        ),
                                      ),
                                      packtype == null ? SizedBox()
                                          :Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 5.0, right: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "type : ",
                                              style: TextStyle(color: orange),
                                            ),
                                            Flexible(
                                                child: Text(
                                                  packtype,
                                                  maxLines: 3,
                                                  style: TextStyle(color: orange),
                                                )),
                                          ],
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(
                                      //       top: 10.0, left: 5.0, right: 5.0),
                                      //   child: Row(
                                      //     mainAxisAlignment:
                                      //     MainAxisAlignment.spaceBetween,
                                      //     children: [
                                      //       Text(
                                      //         "range : ",
                                      //         style: TextStyle(color: orange),
                                      //       ),
                                      //       Flexible(
                                      //           child: Text(
                                      //             range,
                                      //             maxLines: 3,
                                      //             style: TextStyle(color: orange),
                                      //           )),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  EndDate(),
                                  Peice(),
                                  /*Expanded(
                          child: DefaultTabController(
                            length: 3, // length of tabs
                            initialIndex: 0,
                            child:Scaffold(
                              backgroundColor: Colors.transparent,
                              appBar: PreferredSize(
                                preferredSize: Size.fromHeight(kToolbarHeight),
                                child: Container(
                                      margin: EdgeInsets.fromLTRB(0, 10.0, 0.0, 0),
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
                                          Tab(text: 'Piece'),
                                          Tab(text: 'Box'),
                                          Tab(text: 'Cotton'),
                                        ],
                                      ),
                                    ),
                              ),
                              body: TabBarView(
                                //physics: NeverScrollableScrollPhysics(),
                                 // controller: _controller,
                                  children: [
                                    Peice(),
                                    Box(),
                                    Cases(),
                                  ]),
                            ),
                            ),
                        ),*/
                                  Container(
                                    margin: EdgeInsets.only(top: 10.0),
                                    padding: EdgeInsets.only(left: 10.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: TextFormField(
                                      controller: remarks,
                                      cursorColor: grey,
                                      validator: (input) => !input.isNotEmpty
                                          ? "Department should not be empty"
                                          : null,
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusColor: orange,
                                        hintText: "Remarks",
                                        hintStyle: TextStyle(
                                          color: grey,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            TextButton(
                                onPressed: () async {
                                  if(int.parse(quantity.text) < int.parse(expirypeciescount.text)){
                                    if (selectcode != null  && "${ENDdate.toLocal()}".split(' ')[0] != "${tomoroww.toLocal()}".split(' ')[0]) {
                                      print("correct");
                                      Storecode = outletid;
                                      productid = Expiry.id[Expiry.productdetails.indexOf(productname)];
                                      expirypc = expirypeciescount.text;
                                      pcexpirydate = "${ENDdate.toLocal()}".split(' ')[0];
                                      periodchoosed = SelectedPeriod;
                                      exposureqntypc = quantity.text == "" ? 0 : quantity.text;
                                      pricepc = peiceprice.text == "" ? 0 : peiceprice.text;
                                      filledby = '${DBrequestdata.receivedempid}';
                                      remarksifany =
                                      remarks.text == "" ? 0 : remarks.text;
                                      if (Estimatedvalue == null) {
                                        Flushbar(
                                          message:
                                          "please fill atleast one of the three forms",
                                          duration: Duration(seconds: 3),
                                        )..show(context);
                                      } else {
                                        setState(() {
                                          isApiCallProcess = true;
                                        });
                                        //await addexpiryproducts();
                                        addedproductid.add(productid);
                                        addedproductname.add('${Expiry.zrepcodes[Expiry.productdetails.indexOf(productname)]}-$productname');
                                        addedexpirydate.add("${ DateFormat("yyyy-MM-dd").format(ENDdate)}");
                                        addeditemscount.add(int.parse(expirypeciescount.text));
                                        addedexposurequnatity.add(int.parse(quantity.text));
                                        addedpriceperitem.add(int.parse(peiceprice.text));
                                        addedremarks.add(remarks.text==null?"":remarks.text);

                                        productname = "select from the above";
                                        selectcode = null;
                                        selecttype = null;
                                        packtype = null;
                                        expirypeciescount.clear();
                                        quantity.clear();
                                        peiceprice.clear();
                                        remarks.clear();
                                        setState(() {
                                          isApiCallProcess = false;
                                        });
                                        Flushbar(
                                          message: "data updated sucessfully",
                                          duration: Duration(seconds: 3),
                                        )..show(context);
                                      }
                                    } else {
                                      Flushbar(
                                        message:selectcode == null
                                            ? "please Select Product should not be null "
                                            : "please select a vaild product Expiry date",
                                        duration: Duration(seconds: 3),
                                      )..show(context);
                                    }
                                  }else{
                                    Flushbar(
                                      message:"Exposure Quantity cannot be greater than Items Count",
                                      duration: Duration(seconds: 3),
                                    )..show(context);
                                  }
                                },
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(pink)),
                                child: Text(
                                  "SAVE",
                                  style: TextStyle(color: orange),
                                ))
                          ],
                        ),
                      ),
                      Addedexpirydata(),
                      //SubmittedData()
                    ]),
              ),
            ),
            NBlFloatingButton(),
          ],
        ),
      ),
    );
  }
}



DateTime tomoroww = DateTime.now().add(Duration(days: 1));

DateTime ENDdate = DateTime.now().add(Duration(days: 1));

class EndDate extends StatefulWidget {
  @override
  _EndDateState createState() => _EndDateState();
}

class _EndDateState extends State<EndDate> {
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: tomoroww,
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
            "Expiry Date",
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

class Peice extends StatefulWidget {
  @override
  _PeiceState createState() => _PeiceState();
}

double priceperpiece;
double Estimatedvalue;
double Estimatedquantityvalue;
TextEditingController quantity = TextEditingController();
TextEditingController expirypeciescount = TextEditingController();
TextEditingController peiceprice = TextEditingController();

class _PeiceState extends State<Peice> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.only(top: 10.0),
          padding: EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: TextFormField(
            controller: peiceprice,
            onChanged: (value) {
              setState(() {
                priceperpiece = double.parse(peiceprice.text);

                expirypeciescount.text != null
                    ? Estimatedvalue =
                        double.parse(expirypeciescount.text) * priceperpiece
                    : print("");
              });
            },
            cursorColor: grey,
            keyboardType: TextInputType.number,
            validator: (input) =>
                !input.isNotEmpty ? "Department should not be empty" : null,
            decoration: new InputDecoration(
              border: InputBorder.none,
              focusColor: orange,
              hintText: "Enter Price Per Piece",
              hintStyle: TextStyle(
                color: grey,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10.0),
          padding: EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: TextFormField(
            controller: expirypeciescount,
            onChanged: (value) {
              setState(() {
                Estimatedvalue =
                    double.parse(expirypeciescount.text) * priceperpiece;
              });
            },
            cursorColor: grey,
            keyboardType: TextInputType.number,
            validator: (input) =>
                !input.isNotEmpty ? "should not be empty" : null,
            decoration: new InputDecoration(
              border: InputBorder.none,
              focusColor: orange,
              hintText: "Near Expiry Pieces Count",
              hintStyle: TextStyle(
                color: grey,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
        //expirypeciescount.text == null ?SizedBox(height: 10,) :
        Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 5.0, right: 5.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Estimated Expiry Value",
                  style: TextStyle(color: orange),
                ),
                Text(
                  "$Estimatedvalue AED",
                  style: TextStyle(color: orange),
                ),
              ],
            )),
        Container(
          padding: EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: TextFormField(
            controller: quantity,
            onChanged: (value) {
              setState(() {
                Estimatedquantityvalue =
                    double.parse(quantity.text) * priceperpiece;
              });
            },
            cursorColor: grey,
            keyboardType: TextInputType.number,
            validator: (input) =>
                !input.isNotEmpty ? "Department should not be empty" : null,
            decoration: new InputDecoration(
              border: InputBorder.none,
              focusColor: orange,
              hintText: "Exposure Quantity",
              hintStyle: TextStyle(
                color: grey,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
        //quantity.text == null ?SizedBox() :
        Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Estimated Quantity Value",
                  style: TextStyle(color: orange),
                ),
                Text(
                  "$Estimatedquantityvalue AED",
                  style: TextStyle(color: orange),
                ),
              ],
            )),
      ],
    );
  }
}


class Addedexpirydata extends StatefulWidget {
  @override
  _AddedexpirydataState createState() => _AddedexpirydataState();
}

class _AddedexpirydataState extends State<Addedexpirydata> {
  var _searchview = new TextEditingController();

  bool _firstSearch = true;

  String _query = "";

  List<dynamic> inputlist;

  List<String> _filterList;

  List<String> _filteredexpiryList;
  List<int> _filteredeitemsList;

  @override
  void initState() {
    super.initState();
    inputlist = addedproductname;
    inputlist.sort();
  }

  _AddedexpirydataState() {
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
    return Column(
      children: <Widget>[
        _createSearchView(),
        SizedBox(
          height: 10.0,
        ),
        _firstSearch ? _createListView() : _performSearch(),
      ],
    );
  }

  Widget _createSearchView() {
    return new Container(
      margin: EdgeInsets.fromLTRB(10.0, 10, 10, 0),
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      width: double.infinity,
      decoration:
          BoxDecoration(color: pink, borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: new TextField(
              style: TextStyle(color: orange),
              controller: _searchview,
              cursorColor: orange,
              decoration: InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                focusColor: orange,
                hintText: 'Search by SKU/ZREP',
                hintStyle: TextStyle(color: orange),
                border: InputBorder.none,
                isCollapsed: true,
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
          itemCount: addedproductid.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onLongPress: (){
                showDialog(
                    context: context,
                    builder: (_) => StatefulBuilder(
                        builder: (context, setState) {
                          return AlertDialog(
                            backgroundColor: alertboxcolor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(
                                    Radius.circular(10.0))),
                            content: Builder(
                              builder: (context) {
                                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Delete ?',style: TextStyle(color: orange,fontSize: 20),),
                                    Divider(color: Colors.black,thickness: 0.8,),
                                    Text("Do you want to remove these enteries ?",textAlign: TextAlign.center,),
                                    SizedBox(height: 10,),
                                    Text("Note* if you want to send the data regarding this product, you need to add the Entries again before submitting the data",textAlign: TextAlign.center,style: TextStyle(color: orange,fontSize:10),),
                                    SizedBox(height: 5,),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () async{
                                          print(index);
                                          setState(() {
                                            addedproductname.removeAt(index);
                                            addedproductid.removeAt(index);
                                            addedexpirydate.removeAt(index);
                                            addeditemscount.removeAt(index);
                                            addedexposurequnatity.removeAt(index);
                                            addedremarks.removeAt(index);
                                            addedpriceperitem.removeAt(index);
                                          });
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ExpiryReport()));

                                        },
                                        child: Container(
                                          height: 30,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.red,borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Center(child: Text('YES',style: TextStyle(color: Colors.white))),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        }));
              },
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Text(
                              '${addedproductname[index]}',
                              maxLines: 1,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: orange),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text('Product ID:',
                            style: TextStyle(
                              fontSize: 15.0,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Text(addedproductid[index].toString()),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text('Expiry Date :',
                            style: TextStyle(
                              fontSize: 15.0,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Text(addedexpirydate[index]),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text('price :',
                            style: TextStyle(
                              fontSize: 15.0,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Text('${addedpriceperitem[index]} AED'),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text('No of Items:',
                            style: TextStyle(
                              fontSize: 15.0,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Text(addeditemscount[index].toString()),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text('Exposure Quantity:',
                            style: TextStyle(
                              fontSize: 15.0,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Text(addedexposurequnatity[index].toString()),
                      ],
                    ),
                    SizedBox(height: 5),
                    addedremarks[index] != "" ?Row(
                      children: [
                        Text('Remarks:',
                            style: TextStyle(
                              fontSize: 15.0,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Text(addedremarks[index].toString()),
                      ],
                    ): SizedBox(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget _performSearch() {
    _filterList = [];
    _filteredexpiryList = [];
    _filteredeitemsList = [];
    for (int i = 0; i < addedproductname.length; i++) {
      var item = addedproductname[i];
      if (item.toLowerCase().contains(_query.toLowerCase())) {
        _filterList.add(item);
        _filteredexpiryList.add(addedexpirydate[addedproductname.indexOf(item)]);
        _filteredeitemsList.add(addeditemscount[addedproductname.indexOf(item)]);
      }
    }
    return _createFilteredListView();
  }

  Widget _createFilteredListView() {
    return Flexible(
      child: new ListView.builder(
          itemCount: _filteredeitemsList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            '${_filterList[index]}',
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: orange),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Expiry Date :',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text(_filteredexpiryList[index]),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text('Items Count:',
                          style: TextStyle(
                            fontSize: 15.0,
                          )),
                      SizedBox(
                        width: 5,
                      ),
                      Text(_filteredeitemsList[index].toString()),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}

List<String> addedproductname = [];
List<int> addedpriceperitem = [];
List<String> addedexpirydate = [];
List<int> addeditemscount = [];
List<int> addedexposurequnatity = [];
List<String> addedremarks = [];
List<int> addedproductid = [];


class SubmittedData extends StatefulWidget {
  const SubmittedData({Key key}) : super(key: key);

  @override
  _SubmittedDataState createState() => _SubmittedDataState();
}

class _SubmittedDataState extends State<SubmittedData> {
  var _searchview = new TextEditingController();

  bool _firstSearch = true;

  String _query = "";

  List<dynamic> inputlist;

  List<String> _filterList;

  List<String> _filteredexpiryList;
  List<int> _filteredeitemsList;

  @override
  void initState() {
    super.initState();
    inputlist = Stockdatamerch.productname;
    inputlist.sort();
  }

  _SubmittedDataState() {
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
    return Column(
      children: <Widget>[
        _createSearchView(),
        SizedBox(
          height: 10.0,
        ),
        _firstSearch ? _createListView() : _performSearch(),
      ],
    );
  }

  Widget _createSearchView() {
    return new Container(
      margin: EdgeInsets.fromLTRB(10.0, 10, 10, 0),
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      width: double.infinity,
      decoration:
      BoxDecoration(color: pink, borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: new TextField(
              style: TextStyle(color: orange),
              controller: _searchview,
              cursorColor: orange,
              decoration: InputDecoration(
                contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                focusColor: orange,
                hintText: 'Search by SKU/ZREP',
                hintStyle: TextStyle(color: orange),
                border: InputBorder.none,
                isCollapsed: true,
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
    return Expanded(
      child: ListView.builder(
        //physics: const NeverScrollableScrollPhysics(),
        //shrinkWrap: true,
          itemCount:Stockdatamerch.productname.length,
          itemBuilder: (BuildContext context, int index) {
            print(Stockdatamerch.productname);
            return Container(
              height: 170,
              margin: EdgeInsets.only(bottom:10,left: 10.0,right: 10.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(child: Text("${Stockdatamerch.productname[index]}",style: TextStyle(color: orange),)),
                    //Text("Outlet : ${Stockdata.outlet[index]}"),
                    Text("Expiry Date : ${Stockdatamerch.expirydate[index].toString()}"),
                    Text("Price : ${Stockdatamerch.pieceperprice[index].toString()} AED"),
                    Text("Near to Expiry : ${Stockdatamerch.nearexpiry[index].toString()}"),
                    Text("Exposure Quantity : ${Stockdatamerch.exposurequantity[index].toString()}"),
                    Text("Remarks : ${Stockdatamerch.remarks[index].toString()}"),
                    Text("Captured on : ${Stockdatamerch.captureddate[index].toString()}"),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
List<int>_filterindex=[];
  Widget _performSearch() {
    _filterList = [];
    _filterindex=[];
    _filteredexpiryList = [];
    _filteredeitemsList = [];
    for (int i = 0; i < Stockdatamerch.productname.length; i++) {
      var item = Stockdatamerch.productname[i];
      if (item.toLowerCase().contains(_query.toLowerCase())) {
        _filterindex.add(Stockdatamerch.productname.indexOf(item));
      }
    }
    return _createFilteredListView();
  }

  Widget _createFilteredListView() {
    return Expanded(
      child: ListView.builder(
        //physics: const NeverScrollableScrollPhysics(),
        //shrinkWrap: true,
          itemCount:_filterindex.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 170,
              margin: EdgeInsets.only(bottom:10,left: 10.0,right: 10.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(child: Text("${Stockdatamerch.productname[_filterindex[index]]}",style: TextStyle(color: orange),)),
                    //Text("Outlet : ${Stockdata.outlet[index]}"),
                    Text("Expiry Date : ${Stockdatamerch.expirydate[_filterindex[index]].toString()}"),
                    Text("Price : ${Stockdatamerch.pieceperprice[_filterindex[index]].toString()} AED"),
                    Text("Near to Expiry : ${Stockdatamerch.nearexpiry[_filterindex[index]].toString()}"),
                    Text("Exposure Quantity : ${Stockdatamerch.exposurequantity[_filterindex[index]].toString()}"),
                    Text("Remarks : ${Stockdatamerch.remarks[_filterindex[index]].toString()}"),
                    Text("Captured on : ${Stockdatamerch.captureddate[_filterindex[index]].toString()}"),
                  ],
                ),
              ),
            );
          }
      ),
    );
  }
}
