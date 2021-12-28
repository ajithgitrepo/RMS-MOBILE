import 'package:merchandising/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/Fieldmanager/mappedoutlets.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/MenuContent.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'package:merchandising/api/FMapi/add_checklist_api.dart';
import 'package:merchandising/api/api_service.dart';
import 'editbrands_to_outlets.dart';
import 'package:merchandising/api/FMapi/outlet brand mappingapi.dart';
import 'products.dart';
import 'package:photo_view/photo_view.dart';
import 'package:merchandising/Fieldmanager/promo_details.dart';
import 'package:merchandising/api/FMapi/promotion_detailsapi.dart';

import 'package:merchandising/api/FMapi/outletapi.dart';

int _selectedIndex = 0;

int countindex;


bool contcolor=false;

var Selectedoutlet;
 var Selectedoutletaddress;
 var Selectedoutletcontactnumber;
// List<String> Selectedbrandname;
// List<String> Selectedplanogram;
// List<String> Selectedshelf;
// List<String> Selectedtarget;

class OutletsmapedtoBrands extends StatefulWidget {
  @override
  _OutletsmapedtoBrandsState createState() => _OutletsmapedtoBrandsState();
}

class _OutletsmapedtoBrandsState extends State<OutletsmapedtoBrands> {
  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }
  var _searchview = new TextEditingController();
  bool _firstSearch = true;
  String _query = "";

  List<String> _filterList;
  List<String>_filteraddress;
  List<String>_filtercontact;
  List<int> _filterindex;


  _OutletsmapedtoBrandsState() {
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
        opacity: 0.3,
        inAsyncCall: isApiCallProcess,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: pink,
            iconTheme: IconThemeData(color: orange),
            title: Column(
              children: [
                Text("Mapped Outlets",style: TextStyle(color: orange),),
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
                                  EditBrandstoOutlet()));
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
          hintText: 'Search by Outlet Name/Code',
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
          shrinkWrap: true,
          itemCount:outletdata.outletname.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: ()async{

                currentoutletid = outletdata.outletid[index];
                setState(() {
                  isApiCallProcess = true;
                });
                getTaskListFM();
                getPromoDetails();
                await getmappedoutlets();

                setState(() {
                  isApiCallProcess = false;
                });
                Selectedoutlet = outletdata.outletname[index];
                Selectedoutletaddress = outletdata.address[index];
                Selectedoutletcontactnumber = outletdata.contactnumber[index];
                print(Selectedoutlet);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            MappedOutlets()));
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
                      Text('${outletdata.outletname[index]}',
                          style: TextStyle(
                              fontSize: 14.0,fontWeight: FontWeight.bold
                          )),
                      SizedBox(height: 5),
                      Text('${outletdata.address[index]}'),
                      SizedBox(height: 5),
                      Text('Contact Number : ${outletdata.contactnumber[index].toString()}'),
                      SizedBox(height: 5),
                      Text('Location : ${outletdata.outletarea[index]},${outletdata.outletcity[index]},${outletdata.outletstate[index]},${outletdata.outletcountry[index]}',
                          style: TextStyle(
                            fontSize: 14.0,
                          )),
                    ],
                  ))
            );
          }),
    );
  }

  Widget _performSearch() {
    _filterList = [];
    _filterindex =[];
    for (int i = 0; i <outletdata.outletname.length; i++) {
      var item = outletdata.outletname[i];
      if (item.toLowerCase().contains(_query.toLowerCase())) {
        _filterList.add(item);
        int index = outletdata.outletname.indexOf(item);
        _filterindex.add(index);
      }
    }
    return _createFilteredListView();
  }

  Widget _createFilteredListView() {
    return new Flexible(
      child: new ListView.builder(
          shrinkWrap: true,
          itemCount:_filterList.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
                onTap: ()async{
                  currentoutletid = outletdata.outletid[_filterindex[index]];
                  setState(() {
                    isApiCallProcess = true;
                  });
                  getTaskListFM();

                  for(int i=0;i<taskFM.id.length;i++){
                    taskFM.list.add(" ");
                  }
                  getPromoDetails();
                  await getmappedoutlets();

                  setState(() {
                    isApiCallProcess = false;
                  });
                  Selectedoutlet = outletdata.outletname[_filterindex[index]];
                  Selectedoutletaddress = outletdata.address[_filterindex[index]];
                  Selectedoutletcontactnumber = outletdata.contactnumber[_filterindex[index]];
                  print(Selectedoutlet);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              MappedOutlets()));
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
                        Text('${outletdata.outletname[_filterindex[index]]}',
                            style: TextStyle(
                                fontSize: 14.0,fontWeight: FontWeight.bold
                            )),
                        SizedBox(height: 5),
                        Text('${outletdata.address[_filterindex[index]]}'),
                        SizedBox(height: 5),
                        Text('Contact Number : ${outletdata.contactnumber[_filterindex[index]].toString()}'),
                        SizedBox(height: 5),
                        Text('Location : ${outletdata.outletarea[_filterindex[index]]},${outletdata.outletcity[_filterindex[index]]},${outletdata.outletstate[_filterindex[index]]},${outletdata.outletcountry[_filterindex[index]]}',
                            style: TextStyle(
                              fontSize: 14.0,
                            )),
                      ],
                    ))
            );
          }),
    );
  }
}

