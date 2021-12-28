import 'package:flutter/material.dart';
import 'package:merchandising/Fieldmanager/FMdashboard.dart';
import 'package:merchandising/Fieldmanager/product_details.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:merchandising/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/MenuContent.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:merchandising/api/FMapi/outlet brand mappingapi.dart';
import'package:merchandising/api/FMapi/add_promoapi.dart';

import'package:merchandising/api/FMapi/promotion_detailsapi.dart';
import'package:merchandising/Fieldmanager/products.dart';
import 'package:merchandising/api/FMapi/product_detailsapi.dart';
import 'package:merchandising/api/FMapi/outletapi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'dart:convert';
import 'dart:io';
int filefor;
List<int> selectbrands;
List brandlist = productlist.productname.map((String val) {
  return new DropdownMenuItem<String>(
    value: val,
    child: new Text(val),
  );
}).toList();

String image;
class AddPromotion extends StatefulWidget {
  @override
  _AddPromotionState createState() => _AddPromotionState();
}

String SelectedOutlet;

String Selectedproduct;
List<String> Outlets = PromoData.storename;

class _AddPromotionState extends State<AddPromotion> {
  TextEditingController description = TextEditingController();
  GlobalKey<FormState> addpromotion = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  FilePickerResult _file;
  Future getFile()async{
    FilePickerResult file = await FilePicker.platform.pickFiles();
    setState(() {
      _file = file;
      pickedfile.name[filefor] = file.names.toString();
    });
    return _file;
  }
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: containerscolor,
          iconTheme: IconThemeData(color: orange),
          title: Column(
            children: [
              Text(
                'Add Promotion',
                style: TextStyle(color: orange),
              ),
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
                    child: Form(
                      key: addpromotion,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            width: double.infinity,
                            child: SearchableDropdown.single(
                              underline: SizedBox(),
                              isExpanded: true,
                              iconEnabledColor: orange,
                              iconSize: 25.0,
                              value: SelectedOutlet,
                              onChanged: (newVal) {
                                setState(() {
                                  SelectedOutlet = newVal;
                                });
                              },
                              items: outletdata.outletname.map((String val) {
                                return new DropdownMenuItem<String>(
                                  value: val,
                                  child: new Text(val),
                                );
                              }).toList(),
                              hint: Text(
                                "Select Outlet",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          SizedBox(height:5),
                          Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SearchableDropdown.multiple(
                              underline: SizedBox(),
                              iconEnabledColor: orange,
                              items: brandlist,
                              selectedItems: selectbrands,
                              hint: Text("Select Products", style: TextStyle(color: Colors.grey)),
                              searchHint: "Select Products",
                              onChanged: (value) {
                                setState(() {
                                  print(value);
                                  selectbrands = value;
                                  print(selectbrands);
                                });
                                pickedfile.name=[];
                                pickedfile.bytes=[];
                                for(int i=0;i<selectbrands.length;i++){
                                  pickedfile.name.add("");
                                  pickedfile.bytes.add("");
                                }

                              },
                              closeButton: (selectedItems) {
                                return (selectedItems.isNotEmpty
                                    ? "Save ${selectedItems.length == 1 ? '"' + brandlist[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
                                    : "Save without selection");
                              },
                              isExpanded: true,
                            ),
                          ),
                          // Container(
                          //   margin: EdgeInsets.only(top: 10.0),
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(10),
                          //     color: Colors.white,
                          //   ),
                          //   width: double.infinity,
                          //   child: SearchableDropdown.single(
                          //     underline: SizedBox(),
                          //     isExpanded: true,
                          //     iconEnabledColor: orange,
                          //     iconSize: 25.0,
                          //     value: Selectedproduct,
                          //     onChanged: (newVal) {
                          //       setState(() {
                          //         Selectedproduct = newVal;
                          //       });
                          //     },
                          //     items: productlist.productname.map((String val) {
                          //       return new DropdownMenuItem<String>(
                          //         value: val,
                          //         child: new Text(val),
                          //       );
                          //     }).toList(),
                          //     hint: Text(
                          //       "Select Sku/item/product",
                          //       style: TextStyle(color: Colors.grey),
                          //     ),
                          //   ),
                          // ),
                          StartDate(),
                          EndDate(),
                          selectbrands != null
                              ? new ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: selectbrands.length,
                                  itemBuilder: (BuildContext context, int index) {

                                    return Container(
                                        padding: EdgeInsets.all(10.0),
                                        margin: EdgeInsets.only(bottom: 5.0, top: 10.0),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(10))),
                                        width: double.infinity,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [

                                            Row(
                                              children: [
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left:8.0),
                                                      child: Text(
                                                          '${productlist.productname[selectbrands[index]]}',
                                                        style: TextStyle(fontSize: 14.0),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                    onTap: () async {
                                                      filefor = index;
                                                      FilePickerResult picked = await getFile();
                                                      if (picked != null) {
                                                        File file = File(picked.files.single.path);
                                                        var image = file.readAsBytesSync();
                                                        pickedfile.bytes[index]= base64Encode(image);
                                                        print(pickedfile.bytes[index]);

                                                      }
                                                    },

                                                    child: Icon(CupertinoIcons.folder_badge_plus)),
                                              ],
                                            ),
                                            pickedfile.name[index] != "" ?
                                            Center(child: Text(pickedfile.name[index]))
                                                :SizedBox()
                                          ],
                                        ));
                                  }) : SizedBox(),


                          Container(
                            margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                            padding: EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              maxLines: 3,
                              controller: description,
                              cursorColor: grey,
                              validator: (input) => !input.isNotEmpty
                                  ? "Description not be empty"
                                  : null,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusColor: orange,
                                hintText: "Description*",
                                hintStyle: TextStyle(
                                  color: grey,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: GestureDetector(
                              onTap: ()async{
                                if(validateform()== true){

                                  setState(() {
                                    isApiCallProcess = true;
                                  });
                                }

                                AddPromo.outletid = outletdata.outletid[outletdata.outletname.indexOf(SelectedOutlet)];
                                AddPromo.productid =[];
                                AddPromo.imgurl =[];
                                for(int u=0;u<selectbrands.length;u++) {
                                  AddPromo.productid.add(productlist.productid[selectbrands[u]]);
                                 AddPromo.imgurl.add('data:image/jpeg;base64,${pickedfile.bytes[u]}');
                                }
                                AddPromo.fromdate = Startdate.toString().substring(0,10);
                                AddPromo.todate = ENDdate.toString().substring(0,10);
                                AddPromo.description = description.text;
                                await addpromodetails();


                                setState(() {
                                  isApiCallProcess = false;
                                });

                                Flushbar(
                                  message: "Promotion has been added",
                                  duration: Duration(seconds:3),
                                )..show(context);

                                Future.delayed(const Duration(seconds: 2), () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Products()));
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: orange,
                                  borderRadius: BorderRadius.circular(10.00),
                                ),
                                child: Text(
                                  'Save',
                                  style: TextStyle(color: Colors.black, fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  bool validateform() {
    final form = addpromotion.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

DateTime tomoroww = DateTime.now();

DateTime Startdate = DateTime.now();

class StartDate extends StatefulWidget {
  @override
  _StartDateState createState() => _StartDateState();
}

class _StartDateState extends State<StartDate> {
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
    if (picked != null && picked != StartDate)
      setState(() {
        Startdate = picked;
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
            "${Startdate.toLocal()}".split(' ')[0],
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
      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(10.0)),
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


class pickedfile{
  static var name;
  static var bytes;
}