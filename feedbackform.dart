import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:merchandising/Constants.dart';
import 'package:merchandising/api/api_service.dart';

class FeedbackForm {
  String userid;
  String name;
  String reportedon;
  String feedback;

  FeedbackForm(this.userid, this.name, this.reportedon, this.feedback);

  factory FeedbackForm.fromJson(dynamic json) {
    return FeedbackForm("${json['userid']}", "${json['name']}",
        "${json['feedback']}", "${json['reportedon']}");
  }

  // Method to make GET parameters.
  Map toJson() => {
    'userid': userid,
    'name': name,
    'feedback': feedback,
    'reportedon': reportedon
  };
}



/// FormController is a class which does work of saving FeedbackForm in Google Sheets using
/// HTTP GET request on Google App Script Web URL and parses response and sends result callback.
class FormController {
  // Google App Script Web URL.
    Uri URL = Uri.parse("https://script.google.com/macros/s/AKfycbyqQHi2CL5JDzdM4MO1WiXmNDawmYnQs72i52hJH9uC4kD2hyS0/exec");

  // Success Status Message
  static const STATUS_SUCCESS = "SUCCESS";

  /// Async function which saves feedback, parses [feedbackForm] parameters
  /// and sends HTTP GET request on [URL]. On successful response, [callback] is called.
  void submitForm(
      FeedbackForm feedbackForm, void Function(String) callback) async {
    try {
      print(feedbackForm.toJson());
      await http.post(URL, body: feedbackForm.toJson()).then((response) async {
        print(response.statusCode);
        if (response.statusCode == 302) {
          Uri url = Uri.parse("${response.headers['location']}");
          await http.get(url).then((response) {
            callback(convert.jsonDecode(response.body)['status']);
          });
        } else {
          callback(convert.jsonDecode(response.body)['status']);
        }
      });
    } catch (e) {
      print(e);
    }
  }
}

class FeedbackPage extends StatefulWidget {
  FeedbackPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<FeedbackPage> {

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // TextField Controllers
  TextEditingController nameController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();

  // Method to Submit Feedback and save it in Google Sheets
  void _submitForm() {
    // Validate returns true if the form is valid, or false
    // otherwise.
    if (_formKey.currentState.validate()) {
      // If the form is valid, proceed.
      FeedbackForm feedbackForm = FeedbackForm(
        "${DBrequestdata.receivedempid}",
          nameController.text,
          "${DateTime.now()}",
          feedbackController.text);

      FormController formController = FormController();

      _showSnackbar("Submitting Feedback");

      // Submit 'feedbackForm' and save it in Google Sheets.
      formController.submitForm(feedbackForm, (String response) {
        print("Response: $response");
        if (response == FormController.STATUS_SUCCESS) {
          // Feedback is saved succesfully in Google Sheets.
          _showSnackbar("Feedback Submitted");
        } else {
          // Error Occurred while saving data in Google Sheets.
          _showSnackbar("Error Occurred!");
        }
      });
    }
  }

  // Method to show snackbar with 'message'.
  _showSnackbar(String message) {
    final snackBar = SnackBar(content: Text(message));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: orange,
        title: Text(widget.title,style: TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Form(
                key: _formKey,
                child:
                Padding(padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Valid Name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText: 'Name',
                          labelStyle: TextStyle(
                            color: orange,
                            fontSize: 16.0,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: orange),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: feedbackController,
                        maxLines: 5,
                        cursorColor: orange,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter Valid Feedback';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            labelText: 'Feedback',
                          labelStyle: TextStyle(
                            color: orange,
                            fontSize: 16.0,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: orange),
                        ),
                      ),
                      )
                    ],
                  ),
                )
            ),
            RaisedButton(
              color: orange,
              textColor: Colors.white,
              onPressed:_submitForm,
              child: Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}

// sendemail()async{
//   final Email email =  Email(
//     body: 'test',
//     subject: 'RMS Log report',
//     recipients: ['vilvaroja@gmail.com'],
//     isHTML: false,
//   );
//   String platformResponse;
//
//   try {
//     await FlutterEmailSender.send(email);
//     platformResponse = 'success';
//     print("done");
//   } catch (error) {
//     platformResponse = error.toString();
//     print(error);
//   }
// }