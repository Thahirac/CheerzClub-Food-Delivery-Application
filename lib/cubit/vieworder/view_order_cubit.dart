import 'package:bloc/bloc.dart';
import 'package:cheersclub/cubit/repository/VieworderRepo.dart';
import 'package:cheersclub/models/Restourent/Singleorder.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

part 'view_order_state.dart';

class MyorderCubit extends Cubit<MyorderState> {

  Restaurant? restaurant;
  OrderedUser? orderedUser;
  Order? order;
  List<Orderitem>? orderitems;
  dynamic transactionfee;
  dynamic subtotal;
  dynamic total;
  dynamic vat21;
  dynamic vat9;

  MyorderCubit(this.getoneordEr) : super(MyorderInitial());
  final GetOneOrder  getoneordEr;


  Future<void> GetoneOrderGet(String id) async {
    emit(MyorderLoading());
    Result? result = await getoneordEr.GetoneOrderGet(id);
    if (result.isSuccess) {

      dynamic rest = result.success['restaurant'];

      restaurant = Restaurant(
          id: rest['id'],
          name: rest['name'],
          email: rest['email'],
          address: rest['address'],
          city: rest['city'],
          zip: rest['zip'],
          profilePhotoUrl: rest['profile_photo_url'],
          followers: 0,
          followings: 0);


      dynamic orderuser = result.success['ordered_user'];

      orderedUser = OrderedUser(
          id: orderuser['id'],
          name: orderuser['name'],
          email: orderuser['email'],
          phone: orderuser["phone"],
          address: orderuser['address'],
          city: orderuser['city'],
          zip: orderuser['zip'],
          profilePhotoUrl: orderuser['profile_photo_url'],
          followers: 0,
          followings: 0
      );

      dynamic ordr= result.success['order'];

      order = Order(
        id: ordr["id"],
        price: ordr["price"].toDouble(),
        userSecret: ordr["user_secret"],
        deliveryDate: DateTime.parse(ordr["delivery_date"]),
        deliveryType: ordr["delivery_type"],
        name: ordr["name"],
        dialcode: ordr["dialcode"],
        phone: ordr["phone"],
        message: ordr["message"],
        note: ordr["note"],
        createdAt: DateTime.parse(ordr["created_at"]),
        restaurantId: ordr["restaurant_id"],
        qr: ordr["qr"],
      );


      dynamic products = result.success['order_data']['orderitems'];
      orderitems = await productsList(products);

      transactionfee =result.success['order_data']['transaction_fee'];
      subtotal = result.success['order_data']['subtotal'];
      total = result.success['order_data']['total'];

      dynamic varItems = result.success['order_data']['vat'];
      vat21 = varItems['21'];
      vat9= varItems['9'];





      emit(MyorderSuccess(restaurant,order,orderitems,transactionfee,subtotal,total,vat21,vat9,orderedUser));
    } else {
      emit(MyorderFail(result.failure));
    }
  }

  Future<void> cancelorder(String order_id) async {
    emit(CancelorderLoading());
    Result? result = await getoneordEr.cancelorder(order_id);
    if (result.isSuccess) {


      emit(CancelorderSuccess(restaurant,order,orderitems,transactionfee,subtotal,total,vat21,vat9,orderedUser));
    } else {
      emit(CancelorderFail(result.failure));
    }
  }


}

List<Orderitem> productsList(List data) {
  List<Orderitem> productslist = [];
  var length = data.length;
  print("**********CART***LENGTH**********"+length.toString());

  for (int i = 0; i < length; i++) {
    Orderitem products =Orderitem(
        id: data[i]?['id'],
        productName: data[i]?['product_name'],
        productId: data[i]?['product_id'],
        orderId: data[i]?["order_id"],
        vat: data[i]?["vat"],
        orderType: data[i]?['order_type'],
        quantity: data[i]?['quantity']!,
        quantityText: data[i]?['quantity_text'],
        itemPrice: data[i]?['item_price'],
        price: data[i]?['price'],

    );
    productslist.add(products);
  }
  return productslist;
}

