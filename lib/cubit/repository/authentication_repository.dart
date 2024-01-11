import 'package:cheersclub/Utils/managers/shared_preference_manager.dart';
import 'package:cheersclub/Utils/managers/user_manager.dart';
import 'package:cheersclub/models/auth/user.dart';
import 'package:result_type/result_type.dart';

abstract class AuthenticationRepository {
  Future<Result> logoutUser();
  Future<User?> getCurrentUser();
  Future<void> saveToken(String token);
  Future<void> deleteToken();
  Future<String> getToken();
  Future<void> saveAccountType(String accountType);
  Future<void> saveAccountId(String id);
  Future<String> getAccountType();
  Future<String> getAccountId();

}

class UserAuthenticationRepository extends AuthenticationRepository {
  @override
  Future<void> deleteToken() {
    // TODO: implement deleteToken
    throw UnimplementedError();
  }

  @override
  Future<User?> getCurrentUser() async {
    return UserManager.instance.getUser();
  }

  @override
  Future<String> getToken() {
    return SharedPreferenceManager.instance.getValueFor("token");
  }

  @override
  Future<String> getAccountType() {
    return SharedPreferenceManager.instance.getValueFor("is_company");
  }

  @override
  Future<String> getAccountId() {
    return SharedPreferenceManager.instance.getValueFor("id");
  }

  @override
  Future<Result> logoutUser() {
    // TODO: implement logoutUser
    throw UnimplementedError();
  }

  @override
  Future<void> saveToken(String token) async {
    SharedPreferenceManager.instance.setValue("token", token);
  }


  @override
  Future<void> saveAccountType(String  is_company) async {
    SharedPreferenceManager.instance.setValue("is_company", is_company);
  }

  @override
  Future<void> saveAccountId(String id) async {
    SharedPreferenceManager.instance.setValue("id", id);
  }


}
