

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:merchandising/Fieldmanager/FMdashboard.dart';
import 'package:merchandising/Fieldmanager/addpromotion.dart';
import 'package:merchandising/Fieldmanager/product_details.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:merchandising/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/MenuContent.dart';
import 'package:merchandising/api/FMapi/add_nblapi.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';


import'package:merchandising/api/FMapi/promotion_detailsapi.dart';
import'package:merchandising/Fieldmanager/products.dart';

import 'package:merchandising/api/FMapi/outletapi.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:io';
import'package:merchandising/api/FMapi/nbl_detailsapi.dart';

class AddNBL extends StatefulWidget {
  @override
  _AddNBLState createState() => _AddNBLState();
}

String SelectedOutlet;
FilePickerResult file;
String Selectedproduct;
List<String> Outlets = PromoData.storename;

class _AddNBLState extends State<AddNBL> {
  List<String>allowedformat = ["pdf"];
  bool isApiCallProcess = false;
  FilePickerResult _file;
  Future getFile()async{
    if (Platform.isAndroid) {
       file = await FilePicker.platform.pickFiles(type: FileType.custom,allowedExtensions:allowedformat);
    } else if (Platform.isIOS) {
       file = await FilePicker.platform.pickFiles();
    }
    setState(() {
      _file = file;
      pickedfile.name = file.names.toString();
    });
    return _file;
  }
  Offset count =Offset(20.0,20.0);
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
                'Add NBL',
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

                        Container(
                          decoration: BoxDecoration(color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0)),
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsets.only(top: 10,bottom: 10),

                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Upload the PDF Document",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () async{
                                      FilePickerResult picked = await getFile();
                                      if(picked != null){
                                        pickedfile.filepicked = File(picked.files.single.path);
                                      }
                                    },
                                    child: Icon(CupertinoIcons.folder_badge_plus),
                                  ),
                                ],
                              ),
                              _file != null ?
                              Text( pickedfile.name)
                                  :SizedBox(),
                            ],
                          ),
                        ),


                        Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: ()async{
                              setState(() {
                                isApiCallProcess=true;
                              });

                              AddNBLData.outletid=outletdata.outletid[outletdata.outletname.indexOf(SelectedOutlet)];
                              AddNBLData.nblfile =pickedfile.filepicked;
                              AddNBLData.nblfilename = pickedfile.name;
                              await addnbl();

                              setState(() {
                                isApiCallProcess=false;
                              });

                                Flushbar(
                                  message: "NBL has been added",
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
                              child: Text("Save",style: TextStyle(color: pink),),
                            ),
                          ),
                        ),

                      ],
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

class pickedfile{
  static var name;
  static File filepicked;
}