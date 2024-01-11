// ignore_for_file: file_names

import 'dart:convert';

import 'package:cheersclub/cubit/response/response.dart';
import 'package:cheersclub/networking/api_base_helper.dart';
import 'package:cheersclub/networking/endpoints.dart';
import 'package:result_type/result_type.dart';

abstract class LeaveaMsg {

  Future<Result> leaveamessage(String name,String email, String phone,String message) ;

}

class PostleaveaMsg extends LeaveaMsg {
  ApiBaseHelper _helper = ApiBaseHelper();



  @override
  Future<Result> leaveamessage(String name,String email, String phone,String message) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.leaveamsg),
        {
          "name":name,
          "email":email,
          "phone":phone,
          "message": message,
        },
        isHeaderRequired: true));

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {

      print("**LEAVE*AMESSAGE*"+response.data.toString());

      return Success(response.data);
    } else {
      //print(response.data);
      return Failure(response.message);
    }
  }


}
