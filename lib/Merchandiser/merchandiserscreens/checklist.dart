import 'package:flutter/material.dart';
import 'package:merchandising/api/api_service.dart';
import 'package:merchandising/api/customer_activites_api/add_planogramapi.dart';
import 'package:merchandising/clients/reports.dart';
import '../../Constants.dart';
import 'package:flutter/cupertino.dart';
import '../../ProgressHUD.dart';
import 'MenuContent.dart';
import 'package:merchandising/model/camera.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/Customers Activities.dart';
import 'dart:convert';

int count;
int selectindexcl;

List<File> imagescl = [];
List<String>encodeimagecl=[];

bool checklist = false;

class UploadLivePhoto extends StatefulWidget {
  @override
  _UploadLivePhotoState createState() => _UploadLivePhotoState();
}

class _UploadLivePhotoState extends State<UploadLivePhoto> {


  @override

  bool isApicallProcess = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: containerscolor,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: orange),
        title: Row(
          children: [
            Text(
              'Check List',
              style: TextStyle(color: orange),
            ),
            Spacer(),
            SubmitButton(
              onpress: ()async{
                setState(() {
                  isApicallProcess =true;
                });
                task.imgurl=[];
                task.iscompleted=[];
                print(CheckList);
                for(int i=0;i<task.list.length;i++){
                  print(CheckList[i]);
                  if(CheckList[i]==true)
                  {
                    print("entered loop true");
                    print(encodeimagecl[i].toString());
                    task.iscompleted.add(1);
                    if(encodeimagecl[i].toString() == "dummy.txt"){
                      task.imgurl.add("");
                    }else{
                      task.imgurl.add(encodeimagecl[i]);
                    }
                  }
                  else{
                    print("entered loop false");
                    task.iscompleted.add(0);
                    task.imgurl.add("");
                  }

                }


                await sendtaskresponse();

                setState(() {
                  isApicallProcess=false;
                });

                print(task.imgurl.length);


                print(CheckList);
                int u = 0;
                for (int i = 0; i < CheckList.length; i++) {

                  if (CheckList[i]) {
                    u++;
                  }
                }
                if (u == CheckList.length) {
                  iseverythingchecked = true;
                } else {
                  iseverythingchecked = false;
                }
                if (iseverythingchecked) {
                  setState(() {
                    changecheckoutcolor = true;

                    print(changecheckoutcolor);

                  });
                  checklist=true;
                  Navigator.pop(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext
                          context) =>
                              CustomerActivities()));
                }

                {Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            CustomerActivities()));}
              },
            ),
          ],
        ),
      ),
      // drawer: Drawer(
      //   child: Menu(),
      // ),
      body: Stack(
        children: [
          BackGround(),
          ProgressHUD(
            opacity: 0.3,
            inAsyncCall: isApicallProcess,
            child: Column(
              children: [
                OutletDetails(),
                Column(
                  children: [

                    SizedBox(
                      height: MediaQuery.of(context).size.height/1.3,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: new ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:task.list.length,
                            itemBuilder:
                                (BuildContext
                            context,
                                int index) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: pink,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding:EdgeInsets.all(10.0),
                                margin:EdgeInsets.only(top:10.0,left: 10,right:10),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      CheckList[index] ==
                                          false
                                          ? CheckList[
                                      index] =
                                      true
                                          : CheckList[
                                      index] =
                                      false;
                                    });
                                  },
                                  child: Column(

                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceEvenly,
                                        children: [
                                          Text(
                                            task.list[
                                            index],
                                            style: TextStyle(
                                                fontSize:
                                                16),
                                          ),




                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            margin:EdgeInsets.only(top:10),
                                            // ignore: unrelated_type_equality_checks
                                            child: imagescl[index].toString() !=
                                                'File: \'dummy.txt\''
                                                ? GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext context) =>
                                                            PreveiwScreen(


                                                              input: imagescl[index],
                                                            )));
                                              },
                                              child: Image(
                                                height: 60,
                                                image: FileImage(imagescl[index]),
                                              ),
                                            )
                                                : Image(
                                              height: 60,
                                              image: AssetImage('images/capture.png'),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          GestureDetector(
                                            onTap: (){
                                              Selectedscreen = "checklistimage";
                                              selectindexcl = index;
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext context) =>
                                                          TakePictureScreen(
                                                          )));
                                            },
                                            child:Icon(CupertinoIcons.photo_camera_solid,) ,
                                          ),
                                          SizedBox(width: 10),
                                          Icon(
                                            CheckList[index] ==
                                                true
                                                ? CupertinoIcons
                                                .check_mark_circled_solid
                                                : CupertinoIcons
                                                .xmark_circle_fill,
                                            color: CheckList[index] ==
                                                true
                                                ? orange
                                                : Colors
                                                .grey,
                                            size: 30,
                                          ),

                                        ],
                                      )

                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),

                  ],
                )
              ],
            ),
          ),
          NBlFloatingButton(),
        ],
      ),
    );
  }



}

class SubmitButton extends StatelessWidget {
  SubmitButton({@required this.onpress});
  final onpress;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Container(
        margin:EdgeInsets.only(right:10.00),
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


class VeiwImage extends StatelessWidget {
  VeiwImage({this.url});
  var url;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PhotoView(
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
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left :15.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: FloatingActionButton(
                onPressed: (){
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              UploadLivePhoto()));
                },
                backgroundColor: Colors.black,
                child: Icon(Icons.arrow_back,color: orange,),
              ),
            ),
          ),
        )
      ],
    );
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => UploadLivePhoto()));
                  }
              ),
            ),
          )
        ],
      ),
    );
  }
}
