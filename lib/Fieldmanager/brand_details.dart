import 'package:merchandising/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/MenuContent.dart';
import 'package:merchandising/Fieldmanager/addbrand.dart';
import 'package:merchandising/api/FMapi/brand_detailsapi.dart';


class BrandDetails extends StatefulWidget {
  @override
  _BrandDetailsState createState() => _BrandDetailsState();
}

class _BrandDetailsState extends State<BrandDetails> {
  var _searchview = new TextEditingController();
  bool _firstSearch = true;
  String _query = "";

  List<String> _filterList;
  List<String>_filterClient;
  List<String>_filterField;
  List<String>_filterSales;

  _BrandDetailsState() {
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
          title: Column(
            children: [
              Text("Brand Details",style: TextStyle(color: orange),),
              EmpInfo(),
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
                                AddBrand()));
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
          hintText: 'Search by Brand Name/Code',
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
          itemCount:BrandData.brandname.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(bottom:5.0,top: 5.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Brand Name : ${BrandData.brandname[index]}',
                        style: TextStyle(
                            fontSize: 15.0,fontWeight: FontWeight.bold
                        )),
                    SizedBox(height: 5),
                    Text("Client : ${BrandData.client[index]}",
                        style: TextStyle(
                          fontSize: 14.0,
                        )),
                    SizedBox(height: 5),
                    Text('Field Manager : ${BrandData.fieldmanager[index]}',
                        style: TextStyle(
                          fontSize: 14.0,
                        )),
                    SizedBox(height: 5),
                    Text('Sales Manager : ${BrandData.salesmanager[index]}',
                        style: TextStyle(
                          fontSize: 14.0,
                        )),

                  ],
                ));
          }),
    );
  }

  Widget _performSearch() {
    _filterList = [];
    _filterClient = [];
    _filterField = [];
    _filterSales = [];
    for (int i = 0; i <BrandData.brandname.length; i++) {
      var item = BrandData.brandname[i];
      if (item.toLowerCase().contains(_query.toLowerCase())) {
        _filterList.add(item);
        int index = BrandData.brandname.indexOf(item);
        _filterClient.add(BrandData.client[index]);
        _filterField.add(BrandData.fieldmanager[index]);
        _filterSales.add(BrandData.salesmanager[index]);
      }
    }
    return _createFilteredListView();
  }

  Widget _createFilteredListView() {
    return new Flexible(
      child: new ListView.builder(
          shrinkWrap: true,
          itemCount:  _filterList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(bottom:5.0,top: 5.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Brand Name : ${ _filterList[index]}',
                        style: TextStyle(
                            fontSize: 15.0,fontWeight: FontWeight.bold
                        )),
                    SizedBox(height: 5),
                    Text("Client  : ${_filterClient[index]}",
                        style: TextStyle(
                          fontSize: 14.0,
                        )),
                    SizedBox(height: 5),
                    Text('Field Manager : ${_filterField[index]}',
                        style: TextStyle(
                          fontSize: 14.0,
                        )),
                    SizedBox(height: 5),
                    Text('Sales Manager : ${_filterSales[index]}',
                        style: TextStyle(
                          fontSize: 14.0,
                        )),

                  ],
                ));
          }),
    );
  }
}