part of 'register_cubit.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {
  @override
  List<Object> get props => [];
}

class RegistrationLoading extends RegisterState {}

class RegistrationLoginSuccessFull extends RegisterState {
  //save user data
  // final UserSession userSession;
  // final int? isCompany;
  // final bool? isCompleted;
  final String msge;
  RegistrationLoginSuccessFull(this.msge);
}

class RegistrationSuccessFull extends  RegisterState {
  //save user data
  final UserSession userSession;
  final int? isCompany;
  final bool? isCompleted;
  RegistrationSuccessFull(this.userSession,this.isCompany,this.isCompleted);
}


class RegistrationFailed extends RegisterState {
  //show error
  final String msg;
  RegistrationFailed(this.msg);
}
