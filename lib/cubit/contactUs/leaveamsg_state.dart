part of 'leaveamsg_cubit.dart';

@immutable
abstract class LeaveaMsgState {}

class LeaveamessageInitial extends LeaveaMsgState {}

class LeaveamessageLoading extends LeaveaMsgState {}

class LeaveamessageSuccess extends LeaveaMsgState {

  LeaveamessageSuccess();
}

class LeaveamessageFail extends LeaveaMsgState {
  final String error;

  LeaveamessageFail(this.error);
}