class MappedOutlets extends StatefulWidget {
  @override
  _MappedOutletsState createState() => _MappedOutletsState();
}

class _MappedOutletsState extends State<MappedOutlets> {
  bool isApiCallProcess =false;

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      opacity: 0.3,
      inAsyncCall: isApiCallProcess,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: pink,
          iconTheme: IconThemeData(color: orange),
          title: Text("Mapped outlets",style: TextStyle(color: orange),),
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
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10.0),
                  padding: EdgeInsets.all(5.00),
                  decoration: BoxDecoration(
                      color: pink,
                      borderRadius: BorderRadiusDirectional.circular(10)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: 10.0),
                        Icon(
                          Icons.house_sharp,
                          color: iconscolor,size: 40,
                        ),
                        SizedBox(width: 10.0),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Selectedoutlet,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                            Padding(
                              padding: const EdgeInsets.only(left:5.0),
                              child: Text(Selectedoutletaddress),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
                  Padding(
                    padding: const EdgeInsets.only(left:15.0,right: 10.0,bottom: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Promotion Details: "),
                            GestureDetector(
                              onTap: ()async{
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            PromoDetailsUI()));
                              },
                              child: Container(
                                margin: EdgeInsets.only(top:10.0),                                      padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: pink,
                                    borderRadius: BorderRadius.all(Radius.circular(10))),
                                child: Text("Veiw",style: TextStyle(color:orange),),
                              ),
                            )
                          ],
                        ),
                        Text("Categories :",)
                      ],
                    ),
                  ),


                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount:Distictcategorylist.length,
                      itemBuilder: (BuildContext context, int index) {


                        return Selectedoutlet == mapping.outletname[index] ? Container(
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.only(left:10.0,bottom: 10.0,right: 10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(10))),
                            width: double.infinity,
                            child: Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${Distictcategorylist[index]}',
                                        style: TextStyle(
                                            fontSize: 15.0,fontWeight: FontWeight.bold
                                        )),
                                    SizedBox(height: 5),
                                    Text('SOS Target : ${mapping.target[index]}%',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                        )),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text("Planogram Image : "),
                                    //     GestureDetector(
                                    //       onTap: (){
                                    //         print(Selectedimage);
                                    //         Selectedimage = mapping.planogramimage[index];
                                    //         print('https://rms2.rhapsody.ae/planogram_image/$Selectedimage');
                                    //         Navigator.push(
                                    //             context,
                                    //             MaterialPageRoute(
                                    //                 builder: (BuildContext context) =>
                                    //                     VeiwImage()));
                                    //       },
                                    //       child: Container(
                                    //         margin: EdgeInsets.only(top: 10.0),
                                    //         padding: EdgeInsets.all(10.0),
                                    //         decoration: BoxDecoration(
                                    //             color: orange,
                                    //             borderRadius: BorderRadius.all(Radius.circular(10))),
                                    //         child: Text("Veiw",style: TextStyle(color: Colors.white),),
                                    //       ),
                                    //     )
                                    //   ],
                                    // ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: (){
                                    showDialog(
                                        context: context,
                                        builder: (_) => StatefulBuilder(
                                            builder: (context, setState) {
                                              return ProgressHUD(
                                                inAsyncCall: isApiCallProcess,
                                                opacity: 0.3,
                                                child: AlertDialog(
                                                  backgroundColor: Colors.white,//alertboxcolor,
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
                                                          Text('Alert',style: TextStyle(color: orange,fontSize: 20),),
                                                          Divider(color: Colors.black,),
                                                          Text("Do you want to remove this category for the outlet",textAlign: TextAlign.center,),
                                                          SizedBox(height: 15,),
                                                          GestureDetector(
                                                            onTap: () async{
                                                              setState(() {
                                                                isApiCallProcess = true;
                                                              });
                                                              delcategoryid = mapping.opmid[index];
                                                              await delcategory();

                                                              setState(() {
                                                                isApiCallProcess = false;
                                                              });

                                                              Navigator.pop(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (BuildContext context) =>
                                                                          OutletsmapedtoBrands()));


                                                            },
                                                            child: Container(
                                                              height: 30,
                                                              width: 70,
                                                              decoration: BoxDecoration(
                                                                color: orange,borderRadius: BorderRadius.circular(5),
                                                              ),
                                                              child: Center(child: Text('ok',style: TextStyle(color: Colors.white))),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            }));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right:5.0),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                        child: Icon(Icons.delete,color: Colors.red,)),
                                  ),
                                )
                              ],
                            )) : SizedBox();
                      }),
                  // Padding(
                  //   padding: const EdgeInsets.only(left:10.0),
                  //   child: Text("Check List:"),
                  // ),
                  // SizedBox(height: 10),
                  //
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //     physics: NeverScrollableScrollPhysics(),
                  //     itemCount:taskFM.list.length,
                  //     itemBuilder: (BuildContext context, int index) {
                  //
                  //       return Container(
                  //             padding: EdgeInsets.all(10.0),
                  //             margin: EdgeInsets.only(left:10.0,bottom: 10.0,right: 10.0),
                  //             decoration: BoxDecoration(
                  //                 color:  Colors.white,
                  //                 borderRadius: BorderRadius.all(Radius.circular(10))),
                  //             width: double.infinity,
                  //             child: Stack(
                  //               children: [
                  //                 Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: [
                  //                     Text('${taskFM.list[index]}',
                  //                         style: TextStyle(
                  //                             fontSize: 14
                  //                         )),
                  //                   ],
                  //                 ),
                  //                 GestureDetector(
                  //                   onTap: (){
                  //                     showDialog(
                  //                         context: context,
                  //                         builder: (_) => StatefulBuilder(
                  //                             builder: (context, setState) {
                  //                               return ProgressHUD(
                  //                                 inAsyncCall: isApiCallProcess,
                  //                                 opacity: 0.3,
                  //                                 child: AlertDialog(
                  //                                   backgroundColor: Colors.white,//alertboxcolor,
                  //                                   shape: RoundedRectangleBorder(
                  //                                       borderRadius:
                  //                                       BorderRadius.all(
                  //                                           Radius.circular(10.0))),
                  //                                   content: Builder(
                  //                                     builder: (context) {
                  //                                       // Get available height and width of the build area of this widget. Make a choice depending on the size.
                  //                                       return Column(
                  //                                         mainAxisSize: MainAxisSize.min,
                  //                                         children: [
                  //                                           Text('Alert',style: TextStyle(color: orange,fontSize: 20),),
                  //                                           Divider(color: Colors.black,),
                  //                                           Text("Do you want to deactivate this Task",textAlign: TextAlign.center,),
                  //                                           SizedBox(height: 15,),
                  //                                           GestureDetector(
                  //                                             onTap: () async{
                  //                                               setState(() {
                  //                                                 isApiCallProcess = true;
                  //                                               });
                  //
                  //                                               taskdecativate=taskFM.id[index];
                  //                                               currentoutletid=outletdata.outletid[index];
                  //
                  //
                  //                                               await deactivateCL();
                  //
                  //                                               await getTaskListFM();
                  //                                               setState(() {
                  //                                                 isApiCallProcess = false;
                  //
                  //                                               });
                  //
                  //                                               Navigator.pop(
                  //                                                   context,
                  //                                                   MaterialPageRoute(
                  //                                                       builder: (BuildContext context) =>
                  //                                                           OutletsmapedtoBrands()));
                  //                                             },
                  //                                             child: Container(
                  //                                               height: 30,
                  //                                               width: 70,
                  //                                               decoration: BoxDecoration(
                  //                                                 color: orange,borderRadius: BorderRadius.circular(5),
                  //                                               ),
                  //                                               child: Center(child: Text('Yes',style: TextStyle(color: Colors.white))),
                  //                                             ),
                  //                                           ),
                  //                                         ],
                  //                                       );
                  //                                     },
                  //                                   ),
                  //                                 ),
                  //                               );
                  //                             }));
                  //                   },
                  //                   child: Padding(
                  //                     padding: const EdgeInsets.only(right:5.0),
                  //                     child: Align(
                  //                         alignment: Alignment.topRight,
                  //                         child: Icon(Icons.delete,color: Colors.red,)),
                  //                   ),
                  //                 )
                  //               ],
                  //             ));
                  //     }),




                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
var Selectedimage;
class VeiwImage extends StatelessWidget {
  String url =
      "https://rms2.rhapsody.ae/planogram_image/$Selectedimage";
  @override
  Widget build(BuildContext context) {
    return PhotoView(
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
    );
  }
}
