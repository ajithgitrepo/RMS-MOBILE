
import 'package:flutter/painting.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/merchandiserdashboard.dart';
import 'package:merchandising/api/api_service.dart';
import 'package:flutter/rendering.dart';
import 'package:merchandising/HR/HRdashboard.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../Constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'MenuContent.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'Customers Activities.dart';
import 'package:merchandising/model/database.dart';
import 'package:merchandising/api/clientapi/stockexpirydetailes.dart';
import 'package:merchandising/model/dropdownsearchrepo.dart';





List<String> PdtLocation = ["STORE","BACK DOOR","FRONT DOOR","ENTRANCE","MAIN GATE","CENTER"];
String PdtLocationValue;
String prolocation="";


List<String> Customer = ["AL MAYA","AUH COOP","SHARJAH COOP","EMIRATES COOP","WAITROSE","AL AIN COOP","LULU","CARREFOUR","SPINNEYS","GT","UNION COOP","CHOITHRAM","WEST ZONE","SAFEER","NESTO","OTHERS"];
String CustomerValue;
String cusvalue="";


List<String> UOM = ["BAG","BUNDLE","BOX","CASE","CARTON","DOZEN","PIECE","PACK","SINGLE"];
String UOMValue;
String uomvalue="";




var productname = "select from the above";
var packtype = 'Regular';
var range = 'Regular';
int indexofselectedproduct;
var selectedproduct;
List<String> selectedList = [];
String selecttype;
String SelectedPeriod;
String selectpack;
List selecttypelist =
["SKU", "ZREP", "Product Name", "Barcode"].map((String val) {
  return new DropdownMenuItem<String>(
    value: val,
    child: new Text(val),
  );
}).toList();
String selectcodes;
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
TextEditingController productcontroller = TextEditingController();
DropdownMenuItem jj= DropdownMenuItem();

bool isApiCallProcess = false;

class ExpiryReport extends StatefulWidget {
  @override
  _ExpiryReportState createState() => _ExpiryReportState();
}

bool expirycheck = false;

class _ExpiryReportState extends State<ExpiryReport> {


  String PdtLocationValue;
  String CustomerValue;
  String UOMValue;

String prolocation="";
String cusvalue="";
String uomvalue="";

