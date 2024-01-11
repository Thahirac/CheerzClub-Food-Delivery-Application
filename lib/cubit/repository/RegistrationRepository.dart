// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';

import 'package:cheersclub/Utils/managers/shared_preference_manager.dart';
import 'package:cheersclub/Utils/managers/user_manager.dart';
import 'package:cheersclub/cubit/response/response.dart';
import 'package:cheersclub/networking/api_base_helper.dart';
import 'package:cheersclub/networking/endpoints.dart';
import 'package:result_type/result_type.dart';
import 'authentication_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';


abstract class RegistrationRepository extends  UserAuthenticationRepository{
  Future<Result> registerUser(String? username, String? email, int? is_company,
      String? password, String password_confirmation);

  Future<Result> socialauthenticateUser(String? token, String? provider);

}

class UserRegRepository extends RegistrationRepository {
  ApiBaseHelper _helper = ApiBaseHelper();

  @override
  Future<Result> registerUser(String? username, String? email, int? is_company,
      String? password, String password_confirmation) async {
    String responseString =
        await (_helper.post(APIEndPoints.urlString(EndPoints.register), {
      "name": username,
      "email": email,
      "is_company": is_company,
      "password": password,
      "password_confirmation": password_confirmation
    }));
    Response response = Response.fromJson(json.decode(responseString));
    if (response.status == 1) {

      // String token = response.data["token"];
      // saveToken(token);
      //
      // int accountType = response.data["user"]["is_company"];
      // saveAccountType(accountType.toString());
      //
      // int accountId = response.data["user"]["id"];
      // saveAccountId(accountId.toString());
      //
      //
      // UserManager.instance.setUserLoggedIn(true);
      //
      // print("ACCOUNT TYPE"+accountType.toString());
      //
      // print("ACCOUNT ID"+accountId.toString());
      //
      // print(response.data);

      // String token = response.data["token"];
      // saveToken(token);
      // UserManager.instance.setUserLoggedIn(true);



      print(response.data);

      ///New code
      return Success(response.message);
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
      UserManager.instance.setUserLoggedIn(true);
      print(response.data);
      return Success(response.data);
    } else {
      print(response.data);
      return Failure(response.message);
    }
  }

}
