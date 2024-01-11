// ignore_for_file: file_names

import 'dart:convert';

import 'package:cheersclub/cubit/response/response.dart';
import 'package:cheersclub/networking/api_base_helper.dart';
import 'package:cheersclub/networking/endpoints.dart';
import 'package:result_type/result_type.dart';

abstract class GetOneOrd {

  Future<Result> GetoneOrderGet(String id);
  Future<Result>  cancelorder(String order_id);


}

class GetOneOrder extends GetOneOrd {
  ApiBaseHelper _helper = ApiBaseHelper();


  @override
  Future<Result> GetoneOrderGet(String id) async {
    String responseString = await (_helper.get(
        APIEndPoints.urlString(EndPoints.myorder) + "/" + id.toString(),
        isHeaderRequired: true));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {


      print("*****SINGLE ORDER****"+response.data.toString());

      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }

  @override
  Future<Result> cancelorder(
      String? order_id) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.cancelorder),
        {
          "order_id": order_id
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


}
