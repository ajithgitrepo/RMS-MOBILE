import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/Customers%20Activities.dart';
import 'package:merchandising/ProgressHUD.dart';
import 'CompetitonCheckTwo.dart';
import 'MenuContent.dart';
import 'dart:convert';
import '../../Constants.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:merchandising/model/camera.dart';
import 'package:camera/camera.dart';
import 'package:merchandising/api/customer_activites_api/Competitioncheckapi.dart';
import 'package:merchandising/api/customer_activites_api/add_competitionapi.dart';
import'package:merchandising/api/api_service.dart';
import'package:shared_preferences/shared_preferences.dart';
import'package:merchandising/offlinedata/sharedprefsdta.dart';
import'package:merchandising/main.dart';
var capturedcopmtnimg;
var imagesbytes;
bool compcheck = false;
TextEditingController itemname = TextEditingController();
TextEditingController promtdescp = TextEditingController();
TextEditingController mrp = TextEditingController();
TextEditingController sellingprice = TextEditingController();
TextEditingController company = TextEditingController();
TextEditingController category = TextEditingController();
TextEditingController promotiontype = TextEditingController();
TextEditingController promodscrptn = TextEditingController();
File capturedimage = File('dummy.txt');

class CompetitionCheckOne extends StatefulWidget {
  @override
  _CompetitionCheckOneState createState() => _CompetitionCheckOneState();
}

class _CompetitionCheckOneState extends State<CompetitionCheckOne> {
  // final GlobalKey<_CompetitionCheckOneState> _pdfViewerKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    SaveCompetitionData();
  }
  GlobalKey<FormState> products = GlobalKey<FormState>();


  GlobalKey<FormState> keyone = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: containerscolor,
        iconTheme: IconThemeData(color: orange),
        title: Row(
          children: [
            Text(
              'Competition Check',
              style: TextStyle(color: orange),
            ),
            Spacer(),
            SubmitButton(
              onpress: () async{
                if ( validateform() == true &&  capturedimage.toString() != 'File: \'dummy.txt\'') {
                    AddCompData.timesheetid = currenttimesheetid;
                    AddCompData.companyname = company.text;
                    AddCompData.brandname = category.text;
                    AddCompData.itemname = itemname.text;
                    AddCompData.promotype = promotiontype.text;
                    AddCompData.mrp = mrp.text;
                    AddCompData.sellingprice = sellingprice.text;
                    AddCompData.promodesc =promodscrptn.text;
                    imagesbytes =capturedimage.readAsBytesSync();
                    AddCompData.captureimg ='data:image/jpeg;base64,${base64Encode(imagesbytes)}';
                    capturedcopmtnimg = AddCompData.captureimg;
                    setState(() {
                      isApiCallProcess = false;
                    });
                    compcheck= true;
                    setState(() {
                      isApiCallProcess = true;
                    });
                    await addCompetition();
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString("companydata","${company.text}");
                    prefs.setString("categorydata",category.text);
                    prefs.setString("itemdata",itemname.text);
                    prefs.setString("promotypedata",promotiontype.text);
                    prefs.setString("promodescdata",promodscrptn.text);
                    prefs.setString("regpricedata",mrp.text);
                    prefs.setString("sellpricedata",sellingprice.text);
                    // prefs.setString("capimgdata", "${capturedcopmtnimg}");
                    // print("captured img: ${capturedcopmtnimg}");


                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CustomerActivities()));
                  }else if(AddCompData.captureimg == null){
                  print("No captured Img");

                  Flushbar(
                    message: "Please capture the image before submitting",
                    duration: Duration(seconds: 5),
                  )..show(context);
                }
                else{
                  setState(() {
                    isApiCallProcess=false;
                  });
                }
                }
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: onlinemode.value ?0:25,
                    ),
                    OutletDetails(),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.all(10),
                      child: Form(
                        key: keyone,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 30,
                              width: 120,
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                color: orange,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0)),
                              ),
                              child: Center(
                                  child: Text(
                                    "Competitor Info",
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.00),
                              decoration: BoxDecoration(
                                  color: pink, borderRadius: BorderRadius.circular(10.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    //margin: EdgeInsets.only(top: 10.0),
                                    padding: EdgeInsets.only(left:10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TextFormField(
                                      controller: company,
                                      cursorColor: grey,
                                      validator: (input) =>
                                      !input.isNotEmpty ? "Company Name should not be empty" : null,
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusColor: orange,
                                        hintText: "Company Name",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0,

                                        ),
                                      ),
                                    ),
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(top: 10.0),
                                    padding: EdgeInsets.only(left:10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TextFormField(
                                      controller: category,
                                      cursorColor: grey,
                                      validator: (input) =>
                                      !input.isNotEmpty ? "Category Name should not be empty" : null,
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusColor: orange,
                                        hintText: "Category Name",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.0),
                                    padding: EdgeInsets.only(left:10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TextFormField(
                                      controller: itemname,
                                      cursorColor: grey,
                                      validator: (input) =>
                                      !input.isNotEmpty ? "Item should not be empty" : null,
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusColor: orange,
                                        hintText: "Item Name",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.0),
                                    padding: EdgeInsets.only(left:10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TextFormField(
                                      controller: promotiontype,
                                      cursorColor: grey,
                                      validator: (input) =>
                                      !input.isNotEmpty ? "Promotion Type should not be empty" : null,
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusColor: orange,
                                        hintText: "Promotion Type",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.0),
                                    padding: EdgeInsets.only(left:10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TextFormField(
                                      controller: promodscrptn,
                                      cursorColor: grey,
                                      maxLines: 3,
                                      validator: (input) =>
                                      !input.isNotEmpty ? "Promotion Description should not be empty" : null,
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusColor: orange,
                                        hintText: "Promotion Description",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.0),
                                    padding: EdgeInsets.only(left:10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TextFormField(
                                      controller: mrp,
                                      cursorColor: grey,
                                      validator: (input) =>
                                      !input.isNotEmpty ? "regular price should not be empty" : null,
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusColor: orange,
                                        hintText: "Enter Regular Price",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10.0),
                                    padding: EdgeInsets.only(left:10.0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: TextFormField(
                                      controller: sellingprice,
                                      cursorColor: grey,
                                      validator: (input) => !input.isNotEmpty
                                          ? "Selling Price should not be empty"
                                          : null,
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        focusColor: orange,
                                        hintText: "Enter Selling Price Here",
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left:10.0),
                                    child: Row(
                                      children: [
                                        Text("Capture Image"),
                                        Spacer(),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child:
                                          // ignore: unrelated_type_equality_checks
                                         capturedimage.toString() != 'File: \'dummy.txt\''
                                              ? GestureDetector(
                                            onTap: () {
                                              print(base64Image);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext context) =>
                                                          PreveiwScreen(
                                                            input: capturedimage,
                                                          )));
                                            },
                                            child: Image(
                                              height: 50,
                                              width: 50,
                                              image:base64Image!=null?"data:image/jpeg;base64, ${base64Image}":FileImage(capturedimage),
                                            ),
                                          )
                                              : Image(
                                            width: 50,
                                            image: AssetImage('images/capture.png'),
                                          ),
                                        ),
                                        IconButton(
                                            icon: Icon(
                                              CupertinoIcons.photo_camera_solid,
                                              color: Colors.grey[700],
                                            ),
                                            onPressed: () {
                                              _showSelectionDialog(context);
                                            }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            NBlFloatingButton(
              //key: _pdfViewerKey,
            ),
          ],
        ),
      ),
    );
  }
  bool validateform() {
    final form = keyone.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}


class PreveiwScreen extends StatelessWidget {
  PreveiwScreen({@required this.input});
  File input;
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
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  imageProvider: FileImage(input)),
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
                            builder: (BuildContext context) => CompetitionCheckOne()));
                  }
              ),
            ),
          )
        ],
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
                      Selectedscreen ="competitioncheck";
                      WidgetsFlutterBinding.ensureInitialized();

                      // Obtain a list of the available cameras on the device.
                      final cameras = await availableCameras();

                      // Get a specific camera from the list of available cameras.
                      final firstCamera = cameras.first;
                      Navigator.push(
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
                        capturedimage = file;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CompetitionCheckOne()));
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




