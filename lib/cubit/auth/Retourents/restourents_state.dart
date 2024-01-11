part of 'restourents_cubit.dart';

abstract class RestourentsState {}

class RestourentsInitial extends RestourentsState {
  @override
  List<Object> get props => [];
}

class RestourentsLoading extends RestourentsState {}

class RestourentsSucces extends RestourentsState {
  final List<SingleRestorent> RestourentList;
  RestourentsSucces(this.RestourentList);
}

class RestourentFail extends RestourentsState {
  final String erroe;
  RestourentFail(this.erroe);
}

class RestourentsSearchloading extends RestourentsState {}

class RestourentsSearchSucess extends RestourentsState {
  final List<SingleRestorent> RestourentList;
  RestourentsSearchSucess(this.RestourentList);
}

class RestourentsSearcfail extends RestourentsState {
  final String erroe;
  RestourentsSearcfail(this.erroe);
}

// let us know
class LetusknowLoading extends RestourentsState {}

class LetusknowSuccessFull extends RestourentsState {}

class LetusknowFail extends RestourentsState {
  final String error;
  LetusknowFail(this.error);
}