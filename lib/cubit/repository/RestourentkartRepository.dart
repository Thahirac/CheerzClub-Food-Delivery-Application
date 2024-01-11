// ignore_for_file: file_names

import 'dart:convert';

import 'package:cheersclub/cubit/response/response.dart';
import 'package:cheersclub/networking/api_base_helper.dart';
import 'package:cheersclub/networking/endpoints.dart';
import 'package:result_type/result_type.dart';

abstract class RestorentKartRepository {
  Future<Result> restourentList(String? Rest_id);
  Future<Result> DeleteKertItem(String? cart_id);

  Future<Result> startpayment(
      String restaurant_id,
      String name,
      String delivery_type,
      String phone,
      String phone2,
      String phone3,
      String dialcode,
      String delivery_date,
      String delivery_time,
      String message,
      String note,
      String message_attachment,
      );
}

class RestourentKartrepositoryy extends RestorentKartRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  @override
  Future<Result> restourentList(String? Rest_id) async {
    String responseString = await (_helper.get(
        APIEndPoints.urlString(EndPoints.viewMyKart) + Rest_id!,
        isHeaderRequired: true));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {
      var k = response.data;
      print(response.data);
      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }


  @override
  Future<Result> startpayment(
      String? restaurant_id, String?  name, String? delivery_type, String? dialcode, String? phone, String? phone2, String? phone3,String?  delivery_date,String?  delivery_time,String? message, String? note, String? message_attachment) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.startpayment),
        {
          "restaurant_id":restaurant_id,
          "name":name,
          "delivery_type":delivery_type,
          "dialcode":dialcode,
          "phone":phone,
          "phone2":phone2,
          "phone3":phone3,
          "delivery_date":delivery_date,
          "delivery_time":delivery_time,
          "message":message,
          "note":note,
          "message_attachment":message_attachment
        },

        isHeaderRequired: true
    )
    );
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {
      print(response.data.toString() +"*******KKKKKKK******");
      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }

  // @override
  // Future<Result> startpayment(
  //     String? restaurant_id, String?  name, String? delivery_type, String? dialcode, String? phone, String? phone2, String? phone3,String?  delivery_date,String?  delivery_time,String? message, String? note, String? message_attachment) async {
  //   String responseString = await (_helper.postFile(
  //       APIEndPoints.urlString(EndPoints.startpayment),
  //       {
  //         "restaurant_id":restaurant_id,
  //         "name":name,
  //         "delivery_type":delivery_type,
  //         "dialcode":dialcode,
  //         "phone":phone,
  //         "phone2":phone2,
  //         "phone3":phone3,
  //         "delivery_date":delivery_date,
  //         "delivery_time":delivery_time,
  //         "message":message,
  //         "note":note,
  //       },
  //       message_attachment,
  //       isHeaderRequired: true
  //   )
  //   );
  //   Response response = Response.fromJson(json.decode(responseString));
  //   if (response.status == 1) {
  //     print(response.data.toString() +"*******KKKKKKK******");
  //     return Success(response.data);
  //   } else {
  //     print(response.data);
  //     return Failure(response.message);
  //   }
  // }

  @override
  Future<Result> DeleteKertItem(String? cart_id) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.remoeveitemfromcart),
        {"cart_id": cart_id},
        isHeaderRequired: true));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {
      var k = response.data;
      print(response.data);
      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }

}
