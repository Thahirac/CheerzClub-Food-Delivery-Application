// ignore_for_file: file_names

import 'dart:convert';

import 'package:cheersclub/cubit/response/response.dart';
import 'package:cheersclub/networking/api_base_helper.dart';
import 'package:cheersclub/networking/endpoints.dart';
import 'package:result_type/result_type.dart';

abstract class GetOneGre {

  Future<Result> GetoneGreetingGet(int id);
  Future<Result> updateGreeting(String id,String message, String message_attachment,);

}

class GetOneGreeting extends GetOneGre {
  ApiBaseHelper _helper = ApiBaseHelper();


  @override
  Future<Result> GetoneGreetingGet(int id) async {
    String responseString = await (_helper.get(
        APIEndPoints.urlString(EndPoints.mygreeting) + "/" + id.toString(),
        isHeaderRequired: true));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {
      print("*****SINGLE GREEYTING****"+response.data.toString());
      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }


  @override
  Future<Result> updateGreeting(String id,String message, String message_attachment) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.editgreetings),
        {
          "id":id,
          "message": message,
          "message_attachment": message_attachment,
        },
        isHeaderRequired: true));

    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {

      print("**GREETINGS**UPDATE*"+response.data.toString());

      return Success(response.data);
    } else {
      //print(response.data);
      return Failure(response.message);
    }
  }


}
