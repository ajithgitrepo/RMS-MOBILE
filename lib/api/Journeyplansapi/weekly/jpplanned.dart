import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:merchandising/main.dart';
import '../../api_service.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:merchandising/Constants.dart';
import 'package:merchandising/offlinedata/sharedprefsdta.dart';

var jpempid;
String JPweekly;
Future<void> getJourneyPlanweekly() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  JPweekly = prefs.getString('journeyplanweekly');
  if(JPweekly == null|| currentlysyncing){
    Map DBrequestData = {'emp_id': '${DBrequestdata.receivedempid}'};
    Map FmDBrequestData = {'emp_id': '$jpempid'};
    http.Response JPresponse = await http.post(
      WJPPlannedurl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${DBrequestdata.receivedtoken}',
      },
      body: jsonEncode(currentuser.roleid == 6 ? DBrequestData : FmDBrequestData),
    );
    if (JPresponse.statusCode == 200) {
      getweeklyjp.sundaystorenames = [];
      getweeklyjp.mondaystorenames = [];
      getweeklyjp.tuesdaystorenames = [];
      getweeklyjp.wednesdaystorenames = [];
      getweeklyjp.thrusdaystorenames = [];
      getweeklyjp.fridaystorenames = [];
      getweeklyjp.saturdaystorenames = [];

      getweeklyjp.sundaystorecodes = [];
      getweeklyjp.mondaystorecodes = [];
      getweeklyjp.tuesdaystorecodes = [];
      getweeklyjp.wednesdaystorecodes = [];
      getweeklyjp.thrusdaystorecodes = [];
      getweeklyjp.fridaystorecodes = [];
      getweeklyjp.saturdaystorecodes = [];

      getweeklyjp.sundayaddress = [];
      getweeklyjp.mondayaddress = [];
      getweeklyjp.tuesdayaddress = [];
      getweeklyjp.wednesdayaddress = [];
      getweeklyjp.thrusdayaddress = [];
      getweeklyjp.fridayaddress = [];
      getweeklyjp.saturdayaddress = [];

      getweeklyjp.sundaycontactnumbers = [];
      getweeklyjp.mondaycontactnumbers = [];
      getweeklyjp.tuesdaycontactnumbers = [];
      getweeklyjp.wednesdaycontactnumbers = [];
      getweeklyjp.thrusdaycontactnumbers = [];
      getweeklyjp.fridaycontactnumbers = [];
      getweeklyjp.saturdaycontactnumbers = [];

      getweeklyjp.sundaylatitudes = [];
      getweeklyjp.mondaylatitudes = [];
      getweeklyjp.tuesdaylatitudes = [];
      getweeklyjp.wednesdaylatitudes = [];
      getweeklyjp.thrusdaylatitudes = [];
      getweeklyjp.fridaylatitudes = [];
      getweeklyjp.saturdaylatitudes = [];

      getweeklyjp.sundaylongitudes = [];
      getweeklyjp.mondaylongitudes = [];
      getweeklyjp.tuesdaylongitudes = [];
      getweeklyjp.wednesdaylongitudes = [];
      getweeklyjp.thrusdaylongitudes = [];
      getweeklyjp.fridaylongitudes = [];
      getweeklyjp.saturdaylongitudes = [];

      getweeklyjp.sundayid = [];
      getweeklyjp.mondayid = [];
      getweeklyjp.tuesdayid = [];
      getweeklyjp.wednesdayid = [];
      getweeklyjp.thrusdayid = [];
      getweeklyjp.fridayid = [];
      getweeklyjp.saturdayid = [];

      getweeklyjp.timeid = [];
      getweeklyjp.outletid = [];

      currentuser.roleid==5?print('journey plan weekly done'):currentuser.roleid==2?print("journey plan done for merch under CDE"):print("");
      JPweekly = JPresponse.body;
      plannedjpweekly(JPweekly);
      var decodeJPData = jsonDecode(JPweekly);
      for (int u = 0; u < decodeJPData['data'].length; u++) {
        getweeklyjp.timeid.add(decodeJPData['data'][u]['id']);
        getweeklyjp.outletid.add(decodeJPData['data'][u]['outlet_id']);

        dynamic storename = decodeJPData['data'][u]['store_name'];

        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Sunday'
            : decodeJPData['data'][u]['day'] == 'Sunday') {
          getweeklyjp.sundaystorenames.add(storename);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Monday'
            : decodeJPData['data'][u]['day'] == 'Monday') {
          getweeklyjp.mondaystorenames.add(storename);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Tuesday'
            : decodeJPData['data'][u]['day'] == 'Tuesday') {
          getweeklyjp.tuesdaystorenames.add(storename);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Wednesday'
            : decodeJPData['data'][u]['day'] == 'Wednesday') {
          getweeklyjp.wednesdaystorenames.add(storename);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Thursday'
            : decodeJPData['data'][u]['day'] == 'Thursday') {
          getweeklyjp.thrusdaystorenames.add(storename);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Friday'
            : decodeJPData['data'][u]['day'] == 'Friday') {
          getweeklyjp.fridaystorenames.add(storename);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Saturday'
            : decodeJPData['data'][u]['day'] == 'Saturday') {
          getweeklyjp.saturdaystorenames.add(storename);
        }

        dynamic storecode = decodeJPData['data'][u]['store_code'];

        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Sunday'
            : decodeJPData['data'][u]['day'] == 'Sunday') {
          getweeklyjp.sundaystorecodes.add(storecode);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Monday'
            : decodeJPData['data'][u]['day'] == 'Monday') {
          getweeklyjp.mondaystorecodes.add(storecode);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Tuesday'
            : decodeJPData['data'][u]['day'] == 'Tuesday') {
          getweeklyjp.tuesdaystorecodes.add(storecode);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Wednesday'
            : decodeJPData['data'][u]['day'] == 'Wednesday') {
          getweeklyjp.wednesdaystorecodes.add(storecode);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Thursday'
            : decodeJPData['data'][u]['day'] == 'Thursday') {
          getweeklyjp.thrusdaystorecodes.add(storecode);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Friday'
            : decodeJPData['data'][u]['day'] == 'Friday') {
          getweeklyjp.fridaystorecodes.add(storecode);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Saturday'
            : decodeJPData['data'][u]['day'] == 'Saturday') {
          getweeklyjp.saturdaystorecodes.add(storecode);
        }
        dynamic address = decodeJPData['data'][u]['address'];

        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Sunday'
            : decodeJPData['data'][u]['day'] == 'Sunday') {
          getweeklyjp.sundayaddress.add(address);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Monday'
            : decodeJPData['data'][u]['day'] == 'Monday') {
          getweeklyjp.mondayaddress.add(address);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Tuesday'
            : decodeJPData['data'][u]['day'] == 'Tuesday') {
          getweeklyjp.tuesdayaddress.add(address);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Wednesday'
            : decodeJPData['data'][u]['day'] == 'Wednesday') {
          getweeklyjp.wednesdayaddress.add(address);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Thursday'
            : decodeJPData['data'][u]['day'] == 'Thursday') {
          getweeklyjp.thrusdayaddress.add(address);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Friday'
            : decodeJPData['data'][u]['day'] == 'Friday') {
          getweeklyjp.fridayaddress.add(address);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Saturday'
            : decodeJPData['data'][u]['day'] == 'Saturday') {
          getweeklyjp.saturdayaddress.add(address);
        }

        dynamic numbers = decodeJPData['data'][u]['contact_number'];

        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Sunday'
            : decodeJPData['data'][u]['day'] == 'Sunday') {
          getweeklyjp.sundaycontactnumbers.add(numbers);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Monday'
            : decodeJPData['data'][u]['day'] == 'Monday') {
          getweeklyjp.mondaycontactnumbers.add(numbers);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Tuesday'
            : decodeJPData['data'][u]['day'] == 'Tuesday') {
          getweeklyjp.tuesdaycontactnumbers.add(numbers);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Wednesday'
            : decodeJPData['data'][u]['day'] == 'Wednesday') {
          getweeklyjp.wednesdaycontactnumbers.add(numbers);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Thursday'
            : decodeJPData['data'][u]['day'] == 'Thursday') {
          getweeklyjp.thrusdaycontactnumbers.add(numbers);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Friday'
            : decodeJPData['data'][u]['day'] == 'Friday') {
          getweeklyjp.fridaycontactnumbers.add(numbers);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Saturday'
            : decodeJPData['data'][u]['day'] == 'Saturday') {
          getweeklyjp.saturdaycontactnumbers.add(numbers);
        }

        dynamic latitude = decodeJPData['data'][u]['outlet']['outlet_lat'];

        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Sunday'
            : decodeJPData['data'][u]['day'] == 'Sunday') {
          getweeklyjp.sundaylatitudes.add(latitude);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Monday'
            : decodeJPData['data'][u]['day'] == 'Monday') {
          getweeklyjp.mondaylatitudes.add(latitude);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Tuesday'
            : decodeJPData['data'][u]['day'] == 'Tuesday') {
          getweeklyjp.tuesdaylatitudes.add(latitude);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Wednesday'
            : decodeJPData['data'][u]['day'] == 'Wednesday') {
          getweeklyjp.wednesdaylatitudes.add(latitude);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Thursday'
            : decodeJPData['data'][u]['day'] == 'Thursday') {
          getweeklyjp.thrusdaylatitudes.add(latitude);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Friday'
            : decodeJPData['data'][u]['day'] == 'Friday') {
          getweeklyjp.fridaylatitudes.add(latitude);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Saturday'
            : decodeJPData['data'][u]['day'] == 'Saturday') {
          getweeklyjp.saturdaylatitudes.add(latitude);
        }

        dynamic longitude = decodeJPData['data'][u]['outlet']['outlet_long'];

        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Sunday'
            : decodeJPData['data'][u]['day'] == 'Sunday') {
          getweeklyjp.sundaylongitudes.add(longitude);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Monday'
            : decodeJPData['data'][u]['day'] == 'Monday') {
          getweeklyjp.mondaylongitudes.add(longitude);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Tuesday'
            : decodeJPData['data'][u]['day'] == 'Tuesday') {
          getweeklyjp.tuesdaylongitudes.add(longitude);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Wednesday'
            : decodeJPData['data'][u]['day'] == 'Wednesday') {
          getweeklyjp.wednesdaylongitudes.add(longitude);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Thursday'
            : decodeJPData['data'][u]['day'] == 'Thursday') {
          getweeklyjp.thrusdaylongitudes.add(longitude);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Friday'
            : decodeJPData['data'][u]['day'] == 'Friday') {
          getweeklyjp.fridaylongitudes.add(longitude);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Saturday'
            : decodeJPData['data'][u]['day'] == 'Saturday') {
          getweeklyjp.saturdaylongitudes.add(longitude);
        }

        dynamic timesheet = decodeJPData['data'][u]['id'];

        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Sunday'
            : decodeJPData['data'][u]['day'] == 'Sunday') {
          getweeklyjp.sundayid.add(timesheet);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Monday'
            : decodeJPData['data'][u]['day'] == 'Monday') {
          getweeklyjp.mondayid.add(timesheet);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Tuesday'
            : decodeJPData['data'][u]['day'] == 'Tuesday') {
          getweeklyjp.tuesdayid.add(timesheet);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Wednesday'
            : decodeJPData['data'][u]['day'] == 'Wednesday') {
          getweeklyjp.wednesdayid.add(timesheet);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Thursday'
            : decodeJPData['data'][u]['day'] == 'Thursday') {
          getweeklyjp.thrusdayid.add(timesheet);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Friday'
            : decodeJPData['data'][u]['day'] == 'Friday') {
          getweeklyjp.fridayid.add(timesheet);
        }
        if (decodeJPData['data'][u]['day'] == null
            ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
                    .parse(decodeJPData['data'][u]['date'])) ==
                'Saturday'
            : decodeJPData['data'][u]['day'] == 'Saturday') {
          getweeklyjp.saturdayid.add(timesheet);
        }
      }
      currentlysyncing = false;
    } else {
      print(JPresponse.statusCode);
    }
  }else{
    getweeklyjp.sundaystorenames = [];
    getweeklyjp.mondaystorenames = [];
    getweeklyjp.tuesdaystorenames = [];
    getweeklyjp.wednesdaystorenames = [];
    getweeklyjp.thrusdaystorenames = [];
    getweeklyjp.fridaystorenames = [];
    getweeklyjp.saturdaystorenames = [];

    getweeklyjp.sundaystorecodes = [];
    getweeklyjp.mondaystorecodes = [];
    getweeklyjp.tuesdaystorecodes = [];
    getweeklyjp.wednesdaystorecodes = [];
    getweeklyjp.thrusdaystorecodes = [];
    getweeklyjp.fridaystorecodes = [];
    getweeklyjp.saturdaystorecodes = [];

    getweeklyjp.sundayaddress = [];
    getweeklyjp.mondayaddress = [];
    getweeklyjp.tuesdayaddress = [];
    getweeklyjp.wednesdayaddress = [];
    getweeklyjp.thrusdayaddress = [];
    getweeklyjp.fridayaddress = [];
    getweeklyjp.saturdayaddress = [];

    getweeklyjp.sundaycontactnumbers = [];
    getweeklyjp.mondaycontactnumbers = [];
    getweeklyjp.tuesdaycontactnumbers = [];
    getweeklyjp.wednesdaycontactnumbers = [];
    getweeklyjp.thrusdaycontactnumbers = [];
    getweeklyjp.fridaycontactnumbers = [];
    getweeklyjp.saturdaycontactnumbers = [];

    getweeklyjp.sundaylatitudes = [];
    getweeklyjp.mondaylatitudes = [];
    getweeklyjp.tuesdaylatitudes = [];
    getweeklyjp.wednesdaylatitudes = [];
    getweeklyjp.thrusdaylatitudes = [];
    getweeklyjp.fridaylatitudes = [];
    getweeklyjp.saturdaylatitudes = [];

    getweeklyjp.sundaylongitudes = [];
    getweeklyjp.mondaylongitudes = [];
    getweeklyjp.tuesdaylongitudes = [];
    getweeklyjp.wednesdaylongitudes = [];
    getweeklyjp.thrusdaylongitudes = [];
    getweeklyjp.fridaylongitudes = [];
    getweeklyjp.saturdaylongitudes = [];

    getweeklyjp.sundayid = [];
    getweeklyjp.mondayid = [];
    getweeklyjp.tuesdayid = [];
    getweeklyjp.wednesdayid = [];
    getweeklyjp.thrusdayid = [];
    getweeklyjp.fridayid = [];
    getweeklyjp.saturdayid = [];

    getweeklyjp.timeid = [];
    getweeklyjp.outletid = [];
    var decodeJPData = jsonDecode(JPweekly);
    for (int u = 0; u < decodeJPData['data'].length; u++) {
      getweeklyjp.timeid.add(decodeJPData['data'][u]['id']);
      getweeklyjp.outletid.add(decodeJPData['data'][u]['outlet_id']);

      dynamic storename = decodeJPData['data'][u]['store_name'];

      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Sunday'
          : decodeJPData['data'][u]['day'] == 'Sunday') {
        getweeklyjp.sundaystorenames.add(storename);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Monday'
          : decodeJPData['data'][u]['day'] == 'Monday') {
        getweeklyjp.mondaystorenames.add(storename);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Tuesday'
          : decodeJPData['data'][u]['day'] == 'Tuesday') {
        getweeklyjp.tuesdaystorenames.add(storename);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Wednesday'
          : decodeJPData['data'][u]['day'] == 'Wednesday') {
        getweeklyjp.wednesdaystorenames.add(storename);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Thursday'
          : decodeJPData['data'][u]['day'] == 'Thursday') {
        getweeklyjp.thrusdaystorenames.add(storename);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Friday'
          : decodeJPData['data'][u]['day'] == 'Friday') {
        getweeklyjp.fridaystorenames.add(storename);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Saturday'
          : decodeJPData['data'][u]['day'] == 'Saturday') {
        getweeklyjp.saturdaystorenames.add(storename);
      }

      dynamic storecode = decodeJPData['data'][u]['store_code'];

      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Sunday'
          : decodeJPData['data'][u]['day'] == 'Sunday') {
        getweeklyjp.sundaystorecodes.add(storecode);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Monday'
          : decodeJPData['data'][u]['day'] == 'Monday') {
        getweeklyjp.mondaystorecodes.add(storecode);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Tuesday'
          : decodeJPData['data'][u]['day'] == 'Tuesday') {
        getweeklyjp.tuesdaystorecodes.add(storecode);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Wednesday'
          : decodeJPData['data'][u]['day'] == 'Wednesday') {
        getweeklyjp.wednesdaystorecodes.add(storecode);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Thursday'
          : decodeJPData['data'][u]['day'] == 'Thursday') {
        getweeklyjp.thrusdaystorecodes.add(storecode);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Friday'
          : decodeJPData['data'][u]['day'] == 'Friday') {
        getweeklyjp.fridaystorecodes.add(storecode);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Saturday'
          : decodeJPData['data'][u]['day'] == 'Saturday') {
        getweeklyjp.saturdaystorecodes.add(storecode);
      }
      dynamic address = decodeJPData['data'][u]['address'];

      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Sunday'
          : decodeJPData['data'][u]['day'] == 'Sunday') {
        getweeklyjp.sundayaddress.add(address);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Monday'
          : decodeJPData['data'][u]['day'] == 'Monday') {
        getweeklyjp.mondayaddress.add(address);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Tuesday'
          : decodeJPData['data'][u]['day'] == 'Tuesday') {
        getweeklyjp.tuesdayaddress.add(address);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Wednesday'
          : decodeJPData['data'][u]['day'] == 'Wednesday') {
        getweeklyjp.wednesdayaddress.add(address);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Thursday'
          : decodeJPData['data'][u]['day'] == 'Thursday') {
        getweeklyjp.thrusdayaddress.add(address);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Friday'
          : decodeJPData['data'][u]['day'] == 'Friday') {
        getweeklyjp.fridayaddress.add(address);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Saturday'
          : decodeJPData['data'][u]['day'] == 'Saturday') {
        getweeklyjp.saturdayaddress.add(address);
      }

      dynamic numbers = decodeJPData['data'][u]['contact_number'];

      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Sunday'
          : decodeJPData['data'][u]['day'] == 'Sunday') {
        getweeklyjp.sundaycontactnumbers.add(numbers);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Monday'
          : decodeJPData['data'][u]['day'] == 'Monday') {
        getweeklyjp.mondaycontactnumbers.add(numbers);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Tuesday'
          : decodeJPData['data'][u]['day'] == 'Tuesday') {
        getweeklyjp.tuesdaycontactnumbers.add(numbers);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Wednesday'
          : decodeJPData['data'][u]['day'] == 'Wednesday') {
        getweeklyjp.wednesdaycontactnumbers.add(numbers);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Thursday'
          : decodeJPData['data'][u]['day'] == 'Thursday') {
        getweeklyjp.thrusdaycontactnumbers.add(numbers);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Friday'
          : decodeJPData['data'][u]['day'] == 'Friday') {
        getweeklyjp.fridaycontactnumbers.add(numbers);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Saturday'
          : decodeJPData['data'][u]['day'] == 'Saturday') {
        getweeklyjp.saturdaycontactnumbers.add(numbers);
      }

      dynamic latitude = decodeJPData['data'][u]['outlet']['outlet_lat'];

      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Sunday'
          : decodeJPData['data'][u]['day'] == 'Sunday') {
        getweeklyjp.sundaylatitudes.add(latitude);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Monday'
          : decodeJPData['data'][u]['day'] == 'Monday') {
        getweeklyjp.mondaylatitudes.add(latitude);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Tuesday'
          : decodeJPData['data'][u]['day'] == 'Tuesday') {
        getweeklyjp.tuesdaylatitudes.add(latitude);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Wednesday'
          : decodeJPData['data'][u]['day'] == 'Wednesday') {
        getweeklyjp.wednesdaylatitudes.add(latitude);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Thursday'
          : decodeJPData['data'][u]['day'] == 'Thursday') {
        getweeklyjp.thrusdaylatitudes.add(latitude);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Friday'
          : decodeJPData['data'][u]['day'] == 'Friday') {
        getweeklyjp.fridaylatitudes.add(latitude);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Saturday'
          : decodeJPData['data'][u]['day'] == 'Saturday') {
        getweeklyjp.saturdaylatitudes.add(latitude);
      }

      dynamic longitude = decodeJPData['data'][u]['outlet']['outlet_long'];

      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Sunday'
          : decodeJPData['data'][u]['day'] == 'Sunday') {
        getweeklyjp.sundaylongitudes.add(longitude);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Monday'
          : decodeJPData['data'][u]['day'] == 'Monday') {
        getweeklyjp.mondaylongitudes.add(longitude);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Tuesday'
          : decodeJPData['data'][u]['day'] == 'Tuesday') {
        getweeklyjp.tuesdaylongitudes.add(longitude);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Wednesday'
          : decodeJPData['data'][u]['day'] == 'Wednesday') {
        getweeklyjp.wednesdaylongitudes.add(longitude);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Thursday'
          : decodeJPData['data'][u]['day'] == 'Thursday') {
        getweeklyjp.thrusdaylongitudes.add(longitude);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Friday'
          : decodeJPData['data'][u]['day'] == 'Friday') {
        getweeklyjp.fridaylongitudes.add(longitude);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Saturday'
          : decodeJPData['data'][u]['day'] == 'Saturday') {
        getweeklyjp.saturdaylongitudes.add(longitude);
      }

      dynamic timesheet = decodeJPData['data'][u]['id'];

      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Sunday'
          : decodeJPData['data'][u]['day'] == 'Sunday') {
        getweeklyjp.sundayid.add(timesheet);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Monday'
          : decodeJPData['data'][u]['day'] == 'Monday') {
        getweeklyjp.mondayid.add(timesheet);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Tuesday'
          : decodeJPData['data'][u]['day'] == 'Tuesday') {
        getweeklyjp.tuesdayid.add(timesheet);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Wednesday'
          : decodeJPData['data'][u]['day'] == 'Wednesday') {
        getweeklyjp.wednesdayid.add(timesheet);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Thursday'
          : decodeJPData['data'][u]['day'] == 'Thursday') {
        getweeklyjp.thrusdayid.add(timesheet);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Friday'
          : decodeJPData['data'][u]['day'] == 'Friday') {
        getweeklyjp.fridayid.add(timesheet);
      }
      if (decodeJPData['data'][u]['day'] == null
          ? DateFormat('EEEE').format(DateFormat("yyyy-MM-dd")
          .parse(decodeJPData['data'][u]['date'])) ==
          'Saturday'
          : decodeJPData['data'][u]['day'] == 'Saturday') {
        getweeklyjp.saturdayid.add(timesheet);
      }
    }
  }
}

