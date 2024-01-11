enum EndPoints {
  login,
  logout,
  myprofile,
  locationbaserestaurants,
  register,
  ChangePassword,
  myGreetings,
  myOrders,
  SingleRest,
  addtocart,
  viewproducts,
  viewMyKart,
  filterRestourents,
  forgetPass,
  remoeveitemfromcart,
  startpayment,
  sociallogin,
  editgreetings,
  mygreeting,
  myorder,
  cancelorder,
  leaveamsg,
  notifications,
  viewnotification,
  resetpassword,
  letusknow,
}

class APIEndPoints {


  ///development
  //static String baseUrl = "https://";

  ///live
  static String baseUrl = "https://";

  static String urlString(EndPoints endPoint) {
    return baseUrl + endPoint.endPointString;
  }
}

extension EndPointsExtension on EndPoints {
  // ignore: missing_return
  String get endPointString {
    switch (this) {
      case EndPoints.login:
        return "v1/user/auth/login";
      case EndPoints.logout:
        return "v1/user/auth/logout";
      case EndPoints.myprofile:
        return "v1/user/myprofile";
      case EndPoints.locationbaserestaurants:
        return "restaurant";
      case EndPoints.register:
        return "v1/user/register";
      case EndPoints.ChangePassword:
        return "v1/user/change-password";
      case EndPoints.myGreetings:
        return "v1/user/my-greetings";
      case EndPoints.myOrders:
        return "v1/user/my-orders";
      case EndPoints.SingleRest:
        return "restaurant";
      case EndPoints.addtocart:
        return "v1/user/restaurant/add-to-cart";
      case EndPoints.viewproducts:
        return "product";
      case EndPoints.viewMyKart:
        return "v1/user/restaurant/cart/";
      case EndPoints.filterRestourents:
        return "restaurant?";
      case EndPoints.forgetPass:
        return "v1/user/forgot-password";
      case EndPoints.remoeveitemfromcart:
        return "v1/user/restaurant/remove-from-cart";
      case EndPoints.startpayment:
        return "v1/user/restaurant/initiate-payment";
      case EndPoints.sociallogin:
        return "v1/user/auth/social";
      case EndPoints.editgreetings:
        return "v1/user/my-greeting-update";
      case EndPoints.mygreeting:
        return "v1/user/my-greeting";
      case EndPoints.myorder:
        return "v1/user/my-order";
      case EndPoints.cancelorder:
        return "v1/user/cancel-my-order";
      case EndPoints.leaveamsg:
        return "v1/user/leave-message";
      case EndPoints.notifications:
        return "v1/user/notifications";
      case EndPoints.viewnotification:
        return "v1/user/view/notification";
      case EndPoints.resetpassword:
        return "v1/user/reset-password";
      case EndPoints.letusknow:
        return "let-us-know";
    }
  }
}
