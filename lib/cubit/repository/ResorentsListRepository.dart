// ignore_for_file: file_names

import 'dart:convert';

import 'package:cheersclub/cubit/response/response.dart';
import 'package:cheersclub/networking/api_base_helper.dart';
import 'package:cheersclub/networking/endpoints.dart';
import 'package:result_type/result_type.dart';

abstract class RestorentListRepository {
  Future<Result> restourentList(String lat,String long);
  Future<Result> restourentListFilter(String keyword,String ziporplace);
  Future<Result>  letusKnow(String name,String address,String contact, String phone);

}

class UserResListRepository extends RestorentListRepository {
  ApiBaseHelper _helper = ApiBaseHelper();
  List<dynamic> restourent_lists = [];

  @override
  Future<Result> restourentList(String lat,String long) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.locationbaserestaurants),
        {
          "latitude":lat,
          "longitude":long,
        },
        isHeaderRequired: true));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {
      restourent_lists = response.data;
      print(response.data);
      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }

  @override
  Future<Result> restourentListFilter(String keyword,String ziporplace) async {
    String responseString = await (_helper.get(
        APIEndPoints.urlString(EndPoints.filterRestourents) + "keyword=" + keyword + "&zip=" + ziporplace,
        isHeaderRequired: true));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {
      restourent_lists = response.data;
      print("******** rest print data***********");
      print(response.data);
      return Success(response.data);
    } else {
      print("******** rest error data***********");
      print(response.data);
      return Failure(response.message);
    }
  }

  @override
  Future<Result> letusKnow(String name,String address,String contact, String phone) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.letusknow),
        {
          "name": name,
          "address": address,
          "contact": contact,
          "phone": phone,
        },
        isHeaderRequired: true));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {
      //restourent_lists = response.data['data'];
      print(response.data);
      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }






}