var promodescptn;
class DropdownSelectCompany extends StatefulWidget {
  @override
  _DropdownSelectCompanyState createState() => _DropdownSelectCompanyState();
}

String selectcompanydropdown;

class _DropdownSelectCompanyState extends State<DropdownSelectCompany> {
  static List DropDownItems =  competitiondata.company.toSet().toList().map((String val) {
    return new DropdownMenuItem<String>(
      value: val,
      child: new Text(val),
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: DropdownButton(
        underline: SizedBox(),
        elevation: 0,
        dropdownColor: Colors.white,
        isExpanded: true,
        iconEnabledColor: orange,
        iconSize: 35.0,
        value: selectcompanydropdown,
        onChanged: (newVal) {
          setState(() {
            selectcompanydropdown = newVal;
          });
        },
        items: DropDownItems,
        hint: Text(
          "Select Company",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}

class DropdownSelectBrand extends StatefulWidget {
  @override
  _DropdownSelectBrandState createState() => _DropdownSelectBrandState();
}

String selectbranddropdown;

class _DropdownSelectBrandState extends State<DropdownSelectBrand> {
  int dropDownValue = 0;
  static List DropDownItems =
  competitiondata.brand.toSet().toList().map((String val) {
    return new DropdownMenuItem<String>(
      value: val,
      child: new Text(val),
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: DropdownButton(
        underline: SizedBox(),
        elevation: 0,
        dropdownColor: Colors.white,
        isExpanded: true,
        iconEnabledColor: orange,
        iconSize: 35.0,
        value: selectbranddropdown,
        onChanged: (newVal) {
          setState(() {
            selectbranddropdown = newVal;
          });
        },
        items: DropDownItems,
        hint: Text(
          "Select category",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}



String selectpromotiondropdown;



class SubmitButton extends StatelessWidget {
  SubmitButton({@required this.onpress});
  final onpress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
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

