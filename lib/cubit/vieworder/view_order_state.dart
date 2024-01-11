part of 'view_order_cubit.dart';

@immutable
abstract class MyorderState {}

class MyorderInitial extends MyorderState {}

class MyorderLoading extends MyorderState {}

class MyorderSuccess extends MyorderState {


  final Restaurant? restaurant;
  final OrderedUser? orderedUser;
  final   Order? order;
  final   List<Orderitem>? orderitems;
  final  dynamic transactionfee;
  final dynamic subtotal;
  final dynamic total;
  final dynamic vat21;
  final dynamic vat9;

  MyorderSuccess(this.restaurant,this.order,this.orderitems,this.transactionfee,this.subtotal,this.total,this.vat21,this.vat9,this.orderedUser);
}

class MyorderFail extends MyorderState {

  final String msg;

  MyorderFail(this.msg);

}


class CancelorderLoading extends MyorderState {}

class CancelorderSuccess extends MyorderState  {

  final Restaurant? restaurant;
  final OrderedUser? orderedUser;
  final   Order? order;
  final   List<Orderitem>? orderitems;
  final  dynamic transactionfee;
  final dynamic subtotal;
  final dynamic total;
  final dynamic vat21;
  final dynamic vat9;

  CancelorderSuccess(this.restaurant,this.order,this.orderitems,this.transactionfee,this.subtotal,this.total,this.vat21,this.vat9,this.orderedUser);
}

class CancelorderFail extends MyorderState {
  final String msg;

  CancelorderFail(this.msg);

}
