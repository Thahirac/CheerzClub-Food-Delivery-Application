// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';

import 'package:cheersclub/Utils/managers/user_manager.dart';
import 'package:cheersclub/cubit/response/response.dart';
import 'package:cheersclub/networking/api_base_helper.dart';
import 'package:cheersclub/networking/endpoints.dart';
import 'package:result_type/result_type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'authentication_repository.dart';

abstract class LoginRepository extends UserAuthenticationRepository {
  Future<Result> authenticateUser(String? username, String? password);
  Future<Result> socialauthenticateUser(String? token, String? provider);
}

class UserLoginRepository extends LoginRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  @override
  Future<Result> authenticateUser(String? username, String? password) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.login),
        {
          "email": username,
          "password": password
        }));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {

      String token = response.data["token"];
      saveToken(token);

      int accountType = response.data["user"]["is_company"];
      saveAccountType(accountType.toString());

      int accountId = response.data["user"]["id"];
      saveAccountId(accountId.toString());

      UserManager.instance.setUserLoggedIn(true);

      print("ACCOUNT TYPE"+accountType.toString());

      print("ACCOUNT ID"+accountId.toString());

      print(response.data);


      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }


  @override
  Future<Result> socialauthenticateUser(String? token, String? provider) async {
    String responseString = await (_helper.post(
        APIEndPoints.urlString(EndPoints.sociallogin),
        {
          "token": token,
          "provider": provider,
        }
        )
    );
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {
      String token = response.data["token"];
      saveToken(token);

      int accountId = response.data["user"]["id"];
      saveAccountId(accountId.toString());

      print("ACCOUNT ID"+accountId.toString());

      UserManager.instance.setUserLoggedIn(true);
      print(response.data);
      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }


}
