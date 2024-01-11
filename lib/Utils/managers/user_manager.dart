import 'dart:convert';

import 'package:cheersclub/Utils/managers/shared_preference_manager.dart';
import 'package:cheersclub/models/auth/user.dart';

class UserManager {
  static final UserManager _sharedInsatnce = UserManager._internal();
//  Profile currentUserProfile = Profile();
  factory UserManager() {
    return _sharedInsatnce;
  }

  UserManager._internal();
  static UserManager get instance => _sharedInsatnce;

  Future<bool> isUserAlreadyLoggedIn() async {
    bool isUserLoggedIn = await SharedPreferenceManager().getBoolValueFor("isUserLoggedIn");
    return isUserLoggedIn;
  }

  void setUserLoggedIn(bool isLoggedIn) async {
    SharedPreferenceManager().setBoolValue("isUserLoggedIn", isLoggedIn);
  }

/*
  void setUserProfile(Profile userProfile) async {
    currentUserProfile = userProfile;
    String userProfileString = jsonEncode(userProfile.toJson());
    SharedPreferenceManager.instance.setValue("userProfile", userProfileString);
    setUserLoggedIn(true);
  }

  Future<Profile?> getUserProfile() async {
    String userProfileString =
        await SharedPreferenceManager.instance.getValueFor("userProfile");

    try {
      Map json = jsonDecode(userProfileString);
      var userProfile = Profile.fromJson(json as Map<String, dynamic>);
      return userProfile;
    } catch (error) {
      return null;
    }
  }

  Profile getCurrentUserProfile() {
    return currentUserProfile;
  }

  */
  void setUserSession(UserSession userSession) async {
    String userSessionString = jsonEncode(userSession.toJson());
    SharedPreferenceManager.instance.setValue("userSession", userSessionString);
    setUserLoggedIn(true);
  }

  Future<UserSession?> getUserSession() async {
    String userString = await SharedPreferenceManager.instance.getValueFor("userSession");

    try {
      Map json = jsonDecode(userString);
      var user = UserSession.fromJson(json as Map<String, dynamic>);
      return user;
    } catch (error) {
      return null;
    }
  }

  void setUser(User user) async {
    String userString = jsonEncode(user.toJson());
    SharedPreferenceManager.instance.setValue("loggedInUser", userString);
  }

  Future<User?> getUser() async {
    String userString =
        await SharedPreferenceManager.instance.getValueFor("loggedInUser");

    try {
      Map json = jsonDecode(userString);
      var user = User.fromJson(json as Map<String, dynamic>);
      return user;
    } catch (error) {
      return null;
    }
  }

  Future<String> getToken() {
    return SharedPreferenceManager.instance.getValueFor("token");
  }

  Future<String> getAccountType() {
    return SharedPreferenceManager.instance.getValueFor("is_company");
  }

  Future<String> getAccountId() {
    return SharedPreferenceManager.instance.getValueFor("id");
  }

  Future<void> logOutUser() async {
    SharedPreferenceManager.instance.clearDefaults();
  }
}
