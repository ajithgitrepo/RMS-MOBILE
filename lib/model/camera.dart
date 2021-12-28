import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:camera/camera.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/Customers%20Activities.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/Visibility.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;
import 'package:photo_view/photo_view.dart';
import 'dart:io';
import 'package:merchandising/Constants.dart';
import 'package:flutter/rendering.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/CompetitionCheckOne.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/PlanogramcheckPhase1.dart';
import 'package:merchandising/Merchandiser/merchandiserscreens/Promotion Check.dart';
import 'dart:convert';
import 'dart:io';
import'package:merchandising/Merchandiser/merchandiserscreens/checklist.dart';
bool takepicplano=false;
bool takepicCL=false;
class TakePictureScreen extends StatefulWidget {
  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State {
  CameraController controller;
  List cameras;
  int selectedCameraIndex;
  String imgPath;

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIndex = 0;
        });
        _initCameraController(cameras[selectedCameraIndex]).then((void v) {});
      } else {
        print('No camera available');
      }
    }).catchError((err) {
      print('Error :${err.code}Error message : ${err.message}');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: _cameraPreviewWidget(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    padding: EdgeInsets.all(15),
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _cameraToggleRowWidget(),
                        _cameraControlWidget(context),
                        GestureDetector(
                          onTap: (){
                            if(Selectedscreen == "visibility"){
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (BuildContext context) => VisibilityOne()));
                            }
                            if(Selectedscreen == "competitioncheck"){
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (BuildContext context) => CompetitionCheckOne()));
                            }
                            if(Selectedscreen == "PromotionCheck"){
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (BuildContext context) => PromotionCheck()));
                            }
                            if(Selectedscreen == "planogram"){
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (BuildContext context) => PlanogramCheckPhase1()));
                            }

                            if(Selectedscreen == "checklistimage"){
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (BuildContext context) => CustomerActivities()));
                            }
                          },
                          child: SizedBox(
                              width:84,
                              child: Padding(
                                padding: const EdgeInsets.only(right:8.0),
                                child: Text("Close",style: TextStyle(color: CupertinoColors.white,fontSize: 18),textAlign: TextAlign.end,),
                              )),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Display Camera preview.
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  /// Display the control bar with buttons to take pictures
  Widget _cameraControlWidget(context) {
    return SizedBox(
      width:84,
      child: FloatingActionButton(
        child: Icon(
          Icons.camera,
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        onPressed: () {
          _onCapturePressed(context);
        },
      ),
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraToggleRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return SizedBox(
      width:84,
      child: TextButton.icon(
        onPressed: _onSwitchCamera,
        icon: Icon(
          _getCameraLensIcon(lensDirection),
          color: Colors.white,
          size: 24,
        ),
        label: Text(
          '${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1).toUpperCase()}',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500
          ),),
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera;
      case CameraLensDirection.front:
        return CupertinoIcons.switch_camera_solid;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error:${e.code}\nError message : ${e.description}';
    print(errorText);
  }

  void _onCapturePressed(context) async {
    try {
      final path =
      join((await getTemporaryDirectory()).path, '${DateTime.now()}.png');
      await controller.takePicture(path);
      imagetaken = path;
      File finalimage = await drawTextOnImage();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => PreviewScreen(
              imgPath: finalimage,
            )),
      );
    } catch (e) {
      _showCameraException(e);
    }
  }

  void _onSwitchCamera() {
    selectedCameraIndex =
    selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    _initCameraController(selectedCamera);
  }
}


class PreviewScreen extends StatefulWidget{
  final File imgPath;

  PreviewScreen({this.imgPath});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();

}
class _PreviewScreenState extends State<PreviewScreen>{
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Stack(
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
                imageProvider: FileImage(widget.imgPath)
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(icon: Icon(Icons.close,color: Colors.white,size: 30,),onPressed: (){
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) => TakePictureScreen()));
                  }),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send,color: orange,),
          backgroundColor: pink,
          onPressed: (){

            if(Selectedscreen == "visibility"){
              images[selected.index]=widget.imgPath;
              var imagebytes = widget.imgPath.readAsBytesSync();
              visibilityreasons[selected.index] = 'data:image/jpeg;base64,${base64Encode(imagebytes)}';
              print(visibilityreasons);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) => VisibilityOne()));
            }
            if(Selectedscreen == "competitioncheck"){
              capturedimage = widget.imgPath;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) => CompetitionCheckOne()));
            }
            if(Selectedscreen == "PromotionCheck"){
              capturedimagepromotion = widget.imgPath;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) => PromotionCheck()));
            }
            if(Selectedscreen == "planogram"){
              setState(() {
                takepicplano=true;
                // takepicCL=true;
              });
              var imagebytes = widget.imgPath.readAsBytesSync();
              ontap == 'before'?
              beforeimages[selectedindex] = widget.imgPath:afterimages[selectedindex]= widget.imgPath;
              ontap == 'before'?
              beforeimagesencode[selectedindex] = 'data:image/jpeg;base64,${base64Encode(imagebytes)}':afterimagesencode[selectedindex]= 'data:image/jpeg;base64,${base64Encode(imagebytes)}';
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) => PlanogramCheckPhase1()));
            }

            if(Selectedscreen == "checklistimage"){
              setState(() {
                takepicCL=true;
              });
              var imgbyts = widget.imgPath.readAsBytesSync();
              imagescl[selectindexcl]  = widget.imgPath;
              encodeimagecl[selectindexcl]='data:image/jpeg;base64,${base64Encode(imgbyts)}';
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (BuildContext context) => UploadLivePhoto()));
            }
          },
        ),
      ),
    );

  }
}
String Selectedscreen;
String  imagetaken;

Future<File> drawTextOnImage() async {
  var image = File(imagetaken);

  var decodeImg = img.decodeImage(image.readAsBytesSync());
  var now = DateTime.now();
  img.drawString(decodeImg, img.arial_48, 0, 0,'${DateFormat.yMd().add_jm().format(now)}');

  var encodeImage = img.encodeJpg(decodeImg, quality: 100);

  var finalImage = File(image.path)..writeAsBytesSync(encodeImage);

  return finalImage;
}