  void getDropDownItem(){
    setState(() {
      prolocation = PdtLocationValue;
      cusvalue = CustomerValue;
      uomvalue = UOMValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: onlinemode,
        builder: (context, value, child) {
          return ProgressHUD(
            inAsyncCall: isApiCallProcess,
            opacity: 0.3,
            child: GestureDetector(
              onTap: () {
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
                            'Expiry Details',
                            style: TextStyle(color: orange),
                          ),
                          EmpInfo()
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () async {
                          // setState(() {
                          //   isApiCallProcess = true;
                          // });
                          print(addedproductid.length);
                          for (int u = 0; u < addedproductid.length; u++) {
                            print(u);
                            addedexpiryindex = u;
                            productid = addedproductid[u];
                            pricepc = addedpriceperitem[u];
                            expirypc = addeditemscount[u];
                            pcexpirydate = addedexpirydate[u];
                            exposureqntypc = addedexposurequnatity[u];
                            remarksifany = addedremarks[u] == "" ? "no remarks entered" : addedremarks[u];
                            productlocation = addedproductlocation[u];
                            customerstoregroup = addedcustomerstore[u];
                            uom = addeduom[u];
                            print("UOM: $uom");
                            print(addeduom[u].toString());
                            await addexpiryproducts();
                          }

                          // await Addedstockdataformerch();
                          setState(() {
                            addedproductid = [];
                            addedpriceperitem = [];
                            addeditemscount = [];
                            addedexpirydate = [];
                            addedexposurequnatity = [];
                            addedremarks = [];
                            addedproductlocation = [];
                            addedcustomerstore = [];
                            addeduom = [];
                          });
                          expirycheck = true;
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CustomerActivities()));
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

                body: OfflineNotification(
                  body: Stack(
                    children: [
                      BackGround(),
                      Column(
                        children: [
                          SizedBox(
                            height: onlinemode.value ? 0 : 25,
                          ),
                          Expanded(
                            child: DefaultTabController(
                              length: 3, // lengt0h of tabs
                              initialIndex: 0,
                              child: Scaffold(
                                backgroundColor: Colors.transparent,
                                appBar: PreferredSize(
                                  preferredSize:
                                  Size.fromHeight(kToolbarHeight),
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
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
                                        Tab(text: 'Submitted Data'),
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
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                children: [
                                                  DropDownField(
                                                      controller:
                                                      productcontroller,
                                                      value: selectedproduct,
                                                      labelText:
                                                      'Select product',
                                                      hintText:
                                                      "Search by Product-ZREP-SKU-Barcode",
                                                      items: Expiry
                                                          .productfullname,
                                                      hintStyle: TextStyle(
                                                          color: orange,
                                                          fontSize: 10.0,
                                                          fontWeight:
                                                          FontWeight.w500),
                                                      textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                          FontWeight.w500),
                                                      labelStyle: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                          FontWeight.w400),
                                                      onValueChanged:
                                                          (dynamic newValue) {
                                                        selectedproduct =
                                                            newValue;
                                                        indexofselectedproduct =
                                                            Expiry
                                                                .productfullname
                                                                .indexOf(
                                                                selectedproduct);
                                                        print(
                                                            indexofselectedproduct);
                                                        print(selectedproduct);
                                                        setState(() {
                                                          productname = Expiry
                                                              .productdetails[
                                                          indexofselectedproduct];
                                                          packtype = Expiry
                                                              .type[
                                                          indexofselectedproduct];
                                                        });
                                                      }),
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            top: 10.0,
                                                            left: 5.0,
                                                            right: 5.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "Product : ",
                                                              style: TextStyle(
                                                                  color:
                                                                  orange),
                                                            ),
                                                            Flexible(
                                                                child: Text(
                                                                  productname,
                                                                  maxLines: 3,
                                                                  style: TextStyle(
                                                                      color:
                                                                      orange),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                      packtype == null
                                                          ? SizedBox()
                                                          : Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                            top: 10.0,
                                                            left: 5.0,
                                                            right:
                                                            5.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "type : ",
                                                              style: TextStyle(
                                                                  color:
                                                                  orange),
                                                            ),
                                                            Flexible(
                                                                child:
                                                                Text(
                                                                  packtype,
                                                                  maxLines: 3,
                                                                  style: TextStyle(
                                                                      color:
                                                                      orange),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  EndDate(),
                                                  Peice(),

                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10.0),
                                                    padding: EdgeInsets.only(
                                                        left: 10.0),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                      color: Colors.white,
                                                    ),
                                                    child: TextFormField(
                                                      controller: remarks,
                                                      cursorColor: grey,
                                                      decoration:
                                                      new InputDecoration(
                                                        border:
                                                        InputBorder.none,
                                                        focusColor: orange,
                                                        hintText: "Remarks",
                                                        hintStyle: TextStyle(
                                                          color: grey,
                                                          fontSize: 16.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  // Container(
                                                  //   margin: EdgeInsets.only(
                                                  //       top: 10, bottom: 5),
                                                  //   width: double.infinity,
                                                  //   decoration: BoxDecoration(
                                                  //     color: Colors.white,
                                                  //     borderRadius:
                                                  //         BorderRadius.circular(
                                                  //             10),
                                                  //   ),
                                                  //   child: SearchableDropdown
                                                  //       .single(
                                                  //     closeButton: SizedBox(),
                                                  //     underline: SizedBox(),
                                                  //     items: _dropdownItems1
                                                  //         .map(
                                                  //             (ListItem1 item) {
                                                  //       return DropdownMenuItem<
                                                  //           int>(
                                                  //         value: item.value,
                                                  //         child:
                                                  //             Text(item.name),
                                                  //       );
                                                  //     }).toList(),
                                                  //     value: _value,
                                                  //     hint: "Select Locations",
                                                  //     searchHint:
                                                  //         "Select Location",
                                                  //     onChanged: (value) {
                                                  //       _value = value;
                                                  //       print("ProductLocationvalueDropdown: $_value");
                                                  //     },
                                                  //     isExpanded: true,
                                                  //   ),
                                                  // ),

                                                  Container(
                                                    margin: EdgeInsets.only(top: 10, bottom: 5),
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: SearchableDropdown.single(
                                                      closeButton: SizedBox(),
                                                      underline: SizedBox(),
                                                      items: PdtLocation.map((String val) {
                                                      //  print(val + 'coccc');
                                                        return new DropdownMenuItem<String>(
                                                          value: val,
                                                          child:Text(val.toString()),
                                                        );
                                                      }).toList(),
                                                      value: PdtLocationValue,
                                                      hint: "Select Location",
                                                      searchHint: "Select Location",
                                                      onChanged: (value) {
                                                       // print(value + 'locat');
                                                        setState(() {
                                                          PdtLocationValue = value;

                                                        });

                                                      },
                                                      isExpanded: true,
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
                                                      items: Customer.map((String val) {
                                                        return new DropdownMenuItem<String>(
                                                          value: val,
                                                          child: new Text(val),
                                                        );
                                                      }).toList(),
                                                      value: CustomerValue,
                                                      hint: "Select Customer",
                                                      searchHint: "Select Customer",
                                                      onChanged: (value) {
                                                        setState(() {
                                                          CustomerValue = value;

                                                        });
                                                      },
                                                      isExpanded: true,
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
                                                      items: UOM.map((String val) {
                                                        return new DropdownMenuItem<String>(
                                                          value: val,
                                                          child: new Text(val),
                                                        );


                                                      }).toList(),
                                                      value:UOMValue,
                                                      hint: "Select UOM",
                                                      searchHint: "Select UOM",
                                                      onChanged: (value) {
                                                            setState(() {
                                                              UOMValue = value;

                                                            });

                                                      },



                                                      isExpanded: true,
                                                    ),
                                                  ),




                                                ],
                                              ),
                                            ),
                                            TextButton(
                                                onPressed: () async {


          setState(() {

          Addedexpirydata();

          });

          if(UOMValue!=null){
          if(CustomerValue!=null) {
          if (PdtLocationValue != null) {
          if (expirypeciescount.text !=
          "" &&
          quantity.text != "") {
          if (int.parse(
          quantity.text) <=
          int.parse(
          expirypeciescount
              .text)) {
          if (productname != null &&
          "${ENDdate.toLocal()}"
              .split(
          ' ')[0] !=
          "${tomoroww.toLocal()}"
              .split(
          ' ')[0]) {

          print("correct");
          Storecode = outletid;
          productid = Expiry.id[
          Expiry
              .productdetails
              .indexOf(
          productname)];
          expirypc =
          expirypeciescount
              .text;
          pcexpirydate =
          "${ENDdate.toLocal()}"
              .split(' ')[0];
          periodchoosed =
          SelectedPeriod;
          exposureqntypc =
          quantity.text == ""
          ? 0
              : quantity.text;
          pricepc = Expiry
              .priceofitem[
          indexofselectedproduct];
          filledby =
          '${DBrequestdata.receivedempid}';
          remarksifany =
          remarks.text == ""
          ? 0
              : remarks.text;

          // productlocation = PdtLocationValue == "" ? 0 : PdtLocationValue;
          // customerstoregroup = CustomerValue == "" ? 0 : CustomerValue;
          // uom = UOMValue == "" ? 0 : UOMValue;

          {
          setState(() {
          isApiCallProcess =
          true;
          });
          //await addexpiryproducts();
          addedproductid.add(
          Expiry.id[Expiry
              .productdetails
              .indexOf(
          productname)]);
          addedproductname.add(
          '${Expiry.zrepcodes[Expiry.productdetails.indexOf(
          productname)]}-$productname');
          // addedexpirydate.clear();
          addedexpirydate.add(
          "${DateFormat("yyyy-MM-dd").format(ENDdate)}");
          addeditemscount.add(
          int.parse(
          expirypeciescount
              .text));
          addedexposurequnatity
              .add(int.parse(
          quantity
              .text));
          addedpriceperitem
              .add(pricepc);
          addedremarks.add(
          remarks.text ==
          null
          ? ""
              : remarks
              .text);

          addedproductlocation.add(PdtLocationValue );
          addedcustomerstore.add(CustomerValue);
          addeduom.add(UOMValue );


          productname =
          "select from the above";
          selecttype = null;
          packtype = null;
          expirypeciescount.clear();
          quantity.clear();
          peiceprice.clear();
          productcontroller.clear();
          remarks.clear();
         // addedproductlocation.clear();
         // addedcustomerstore.clear();
         // addeduom.clear();


          // prolocation = "";
          // cusvalue = "";
          // uomvalue = "";


          PdtLocationValue="";
          CustomerValue="";
          UOMValue="";

        /*  Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => super.widget)); */


          Flushbar(
          message:
          "data updated sucessfully",
          duration: Duration(
          seconds: 1),
          )
          ..show(context);



          //setState(() {});

          }
          } else {
          Flushbar(
          message: productname ==
          null
          ? "please Select Product should not be null "
              : "please select a vaild product Expiry date",
          duration: Duration(
          seconds: 3),
          )
          ..show(context);
          }
          } else {
          Flushbar(
          message:
          "Exposure Quantity cannot be greater than Items Count",
          duration: Duration(
          seconds: 3),
          )
          ..show(context);
          }
          } else {
          Flushbar(
          message: quantity.text ==
          ""
          ? "Exposure Quantity is required"
              : "Near Expiry Pieces Count is required",
          duration:
          Duration(seconds: 3),
          )
          ..show(context);
          }
          } else {
          Flushbar(
          message: PdtLocationValue ==
          ""
          ? "Please Select Product Location"
              : "Product Location is required",
          duration:
          Duration(seconds: 3),
          )
          ..show(context);
          }
          }else{
          Flushbar(
          message: CustomerValue==
          ""
          ? "Please select Customer"
              : "Customer is required",
          duration:
          Duration(seconds: 3),
          )
          ..show(context);
          }
          }else{
          Flushbar(
    message: UOMValue==
        ""
        ? "Please Select UOM"
        : "Please Fill The Empty Field",
    duration:
    Duration(seconds: 3),
  )
    ..show(context);
          }




                                                  // Navigator.push(context,
                                                  //     MaterialPageRoute(builder: (BuildContext context) => ExpiryReport()));
                                                  setState(() {
                                                    isApiCallProcess =
                                                    false;
                                                  });



                                                },
                                                style: ButtonStyle(
                                                    backgroundColor:
                                                    MaterialStateProperty
                                                        .all(pink)),
                                                child: Text(
                                                  "SAVE",
                                                  style:
                                                  TextStyle(color: orange),
                                                ))
                                          ],
                                        ),
                                      ),

                                      Addedexpirydata(),
                                      SubmittedData(),

                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                      NBlFloatingButton(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
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
        // Container(
        //   margin: EdgeInsets.only(top: 10.0),
        //   padding: EdgeInsets.only(left: 10.0),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     color: Colors.white,
        //   ),
        //   child: TextFormField(
        //     controller: peiceprice,
        //     onChanged: (value) {
        //       setState(() {
        //         priceperpiece = double.parse(peiceprice.text);
        //
        //         expirypeciescount.text != null
        //             ? Estimatedvalue =
        //                 double.parse(expirypeciescount.text) * priceperpiece
        //             : print("");
        //       });
        //     },
        //     cursorColor: grey,
        //     keyboardType: TextInputType.number,
        //     validator: (input) =>
        //         !input.isNotEmpty ? "Department should not be empty" : null,
        //     decoration: new InputDecoration(
        //       border: InputBorder.none,
        //       focusColor: orange,
        //       hintText: "Enter Price Per Piece",
        //       hintStyle: TextStyle(
        //         color: grey,
        //         fontSize: 16.0,
        //       ),
        //     ),
        //   ),
        // ),
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
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
        // Padding(
        //     padding: const EdgeInsets.only(
        //         top: 10.0, left: 5.0, right: 5.0, bottom: 10.0),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(
        //           "Estimated Expiry Value",
        //           style: TextStyle(color: orange),
        //         ),
        //         Text(
        //           "$Estimatedvalue AED",
        //           style: TextStyle(color: orange),
        //         ),
        //       ],
        //     )),
        Container(
          padding: EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: TextFormField(
            controller: quantity,
            // onChanged: (value) {
            //   setState(() {
            //     Estimatedquantityvalue =
            //         double.parse(quantity.text) * priceperpiece;
            //   });
            // },
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
        // Padding(
        //     padding: const EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(
        //           "Estimated Quantity Value",
        //           style: TextStyle(color: orange),
        //         ),
        //         Text(
        //           "$Estimatedquantityvalue AED",
        //           style: TextStyle(color: orange),
        //         ),
        //       ],
        //     )),
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
    // inputlist.sort();
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
  bool isApiCallProcess = false;
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: Stack(
        children: [
          Column(
            children: <Widget>[
              _createSearchView(),
              SizedBox(
                height: 10.0,
              ),
              _firstSearch ? _createListView() : _performSearch(),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: GestureDetector(
                onTap: () async {
                  if (onlinemode.value) {
                    setState(() {
                      isApiCallProcess = true;
                    });
                    print(addedproductid.length);
                    print("Added expiry date${addedexpirydate[0]}");

                    for (int u = 0; u < addedproductid.length; u++) {
                      print(u);
                      addedexpiryindex = u;
                      productid = addedproductid[u];
                      pricepc = addedpriceperitem[u];
                      expirypc = addeditemscount[u];
                      pcexpirydate = addedexpirydate[u];
                      exposureqntypc = addedexposurequnatity[u];
                      remarksifany = addedremarks[u] == "" ? "no remarks entered" : addedremarks[u];
                      productlocation = addedproductlocation[u];
                      customerstoregroup = addedcustomerstore[u];
                      uom = addeduom[u];
                      Map stockdata = {
                        "timesheet_id": currenttimesheetid,
                        "product_id": productid,
                        "piece_price": pricepc,
                        "near_expiry": expirypc,
                        "expiry_date": pcexpirydate,
                        "exposure_qty": exposureqntypc,
                        "remarks": remarksifany,
                        "prodcut_location": productlocation,
                        "customer_storegroup": customerstoregroup,
                        "uom": uom,


                      };
                      http.Response Response = await http.post(
                        addexpiryDetail,
                        headers: {
                          'Content-Type': 'application/json',
                          'Accept': 'application/json',
                          'Authorization':
                          'Bearer ${DBrequestdata.receivedtoken}',
                        },
                        body: jsonEncode(stockdata),
                      );
                      print(Response.body);
                    }
                    addedproductid = [];
                    addedpriceperitem = [];
                    addeditemscount = [];
                    addedexpirydate = [];
                    addedexposurequnatity = [];
                    addedremarks = [];
                    addedproductlocation = [];
                    addedcustomerstore = [];
                    addeduom = [];

                    await Addedstockdataformerch();
                    setState(() {
                      isApiCallProcess = false;
                    });
                    expirycheck = true;
                  } else {
                    Flushbar(
                      message: "Active internet required",
                      duration: Duration(seconds: 3),
                    )..show(context);
                  }
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(15.0, 10, 15, 10),
                  decoration: BoxDecoration(
                    color: pink,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    "Submit Now",
                    style: TextStyle(color: orange),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
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
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (_) =>
                        StatefulBuilder(builder: (context, setState) {
                          return AlertDialog(
                            backgroundColor: alertboxcolor,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                            content: Builder(
                              builder: (context) {
                                // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Delete ?',
                                      style: TextStyle(
                                          color: orange, fontSize: 20),
                                    ),
                                    Divider(
                                      color: Colors.black,
                                      thickness: 0.8,
                                    ),
                                    Text(
                                      "Do you want to remove these enteries ?",
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Note* if you want to send the data regarding this product, you need to add the Entries again before submitting the data",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: orange, fontSize: 10),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Center(
                                      child: GestureDetector(
                                        onTap: () async {
                                          print(index);
                                          setState(() {
                                            addedproductname.removeAt(index);
                                            addedproductid.removeAt(index);
                                            addedexpirydate.removeAt(index);
                                            addeditemscount.removeAt(index);
                                            addedexposurequnatity
                                                .removeAt(index);
                                            addedremarks.removeAt(index);
                                            addedproductlocation
                                                .removeAt(index);
                                            addedcustomerstore.removeAt(index);
                                            addeduom.removeAt(index);
                                            addedpriceperitem.removeAt(index);
                                          });
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                      ExpiryReport()));
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius:
                                            BorderRadius.circular(5),
                                          ),
                                          child: Center(
                                              child: Text('YES',
                                                  style: TextStyle(
                                                      color: Colors.white))),
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
                    addedremarks[index] != ""
                        ? Row(
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
                    )
                        : SizedBox(height: 5),
                    Row(
                      children: [
                        Text('product location:',
                            style: TextStyle(
                              fontSize: 15.0,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Text(addedproductlocation[index].toString()),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text('customer store:',
                            style: TextStyle(
                              fontSize: 15.0,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Text(addedcustomerstore[index].toString()),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text('UOM:',
                            style: TextStyle(
                              fontSize: 15.0,
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        Text(addeduom[index].toString()),
                      ],
                    ),
                    SizedBox(height: 5),
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
        _filteredexpiryList
            .add(addedexpirydate[addedproductname.indexOf(item)]);
        _filteredeitemsList
            .add(addeditemscount[addedproductname.indexOf(item)]);
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
List<String> addedproductlocation = [];
List<String> addedcustomerstore = [];
List<String> addeduom = [];

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
    return Stockdatamerch.productname.length > 0
        ? Column(
      children: <Widget>[
        _createSearchView(),
        SizedBox(
          height: 10.0,
        ),
        _firstSearch ? _createListView() : _performSearch(),
      ],
    )
        : GestureDetector(
      onTap: () async {
        setState(() {
          isApiCallProcess = true;
        });
        await Addedstockdataformerch();

        setState(() {
          isApiCallProcess = false;
        });
        if (Stockdatamerch.productname.length == 0) {
          Flushbar(
            message: "No data submitted to this outlet",
            duration: Duration(seconds: 3),
          )..show(context);
        }
      },
      child: Center(
        child: Container(
          margin: EdgeInsets.only(right: 10.00),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Color(0xffFFDBC1),
            borderRadius: BorderRadius.circular(10.00),
          ),
          child: Text(
            'Get Submitted Data',
            style: TextStyle(color: Colors.black, fontSize: 15),
          ),
        ),
      ),
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
          itemCount: Stockdatamerch.productname.length,
          itemBuilder: (BuildContext context, int index) {
            print(Stockdatamerch.productname);
            print("$index - ${Stockdatamerch.productname[index]}");
            return Container(
              height: 170,
              margin: EdgeInsets.only(bottom: 10, left: 10.0, right: 10.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                        child: Text(
                          "${Stockdatamerch.productname[index]}",
                          style: TextStyle(color: orange),
                        )),
                    //Text("Outlet : ${Stockdata.outlet[index]}"),
                    Text(
                        "Expiry Date : ${Stockdatamerch.expirydate[index].toString()}"),
                    //Text("Price : ${Stockdatamerch.pieceperprice[index].toString()} AED"),
                    Text(
                        "Near to Expiry : ${Stockdatamerch.nearexpiry[index].toString()}"),
                    Text(
                        "Exposure Quantity : ${Stockdatamerch.exposurequantity[index].toString()}"),
                    Text(
                        "Remarks : ${Stockdatamerch.remarks[index].toString()}"),
                    Text(
                        "Captured on : ${Stockdatamerch.captureddate[index].toString()}"),
                    Text("Product Location : ${Stockdatamerch.Productlocation[index].toString()}"),
                    Text("Customer StoreGroup :${Stockdatamerch.Customerstoregroup[index].toString()}"),
                    Text("UOM :${Stockdatamerch.Uom[index].toString()}"),

                  ],
                ),
              ),
            );
          }),
    );
  }

  List<int> _filterindex = [];
  Widget _performSearch() {
    _filterList = [];
    _filterindex = [];
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
          itemCount: _filterindex.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 170,
              margin: EdgeInsets.only(bottom: 10, left: 10.0, right: 10.0),
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                        child: Text(
                          "${Stockdatamerch.productname[_filterindex[index]]}",
                          style: TextStyle(color: orange),
                        )),
                    //Text("Outlet : ${Stockdata.outlet[index]}"),
                    Text(
                        "Expiry Date : ${Stockdatamerch.expirydate[_filterindex[index]].toString()}"),
                    // Text("Price : ${Stockdatamerch.pieceperprice[_filterindex[index]].toString()} AED"),
                    Text(
                        "Near to Expiry : ${Stockdatamerch.nearexpiry[_filterindex[index]].toString()}"),
                    Text(
                        "Exposure Quantity : ${Stockdatamerch.exposurequantity[_filterindex[index]].toString()}"),
                    Text(
                        "Remarks : ${Stockdatamerch.remarks[_filterindex[index]].toString()}"),
                    Text("Captured on : ${Stockdatamerch.captureddate[_filterindex[index]].toString()}"),


                    Text("Product Location : ${Stockdatamerch.Productlocation[_filterindex[index]].toString()}"),
                    Text("Customer StoreGroup :${Stockdatamerch.Customerstoregroup[_filterindex[index]].toString()}"),
                    Text("UOM :${Stockdatamerch.Uom[_filterindex[index]].toString()}"),

                  ],
                ),
              ),
            );
          }),
    );
  }
}