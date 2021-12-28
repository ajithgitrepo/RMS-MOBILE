import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:merchandising/Fieldmanager/brand_details.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/MenuContent.dart';
import 'package:merchandising/Constants.dart';
import 'package:merchandising/Fieldmanager/Category_details.dart';
import 'package:merchandising/Fieldmanager/editbrands_to_outlets.dart';
import 'package:merchandising/Fieldmanager/product_details.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/checklist.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'outletbrandmapping.dart';
import 'package:merchandising/Fieldmanager/addpromotion.dart';
import 'package:merchandising/api/FMapi/outlet brand mappingapi.dart';
import 'add_check_list.dart';
import 'package:merchandising/Fieldmanager/FMdashboard.dart';
import'package:merchandising/Fieldmanager/add_plano.dart';
import'package:merchandising/Fieldmanager/category_map.dart';
import'package:merchandising/Fieldmanager/add_nbl.dart';



List<String> InputListoutletname=[];
List<String> distantlistaddress=[] ;
List<String> distantlistcontact=[];
List<int> distantlistoutletid=[];


class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool isApiCallProcess = false;
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: containerscolor,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: (){
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder:
                            (BuildContext context) =>
                                FieldManagerDashBoard ()));
              },
              child: Icon(CupertinoIcons.back,size: 30,)),
          iconTheme: IconThemeData(color: orange),
          title: Column(
            children: [
              Text(
                'Activities',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductContainer(
                    text: "Brand",
                    onpress: (){
                    Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (BuildContext context) =>
                                 BrandDetails()));
                   },
                  ),
                 //  ProductContainer(text: "Category",
                 // onpress:(){
                 //   Navigator.push(
                 //       context,
                 //       MaterialPageRoute(
                 //           builder: (BuildContext context) =>
                 //               CategoryDetails()));
                 // } ,
                 // ),



                  // ProductContainer(text: "Outlet Category Mapping",
                  //   onpress:(){
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (BuildContext context) =>
                  //                 AddCategoryMap()));
                  //
                  //   } ,
                  // ),
                  ProductContainer(text: "Product Details",
                    onpress:(){

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  ProductDetails()));
                    } ,
                  ),
                  ProductContainer(text: "Add Promotion Details",
                    onpress:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddPromotion()));
                    } ,
                  ),
                  ProductContainer(
                    text: "Mapped Outlets",
                    onpress:()async{
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  OutletsmapedtoBrands()));
                    } ,
                  ),
                  // ProductContainer(text: "Add Planogram to Outlets",
                  //   onpress:(){
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (BuildContext context) =>
                  //                 AddPlanoFM()));
                  //   } ,
                  // ),
                  ProductContainer(text: "Add Check List Details",
                    onpress:(){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  CheckList()));

                    } ,
                  ),

                  ProductContainer(text: "Add NBL",
                    onpress:()async{


                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddNBL()));

                    } ,
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

class ProductContainer extends StatelessWidget {
  ProductContainer({this.text,this.onpress,this.icon});
  final text;
  final onpress;
  final icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(top:10.0,left: 10.0,right: 10.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: pink,borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text,style: TextStyle(fontSize: 16.0),textAlign: TextAlign.center,),
            Icon(CupertinoIcons.right_chevron,color: orange,)
          ],
        ),

      ),
    );
  }
}










