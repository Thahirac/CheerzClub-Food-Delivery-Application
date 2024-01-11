part of 'restourent_cart_cubit.dart';

@immutable
abstract class RestourentCartState {}

class RestourentCartInitial extends RestourentCartState {
  RestourentCartInitial();
}

class RestourentCartLoading extends RestourentCartState {
  bool? isloading;
  RestourentCartLoading(this.isloading);
}

class RestourentCartSuccess extends RestourentCartState {
  final List<Cart>? cart;
  final dynamic sutotal;
  final dynamic vat21;
  final dynamic vat9;
  final dynamic total;
  final dynamic  transactionfee;

  RestourentCartSuccess(this.cart, this.sutotal, this.vat21,this.vat9,this.total,this.transactionfee);
}

class RestourentCartFailed extends RestourentCartState {
  final String error;

  RestourentCartFailed(this.error);
}

class Paymentinitial extends RestourentCartState {}


class PaymentLoading extends RestourentCartState {}

class PaymentSuccesS extends RestourentCartState {
  final String url;

  PaymentSuccesS(this.url);
}

class PaymentFail extends RestourentCartState {
  final String error;
  PaymentFail(this.error);
}

class RestourentCartdeleteloding extends RestourentCartState {}

class RestourentCartdeletSuccess extends RestourentCartState {

}

class RestourentCartFaileddeleting extends RestourentCartState {}