class getweeklyjp {
  static List<String> sundaystorecodes = [];
  static List<String> mondaystorecodes = [];
  static List<String> tuesdaystorecodes = [];
  static List<String> wednesdaystorecodes = [];
  static List<String> thrusdaystorecodes = [];
  static List<String> fridaystorecodes = [];
  static List<String> saturdaystorecodes = [];

  static List<String> sundaystorenames = [];
  static List<String> mondaystorenames = [];
  static List<String> tuesdaystorenames = [];
  static List<String> wednesdaystorenames = [];
  static List<String> thrusdaystorenames = [];
  static List<String> fridaystorenames = [];
  static List<String> saturdaystorenames = [];

  static List<String> sundayaddress = [];
  static List<String> mondayaddress = [];
  static List<String> tuesdayaddress = [];
  static List<String> wednesdayaddress = [];
  static List<String> thrusdayaddress = [];
  static List<String> fridayaddress = [];
  static List<String> saturdayaddress = [];

  static List<int> sundaycontactnumbers = [];
  static List<int> mondaycontactnumbers = [];
  static List<int> tuesdaycontactnumbers = [];
  static List<int> wednesdaycontactnumbers = [];
  static List<int> thrusdaycontactnumbers = [];
  static List<int> fridaycontactnumbers = [];
  static List<int> saturdaycontactnumbers = [];

  static List<String> sundaylatitudes = [];
  static List<String> mondaylatitudes = [];
  static List<String> tuesdaylatitudes = [];
  static List<String> wednesdaylatitudes = [];
  static List<String> thrusdaylatitudes = [];
  static List<String> fridaylatitudes = [];
  static List<String> saturdaylatitudes = [];

  static List<String> sundaylongitudes = [];
  static List<String> mondaylongitudes  = [];
  static List<String> tuesdaylongitudes  = [];
  static List<String> wednesdaylongitudes  = [];
  static List<String> thrusdaylongitudes  = [];
  static List<String> fridaylongitudes  = [];
  static List<String> saturdaylongitudes  = [];

  static List<int> sundayid = [];
  static List<int> mondayid   = [];
  static List<int> tuesdayid   = [];
  static List<int> wednesdayid   = [];
  static List<int> thrusdayid   = [];
  static List<int> fridayid   = [];
  static List<int> saturdayid   = [];

  static List<dynamic> timeid = [];
  static List<dynamic> outletid = [];
}
