import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:merchandising/Constants.dart';
import 'package:merchandising/api/FMapi/outletapi.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/MenuContent.dart';
import'package:merchandising/api/FMapi/add_checklist_api.dart';
import'package:merchandising/Fieldmanager/products.dart';
import 'package:flushbar/flushbar.dart';

int itemno;

List outletlist = outletdata.outletname.map((String val) {return new DropdownMenuItem<String>(
  value: val,
  child: new Text(val),
);
}).toList();

String selectedoutlets;


TextEditingController _checklist = TextEditingController();


class CheckList extends StatefulWidget {
  @override
  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  bool isApiCallProcess = false;


  List<TextEditingController> listctrl = [];



  GlobalKey<FormState> checklistkey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: containerscolor,
            iconTheme: IconThemeData(color: orange),
            title: Column(
              children: [
                Text(
                  'Add Check List',
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
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: pink,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SearchableDropdown.single(
                              underline: SizedBox(),
                              items: outletlist,
                              value: selectedoutlets,
                              hint: "Select Outlet",
                              searchHint: "Select Outlet",
                              onChanged: (value) {
                                setState(() {
                                  selectedoutlets = value;
                                });
                              },
                              isExpanded: true,
                            ),
                          ),
                          Container(
                            height: 55.0,
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom:10.0,top: 10.0),
                            padding: EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: TextFormField(
                              onChanged: (value){
                                setState(() {

                                  itemno = int.tryParse(_checklist.text);
                                  print(itemno);
                                });

                              },
                              keyboardType: TextInputType.number,
                              controller: _checklist,
                              cursorColor: grey,
                              validator: (input) => !input.isNotEmpty
                                  ? "Field should not be empty"
                                  : null,
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                focusColor: orange,
                                hintText: "Number Of Check List Items Required",
                                hintStyle: TextStyle(
                                  color: grey,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                          itemno!= null && itemno<21
                              ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Task Details :",style: TextStyle(color: orange),),
                          ):SizedBox(),

                          itemno!= null
                              ? Form(
                            key: checklistkey,
                            child: new ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: itemno,
                                itemBuilder: (BuildContext context, int index) {
                                  listctrl.add(TextEditingController());

                                  return Container(
                                      padding: EdgeInsets.all(10.0),
                                      margin: EdgeInsets.only(bottom: 10.0, top: 5.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(Radius.circular(10))),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          Container(
                                            height: 20,
                                            width: double.infinity,
                                            margin: EdgeInsets.only(bottom:10.0,top: 10.0),
                                            padding: EdgeInsets.only(left: 10.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: TextFormField(

                                              keyboardType: TextInputType.text,
                                              controller: listctrl[index],
                                              cursorColor: grey,
                                              validator: (input) => !input.isNotEmpty
                                                  ? "Field should not be empty"
                                                  : null,
                                              decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                focusColor: orange,
                                                hintText: "Enter Task ${index + 1} details",
                                                hintStyle: TextStyle(
                                                  color: grey,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ));
                                }),
                          ) : SizedBox(),
                          Center(
                            child: TextButton(onPressed: ()async{
                              if(validateform()==true)
                                setState(() {
                                  isApiCallProcess = true;
                                });
                                Checklistdata.outletid = outletdata.outletid[outletdata.outletname.indexOf(selectedoutlets)];
                              Checklistdata.tasklist =[];
                                for(int u=0;u<itemno;u++){
                                  Checklistdata.tasklist.add(listctrl[u].text.toString());
                              }
                              await addchecklistdata();


                              setState(() {
                                isApiCallProcess = false;
                              });

                              Flushbar(
                                message: "Check List has been added",
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
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(orange)),
                              child: Text(
                                "SAVE",style: TextStyle(color: Colors.white),
                              ),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  bool validateform() {
    final form = checklistkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

