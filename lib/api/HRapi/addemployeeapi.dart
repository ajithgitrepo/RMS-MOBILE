import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_service.dart';
class employeedetails{
  static var firstname;
  static var middlename;
  static var surname;
  static var passportno;
  static var nationality;
  static var gender;
  static var codes;
  static var emiratesid;
  static var mobileno;
  static var email;
  static var designation;
  static var departmant;
  static var joiningdate;
  static var visaexpdate;
  static var passportexpdate;
  static var medicalinsno;
  static var medicalinsexpdate;
  static var visacompanyname;
}

Future addemployees() async{
  Map employeedata = {
    'first_name' : '${employeedetails.firstname}',
    'middle_name' : '${employeedetails.middlename}',
    'surname' : '${employeedetails.surname}',
    'passport_number' : '${employeedetails.passportno}',
    'nationality' : '${employeedetails.nationality}',
    'gender' : '${employeedetails.gender}',
    'codes' : '${employeedetails.codes}',
    'emirates_id' : '${employeedetails.emiratesid}',
    'mobile_number' : '${employeedetails.mobileno}',
    'email' : '${employeedetails.email}',
    'designation' : '${employeedetails.designation}',
    'department' : '${employeedetails.departmant}',
    'joining_date' : '${employeedetails.joiningdate}',
    'visa_exp_date' : '${employeedetails.visaexpdate}',
    'passport_exp_date' : '${employeedetails.passportexpdate}',
    'medical_ins_no' : '${employeedetails.medicalinsno}',
    'medical_ins_exp_date' : '${employeedetails.medicalinsexpdate}',
    'visa_company_name' : '${employeedetails.visacompanyname}',
  };
  http.Response employees = await http.post(AddEmployee,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(employeedata),
  );
  print(employees.body);
  print("Add Employees Done");

}
