import 'package:bloc/bloc.dart';
import 'package:cheersclub/cubit/repository/PlaceOrderRepo.dart';
import 'package:cheersclub/models/Restourent/RestourentViewModel.dart';
import 'package:cheersclub/models/Restourent/products.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

import '../../Utils/managers/user_manager.dart';

part 'place_order_state.dart';

class PlaceOrderCubit extends Cubit<PlaceOrderState> {


  Restaurant? restaurant;
  List<MainCategories>? main_catogories;
  List<SubCategories>? subCategories_drks;
  List<SubCategories>? subCategories_snaks;
  List<SubCategories>? subCategories_deserts;
  List<Products>? products_list;
  int? cart_count;
  int? cart_countt;


  PlaceOrderCubit(this.getOneRestourents) : super(PlaceOrderInitial());
  final GetOneRestourents getOneRestourents;


  Future<void> SingleRestorentLoadingGet(int id) async {

    var userId = await UserManager.instance.getAccountId();

    emit(PlaceOrderLoading());
    Result? result = await getOneRestourents.GetOneRestourentGet(id,userId);
    if (result.isSuccess) {

      dynamic rest = result.success['restaurant'];

      restaurant = Restaurant(
          id: rest['id'],
          name: rest['name'],
          email: rest['email'],
          address: rest['address'],
          city: rest['city'],
          country: rest['country'],

          //profile_photo_url: "https://www.cheerzclub.com/user/view/avatars/avatars60e0297acc677.png",
          followers: 0,
          followings: 0);

     cart_count = result.success["cart_count"];

      dynamic main_catogoriess = result.success['main_categories'];
      main_catogories = await mainCategorysList(main_catogoriess);

      dynamic subCategories_drks_ = main_catogoriess[0]['sub_categories'];
      subCategories_drks = await subCategorysList(subCategories_drks_);

      dynamic subCategories_snaks_ = main_catogoriess[1]['sub_categories'];
      subCategories_snaks = await subCategorysList(subCategories_snaks_);

      dynamic subCategories_deserts_ = main_catogoriess[2]['sub_categories'];
      subCategories_deserts = await subCategorysList(subCategories_deserts_);

      //  dynamic productss = result.success['products'];
      // products = await productsList(productss);
      emit(PlaceOrderSuccess(restaurant, main_catogories, subCategories_drks,
          subCategories_snaks, subCategories_deserts, cart_count));
    } else {
      emit(PlaceOrderFail());
    }
  }

  Future<void> AddToKaert(
      String? product_id, String? quantity, String? order_type) async {
    emit(AddToKartLoading());
    Result? result =
    await getOneRestourents.Addtocart(product_id, quantity, order_type);
    if (result.isSuccess) {
      cart_countt = result.success["cart_count"];
      print("******************ADD****TO****CART*******"+cart_countt.toString());
      emit(AddToKartSuccess(cart_countt));
    } else {
      emit(AddToKartFail(result.failure));
    }
  }

  Future<void> loadProducts(String? restourent_id, String? subid) async {
    emit(productLoading());
    Result? result = await getOneRestourents.Viewproducts(restourent_id, subid);
    if (result.isSuccess) {
      dynamic products = result.success['products'];
      products_list = await productsList(products);
      emit(productSuccess(products_list));
    } else {
      emit(productFail("Something went wrong"));
    }
  }
}

List<SubCategories> subCategorysList(List data) {
  List<SubCategories> subCategories = [];
  var length = data.length;
  print(length.toString());

  for (int i = 0; i < length; i++) {
    SubCategories greetings = SubCategories(
        id: data[i]['id']!,
        name: data[i]['name'],
        mainCategoryId: data[i]['main_category_id']);
    subCategories.add(greetings);
  }
  return subCategories;
}

List<MainCategories> mainCategorysList(List data) {
  List<MainCategories> mainCategories = [];
  var length = data.length;
  print(length.toString());

  for (int i = 0; i < length; i++) {
    MainCategories greetings = MainCategories(
        id: data[i]['id']!,
        name: data[i]['name'],
        subCategories: data[i]['sub_categories']);
    mainCategories.add(greetings);
  }
  return mainCategories;
}

List<Products> productsList(List data) {
  List<Products> productslist = [];
  var length = data.length;
  print(length.toString());

  for (int i = 0; i < length; i++) {
    Products products = Products(
        id: data[i]['id']!,
        name: data[i]['name']!,
        description: data[i]['description'],
        remark: data[i]['remark'],
        category: data[i]['category'],
        stock: data[i]['stock'],
        restaurantId: data[i]['restaurantId'],
        imageName: data[i]['imageName'],
        createdAt: data[i]['createdAt'],
        updatedAt: data[i]['updatedAt'],
        deletedAt: data[i]['deletedAt'],
        categoryName: data[i]['categoryName'],
        priceCategories: data[i]['price_categories']);
    productslist.add(products);
  }
  return productslist;
}