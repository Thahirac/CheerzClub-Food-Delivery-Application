part of 'place_order_cubit.dart';

@immutable
abstract class PlaceOrderState {}

class PlaceOrderInitial extends PlaceOrderState {}

class PlaceOrderLoading extends PlaceOrderState {}

class PlaceOrderSuccess extends PlaceOrderState {
  final Restaurant? restaurant;
  final List<MainCategories>? mainCategories;
  final List<SubCategories>? subCategories_drks;
  final List<SubCategories>? subCategories_snaks;
  final List<SubCategories>? subCategories_deserts;
  final int? cart_count;

  // final List<Products>? products;
  PlaceOrderSuccess(
      this.restaurant,
      this.mainCategories,
      this.subCategories_drks,
      this.subCategories_snaks,
      this.subCategories_deserts,
      this.cart_count);
}

class PlaceOrderFail extends PlaceOrderState {}

class productLoading extends PlaceOrderState {}

class productSuccess extends PlaceOrderState {
  final List<Products>? products_list;
  productSuccess(this.products_list);
}

class productFail extends PlaceOrderState {
  final String error;
  productFail(this.error);
}

class AddToKartLoading extends PlaceOrderState {}

class AddToKartSuccess extends PlaceOrderState {

  final int? cart_countt;

  AddToKartSuccess(this.cart_countt);
}

class AddToKartFail extends PlaceOrderState {
  final String error;
  AddToKartFail(this.error);
}
