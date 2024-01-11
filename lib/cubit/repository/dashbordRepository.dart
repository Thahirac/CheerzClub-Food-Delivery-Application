// ignore_for_file: file_names

import 'dart:convert';

import 'package:cheersclub/cubit/response/response.dart';
import 'package:cheersclub/networking/api_base_helper.dart';
import 'package:cheersclub/networking/endpoints.dart';
import 'package:result_type/result_type.dart';

abstract class dashbordRepository {
  Future<Result> UserProfile();
  Future<Result> ChangePassWord(String old_password, String password, String password_confirmation);
  Future<Result> getGreeting();
  Future<Result> getOrders();
  Future<Result> UserProfileUpdate(String name, String phone, String address,String zip, String city, String country,String dob,String contact_person,String coc,String vat_number);
}

class DashBordRepository extends dashbordRepository {
  ApiBaseHelper _helper = ApiBaseHelper();


  @override
  Future<Result> UserProfile() async {
    String responseString = await (_helper.get(
        APIEndPoints.urlString(EndPoints.myprofile),
        isHeaderRequired: true));

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {
      var k = response.data['user'];
      print(response.data['user']);
      return Success(response.data['user']);
    } else {
      //print(response.data);
      return Failure(response.message);
    }
  }


  @override
  Future<Result> ChangePassWord(String old_password, String password,
      String password_confirmation) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.ChangePassword),
        {
          "old_password": old_password,
          "password": password,
          "password_confirmation": password_confirmation,
        },
        isHeaderRequired: true));

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {
      //  var k = response.data['user'];
      // print(response.data['user']);
      return Success(response.data);
    } else {
      //print(response.data);
      return Failure(response.message);
    }
  }

  @override
  Future<Result> getGreeting() async {
    String responseString = await _helper.get(
        APIEndPoints.urlString(
          EndPoints.myGreetings,
        ),
        isHeaderRequired: true);

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {
      print("***MY**GREETINGS***"+response.data.toString());
      return Success(response.data['greetings']);
    } else {
      return Failure(response.message);
    }
  }




  @override
  Future<Result> getOrders() async {
    String responseString = await _helper.get(
        APIEndPoints.urlString(
          EndPoints.myOrders,
        ),
        isHeaderRequired: true);

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {
      print("***MY**ORDERS***"+response.data.toString());
      return Success(response.data['orders']);
    } else {
      return Failure(response.message);
    }
  }


  @override
  Future<Result> UserProfileUpdate(String name, String phone,String address,
      String zip, String city, String country,String dob,String contact_person,String coc,String vat_number) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.myprofile),
        {
          "name": name,
          "phone": phone,
          "address": address,
          "zip": zip,
          "city": city,
          "country": country,
          "dob": dob,
          "contact_person": contact_person,
          "coc":coc,
          "vat_number":vat_number
        },
        isHeaderRequired: true));

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {
      var k = response.data['user'];
      print(response.data['user']);
      return Success(response.data['user']);
    } else {
      //print(response.data);
      return Failure(response.message);
    }
  }


}
