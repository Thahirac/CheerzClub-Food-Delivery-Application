import 'package:bloc/bloc.dart';
import 'package:cheersclub/cubit/repository/RestourentkartRepository.dart';
import 'package:cheersclub/models/cart/RestourentKartModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

part 'restourent_cart_state.dart';

class RestourentCartCubit extends Cubit<RestourentCartState> {
  List<Cart>? cart;
  dynamic sutotal;
  dynamic vat21;
  dynamic vat9;
  dynamic total;
  dynamic transactionfee;
  String? url;

  final RestorentKartRepository restorentKartRepository;
  RestourentCartCubit(this.restorentKartRepository)
      : super(RestourentCartInitial());



  Future<void> loadProducts(String? restaurant_id) async {
    Result? result = await restorentKartRepository.restourentList(restaurant_id);
    if (result.isSuccess) {
      emit(RestourentCartLoading(false));
      sutotal = result.success['subtotal'];
      print("*************SUB***TOTAL**********************"+sutotal.toString());
      total = result.success['total'];
      print("*************TOTAL**********************"+total.toString());
      transactionfee =result.success['transaction_fee'];
      print("*************FEE**********************"+transactionfee.toString());
      dynamic kartItems = result.success['cart'];
      cart = productsList(kartItems);
      dynamic varItems = result.success['vat'];
      vat21 = varItems['21'];
      vat9= varItems['9'];
      print("*************VAT**********************"+vat21.toString());
      emit(RestourentCartSuccess(cart,sutotal,vat21,vat9, total,transactionfee));
    } else {
      emit(RestourentCartFailed(result.failure));
    }
  }


  Future<void> deleteproduct(String? restourent_id) async {
    // emit(RestourentCartLoading(true));
    Result? result = await restorentKartRepository.DeleteKertItem(restourent_id);
    if (result.isSuccess) {
      emit(RestourentCartdeletSuccess());
    } else {
      emit(RestourentCartFailed("Something went wrong"));
    }
  }


  Future<void> initialPayment(
  String restaurant_id, String  name, String delivery_type, String dialcode, String phone, String phone2, String phone3,String  delivery_date,String delivery_time,String message, String note, String message_attachment) async {
    emit(PaymentLoading());
    Result? result = await restorentKartRepository.startpayment(restaurant_id,name,delivery_type,dialcode,phone,phone2,phone3,delivery_date,delivery_time,message,note,message_attachment);
    if (result.isSuccess) {
      url = result.success["url"];
      print("******************web****url*******"+url.toString());
      emit(PaymentSuccesS(url??""));
    } else {
      emit(PaymentFail("failed to initial payment"));
    }
  }



}

List<Cart> productsList(List data) {
  List<Cart> productslist = [];
  var length = data.length;
  print("**********CART***LENGTH**********"+length.toString());

  for (int i = 0; i < length; i++) {
    Cart products = Cart(
        id: data[i]?['id'],
        productId: data[i]?['product_id'],
        orderType: data[i]?['order_type'],
        quantity: data[i]?['quantity']!,
        name: data[i]?['name'],
        quantityText: data[i]?['quantity_text'],
        itemPrice: data[i]?['item_price'],
        price: data[i]?['price']
    );
    productslist.add(products);
  }
  return productslist;
}
