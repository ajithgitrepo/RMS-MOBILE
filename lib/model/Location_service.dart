import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:merchandising/api/api_service.dart';
import 'package:geocoder/geocoder.dart';
import 'package:merchandising/offlinedata/syncsendapi.dart';
import 'distanceinmeters.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:merchandising/Constants.dart';
double lat;
double long;
String currentlocation;
var splittime = checkinoutdata.checkintime;
class Locationclass {
  double latitude;
  double longitude;

  Future<void> getCurrentLocation() async {
    try{
      Position position = await Geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
      latitude = position.latitude;
      longitude = position.longitude;
    } catch(e){
      print(e);
    }
  }
}

 Future<bool> getLocation() async {
   try{
       Locationclass location = Locationclass();
       await location.getCurrentLocation();
       lat = location.latitude;
       long = location.longitude;
       distinmeters();
       return lat==null?false:true;
   }catch(e){
     lat=0.00000;
     long=0.00000;
     CreateLog("location couldn't received due to $e", "false");
   }
}

address() async {
  final coordinates = new Coordinates(lat,long);
  print(coordinates);
  var addresses = await Geocoder.local.findAddressesFromCoordinates(
      coordinates);
  var first = addresses.first;
  getaddress.currentaddress = '${first.addressLine}';
}

class getaddress {
  static var currentaddress;
}

 SubmitCheckin() async {
   createlog("Check In tapped","true");
    try{
      await getLocation();
      print(lat);
      print(long);
      await address();
      var now = DateTime.now();
      checkinoutdata.checkintime = DateFormat('HH:mm:ss').format(now);
      print(checkinoutdata.checkintime);
      checkinoutdata.checkinlocation = "${getaddress.currentaddress}($lat,$long)";
      await checkin();
    }catch(e){
      await getLocation();
      createlog("address issue at online mode : ", "false");
      var now = DateTime.now();
      checkinoutdata.checkintime = DateFormat('HH:mm:ss').format(now);
      checkinoutdata.checkinlocation = "offline mode unable to get address ($lat,$long)";
      await checkin();
    }

 }

 SubmitCheckout() async {
   createlog("Check Out tapped","true");
   if(onlinemode.value) {
     try{
      await getLocation();
      await address();
      var now = DateTime.now();
      checkinoutdata.checkouttime = DateFormat('HH:mm:ss').format(now);
      checkinoutdata.checkoutlocation =
          "${getaddress.currentaddress}($lat,$long)";
      await checkout();
    }catch(e){
       createlog("address issue at online mode : ", "false");
       var now = DateTime.now();
       checkinoutdata.checkouttime = DateFormat('HH:mm:ss').format(now);
       checkinoutdata.checkoutlocation = "unable to get address in online mode";
       await checkout();
     }
  }else{
     var now = DateTime.now();
     checkinoutdata.checkouttime = DateFormat('HH:mm:ss').format(now);
     checkinoutdata.checkoutlocation = "offline unable to get location";
     await checkout();
   }

}

// ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}