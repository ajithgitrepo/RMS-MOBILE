// import 'dart:convert';
// import 'package:merchandising/Constants.dart';
// import 'package:merchandising/offlinedata/syncsendapi.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:background_fetch/background_fetch.dart';
// import 'dart:io';
//
//
// // /// This "Headless Task" is run when app is terminated.
// // void backgroundFetchHeadlessTask(HeadlessTask task) async {
// //   try {
// //     final result = await InternetAddress.lookup('example.com');
// //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
// //
// //       createlog("back ground sync started Active data found", true);
// //       print('connected');
// //       var taskId = task.taskId;
// //       var timeout = task.timeout;
// //       if (timeout) {
// //         createlog("back ground sync timed out ", false);
// //         BackgroundFetch.finish(taskId);
// //         return;
// //       }
// //       SharedPreferences prefs = await SharedPreferences.getInstance();
// //       requireurlstosync =  prefs.getStringList('addtoserverurl');
// //       if(requireurlstosync!=null){
// //         requireurlstosync =  prefs.getStringList('addtoserverurl');
// //         requirebodytosync =  prefs.getStringList('addtoserverbody');
// //         message =  prefs.getStringList('addtoservermessage');
// //       }else{
// //         requireurlstosync=[];
// //         requirebodytosync=[];
// //         message =[];
// //       }
// //       if (message.length > 0) {
// //         await syncingsenddata();
// //       }else{
// //         createlog("back ground sync done no data found to sync", true);
// //       }
// //       if (taskId == 'synchronizing_background_fetch') {
// //         /* DISABLED:  uncomment to fire a scheduleTask in headlessTask.
// //     BackgroundFetch.scheduleTask(TaskConfig(
// //         taskId: "com.transistorsoft.customtask",
// //         delay: 5000,
// //         periodic: false,
// //         forceAlarmManager: false,
// //         stopOnTerminate: false,
// //         enableHeadless: true
// //     ));
// //      */
// //       }
// //       BackgroundFetch.finish(taskId);
// //     }
// //   } on SocketException catch (_) {
// //     print('not connected');
// //     createlog("back ground sync done failed due to no internet", true);
// //   }
// // }
// //
// //
// // // ignore: non_constant_identifier_names
// // BackgroundConfig() async{
// //   await BackgroundFetch.configure(BackgroundFetchConfig(
// //     minimumFetchInterval: 15,
// //     forceAlarmManager: false,
// //     stopOnTerminate: false,
// //     startOnBoot: true,
// //     enableHeadless: true,
// //     requiresBatteryNotLow: false,
// //     requiresCharging: false,
// //     requiresStorageNotLow: false,
// //     requiresDeviceIdle: false,
// //     requiredNetworkType: NetworkType.NONE,
// //   ),backgroundFetchHeadlessTask,_onBackgroundFetchTimeout);
// // }
// // void _onBackgroundFetchTimeout(String taskId) {
// //   print("[BackgroundFetch] TIMEOUT: $taskId");
// //   BackgroundFetch.finish(taskId);
// // }
// //
//
// const EVENTS_KEY = "fetch_events";
//
//
// /// This "Headless Task" is run when app is terminated.
// void backgroundFetchHeadlessTask(HeadlessTask task) async {
//   var taskId = task.taskId;
//   var timeout = task.timeout;
//   if (timeout) {
//     print("[BackgroundFetch] Headless task timed-out: $taskId");
//     BackgroundFetch.finish(taskId);
//     return;
//   }
//
//   print("[BackgroundFetch] Headless event received: $taskId");
//
//   var timestamp = DateTime.now();
//
//   var prefs = await SharedPreferences.getInstance();
//
//   // Read fetch_events from SharedPreferences
//   var events = <String>[];
//   var json = prefs.getString(EVENTS_KEY);
//   if (json != null) {
//     events = jsonDecode(json).cast<String>();
//   }
//   // Add new event.
//   events.insert(0, "$taskId@$timestamp [Headless]");
//   // Persist fetch events in SharedPreferences
//   prefs.setString(EVENTS_KEY, jsonEncode(events));
//
//   if (taskId == 'flutter_background_fetch') {
//     // DISABLED:  uncomment to fire a scheduleTask in headlessTask.
//     BackgroundFetch.scheduleTask(TaskConfig(
//         taskId: "com.transistorsoft.customtask",
//         delay: 5000,
//         periodic: false,
//         forceAlarmManager: false,
//         stopOnTerminate: false,
//         enableHeadless: true
//     ));
//     await CustomTask();
//   }
//   BackgroundFetch.finish(taskId);
// }
//
//
// bool _enabled = true;
// int _status = 0;
// List<String> _events = [];
//
// // @override
// // void initState() {
// //   super.initState();
// //   initPlatformState();
// // }
//
// // Platform messages are asynchronous, so we initialize in an async method.
// Future<void> initPlatformState() async {
//   // Load persisted fetch events from SharedPreferences
//   var prefs = await SharedPreferences.getInstance();
//   var json = prefs.getString(EVENTS_KEY);
//   if (json != null) {
//       _events = jsonDecode(json).cast<String>();
//   }
//
//   // Configure BackgroundFetch.
//   try {
//     var status = await BackgroundFetch.configure(BackgroundFetchConfig(
//       minimumFetchInterval: 15,
//       forceAlarmManager: false,
//       stopOnTerminate: false,
//       startOnBoot: true,
//       enableHeadless: true,
//       requiresBatteryNotLow: false,
//       requiresCharging: false,
//       requiresStorageNotLow: false,
//       requiresDeviceIdle: false,
//       requiredNetworkType: NetworkType.ANY,
//     ), _onBackgroundFetch, _onBackgroundFetchTimeout);
//     print('[BackgroundFetch] configure success: $status');
//
//       _status = status;
//
//     // Schedule a "one-shot" custom-task in 10000ms.
//     // These are fairly reliable on Android (particularly with forceAlarmManager) but not iOS,
//     // where device must be powered (and delay will be throttled by the OS).
//     BackgroundFetch.scheduleTask(TaskConfig(
//         taskId: "com.transistorsoft.customtask bgm test while running",
//         delay: 10000,
//         periodic: false,
//         forceAlarmManager: true,
//         stopOnTerminate: false,
//         enableHeadless: true
//     ));
//
//     // ignore: avoid_catches_without_on_clauses
//   } catch(e) {
//     print("[BackgroundFetch] configure ERROR: $e");
//     _status = e;
//   }
//
//   // If the widget was removed from the tree while the asynchronous platform
//   // message was in flight, we want to discard the reply rather than calling
//   // setState to update our non-existent appearance.
//  // if (!mounted) return;
// }
//
// void _onBackgroundFetch(String taskId) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   DateTime timestamp = new DateTime.now();
//   // This is the fetch-event callback.
//   //print("[BackgroundFetch] Event received: $taskId");
//
//     // _events.insert(0, "$taskId@${timestamp.toString()} test bgf");
//
//   // Persist fetch events in SharedPreferences
//   prefs.setString(EVENTS_KEY, jsonEncode(_events));
//
//   if (taskId == "flutter_background_fetch") {
//     // Schedule a one-shot task when fetch event received (for testing).
//     /*
//       BackgroundFetch.scheduleTask(TaskConfig(
//           taskId: "com.transistorsoft.customtask",
//           delay: 5000,
//           periodic: false,
//           forceAlarmManager: true,
//           stopOnTerminate: false,
//           enableHeadless: true,
//           requiresNetworkConnectivity: true,
//           requiresCharging: true
//       ));
//        */
//    // await CustomTask();
//   }
//   // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
//   // for taking too long in the background.
//   BackgroundFetch.finish(taskId);
// }
//
// /// This event fires shortly before your task is about to timeout.  You must finish any outstanding work and call BackgroundFetch.finish(taskId).
// void _onBackgroundFetchTimeout(String taskId) {
//   print("[BackgroundFetch] TIMEOUT: $taskId");
//   BackgroundFetch.finish(taskId);
// }
//
//
// CustomTask() async {
//   try {
//     final result = await InternetAddress.lookup('example.com');
//     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//       createlog("back ground sync started Active data found", true);
//       print('connected');
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       requireurlstosync =  prefs.getStringList('addtoserverurl');
//       if(requireurlstosync!=null){
//         requireurlstosync =  prefs.getStringList('addtoserverurl');
//         requirebodytosync =  prefs.getStringList('addtoserverbody');
//         message =  prefs.getStringList('addtoservermessage');
//       }else{
//         requireurlstosync=[];
//         requirebodytosync=[];
//         message =[];
//       }
//       if (message.length > 0) {
//         await syncingsenddata();
//       }else{
//         createlog("back ground sync done no data found to sync", true);
//       }
//     }
//   } on SocketException catch (_) {
//     print('not connected');
//     createlog("back ground sync done failed due to no internet", true);
//   }
// }
//
