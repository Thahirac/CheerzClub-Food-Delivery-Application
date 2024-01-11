part of 'forget_pass_word_cubit.dart';

abstract class ForgetPassWordState {}

class ForgetPassWordInitial extends ForgetPassWordState {}

class ForgetPassWordLoading extends ForgetPassWordState {}

class ForgetPassWordSuccessFull extends ForgetPassWordState {
  //save user data
}

class ForgetPassWordFailed extends ForgetPassWordState {
  //show error
  final String msg;
  ForgetPassWordFailed(this.msg);
}
class ResetPasswordLoading extends ForgetPassWordState {}

class ResetPasswordSuccessFull extends ForgetPassWordState {
  //save user data
}

class ResetPasswordFailed extends ForgetPassWordState {
  //show error
  final String msg;
  ResetPasswordFailed(this.msg);
}