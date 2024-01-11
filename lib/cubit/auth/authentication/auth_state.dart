part of 'auth_cubit.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationIntial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  final String token;
  final String accounttype;

  Authenticated(this.token,this.accounttype);
}

class UnAuthenticated extends AuthenticationState {}
