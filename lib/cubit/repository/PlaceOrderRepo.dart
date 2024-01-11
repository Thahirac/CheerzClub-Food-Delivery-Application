// ignore_for_file: file_names

import 'dart:convert';

import 'package:cheersclub/cubit/response/response.dart';
import 'package:cheersclub/networking/api_base_helper.dart';
import 'package:cheersclub/networking/endpoints.dart';
import 'package:result_type/result_type.dart';

abstract class GetOneRes {
  Future<Result> GetOneRestourent(int id, int main, int sub);
  Future<Result> GetOneRestourentGet(int id,String userId);
  Future<Result> Addtocart(
      String product_id, String quantity, String order_type);
  Future<Result> Viewproducts(String? restaurant_id, String? sub);
}

class GetOneRestourents extends GetOneRes {
  ApiBaseHelper _helper = ApiBaseHelper();

  @override
  Future<Result> GetOneRestourent(int id, int main, int sub) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.SingleRest) + "/" + id.toString(),
        {"main": main, "sub": sub},
        isHeaderRequired: true));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {
      print(response.data);
      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }

  @override
  Future<Result> GetOneRestourentGet(int id,String userId) async {
    String responseString = await (_helper.get(
        APIEndPoints.urlString(EndPoints.SingleRest) + "/" + id.toString() + "?user_id=" + userId.toString(),
        isHeaderRequired: true));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {
      print(response.data);
      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }

  @override
  Future<Result> Addtocart(
      String? product_id, String? quantity, String? order_type) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.addtocart),
        {
          "product_id": product_id,
          "quantity": quantity,
          "order_type": order_type
        },
        isHeaderRequired: true));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {
      print(response.data.toString() +"*******KKKKKKK******");
      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }

  @override
  Future<Result> Viewproducts(String? restaurant_id, String? sub) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.viewproducts),
        {
          "restaurant_id": restaurant_id,
          "sub": sub,
        },
        isHeaderRequired: true));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {
      print(response.data);
      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }
}
