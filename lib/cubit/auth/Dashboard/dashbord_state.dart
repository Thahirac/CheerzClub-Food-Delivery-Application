part of 'dashbord_cubit.dart';

@immutable
abstract class DashbordState {}

class DashbordInitial extends DashbordState {}

class DashbordLoading extends DashbordState {}

//my orders
class DashbordLoadingMyorders extends DashbordState {}

class DashbordMyordersSucssellfull extends DashbordState {
  final List<MyGreetings> ordersListdata;

  DashbordMyordersSucssellfull(this.ordersListdata);
}

class DashbordLoadingMyordersFail extends DashbordState {
  final String error;
  DashbordLoadingMyordersFail(this.error);
}

//my greetings
class DashbordMyGreetingsLoading extends DashbordState {}

class DashbordMyGreetingsSuccessFull extends DashbordState {
  final List<MyGreetings> ordersListdata;

  DashbordMyGreetingsSuccessFull(this.ordersListdata);
}

class DashbordMyGreetingsFail extends DashbordState {
  final String error;

  DashbordMyGreetingsFail(this.error);
}

//my Profile

class DashbordMyProfileLoading extends DashbordState {}

class DashbordMyProfileSuccessFull extends DashbordState {
  final User? user;
  DashbordMyProfileSuccessFull(this.user);
}

class DashbordMyProfileFail extends DashbordState {
  final String error;
  DashbordMyProfileFail(this.error);
}


//Change Password
class DashbordchangePasswordLoading extends DashbordState {}

class DashbordchangePasswordSuccessFull extends DashbordState {}

class DashbordchangePasswordFail extends DashbordState {
  final String message;

  DashbordchangePasswordFail(this.message);
}
class ProfileupdateLoading extends DashbordState {}

class ProfileupdateSuccessFull extends DashbordState {
  final User? user;
  ProfileupdateSuccessFull(this.user);
}

class ProfileupdateFail extends DashbordState {
  final String message;

  ProfileupdateFail(this.message);
}