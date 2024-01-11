part of 'view_greetings_cubit.dart';

@immutable
abstract class MygreetingsState {}

class MygreetingsInitial extends MygreetingsState {}

class MygreetingsLoading extends MygreetingsState {}

class MygreetingsSuccess extends MygreetingsState {

  final String? gmessage;
  final dynamic filename;
  final dynamic greetingpreview;



  MygreetingsSuccess(this.gmessage,this.filename,this.greetingpreview);
}

class MygreetingsFail extends MygreetingsState {}




class UpdategreetingsLoading extends MygreetingsState {}

class UpdategreetingsSuccess extends MygreetingsState {

  final String? gmessage;
  final dynamic filename;
  final dynamic greetingpreview;


  UpdategreetingsSuccess(this.gmessage,this.filename,this.greetingpreview);
}

class UpdategreetingsFail extends MygreetingsState {
  final String error;
  UpdategreetingsFail(this.error);
}
