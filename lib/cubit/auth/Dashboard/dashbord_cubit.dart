import 'package:bloc/bloc.dart';
import 'package:cheersclub/cubit/repository/dashbordRepository.dart';
import 'package:cheersclub/models/Restourent/MyGreetings.dart';
import 'package:cheersclub/models/Restourent/Notification.dart';
import 'package:cheersclub/models/auth/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

part 'dashbord_state.dart';

class DashbordCubit extends Cubit<DashbordState> {


  DashbordCubit(this.dashBordRepository) : super(DashbordInitial());
  final DashBordRepository dashBordRepository;

  Future<void> UserProfileloading() async {
    emit(DashbordMyProfileLoading());
    Result? result = await dashBordRepository.UserProfile();
    if (result.isSuccess) {
      User user = User(
        id: result.success["id"],
        name: result.success["name"],
        email: result.success["email"],
        phone: result.success["phone"],
        contactPerson: result.success["contact_person"],
        isCompany: result.success["is_company"],
        address: result.success["address"],
        city: result.success["city"],
        zip: result.success["zip"],
        country: result.success["country"],
        vatNumber: result.success["vat_number"],
        coc: result.success["coc"],
        profilePhotoUrl: result.success["profile_photo_url"],
        followers: result.success["followers"],
        followings: result.success["followings"],
       dob: DateTime.parse(result.success["dob"]??"0000-00-00 00:00:00"),
      );

      emit(DashbordMyProfileSuccessFull(user));
    } else {
      emit(DashbordMyProfileFail(result.failure));
    }
  }


  Future<void> UserProfileupdate(String name, String phone,String address,
      String zip, String city, String country,String dob,String contact_person,String coc,String vat_number) async {
    emit(ProfileupdateLoading());
    Result? result = await dashBordRepository.UserProfileUpdate(
        name, phone, address, zip, city, country,dob,contact_person,coc,vat_number);
    if (result.isSuccess) {
      User user = User(
        id: result.success["id"],
        name: result.success["name"],
        email: result.success["email"],
        phone: result.success["phone"],
        contactPerson: result.success["contact_person"],
        isCompany: result.success["is_company"],
        address: result.success["address"],
        city: result.success["city"],
        zip: result.success["zip"],
        country: result.success["country"],
        vatNumber: result.success["vat_number"],
        coc: result.success["coc"],
        profilePhotoUrl: result.success["profile_photo_url"],
        followers: result.success["followers"],
        followings: result.success["followings"],
        dob: DateTime.parse(result.success["dob"]??"0000-00-00 00:00:00.000"),
      );

      emit(ProfileupdateSuccessFull(user));
    } else {
      emit(ProfileupdateFail(result.failure));
    }
  }


  Future<void> PasswordChange(String old_password, String password,
      String password_confirmation) async {
    emit(DashbordchangePasswordLoading());
    Result? result = await dashBordRepository.ChangePassWord(
        old_password, password, password_confirmation);
    if (result.isSuccess) {
      emit(DashbordchangePasswordSuccessFull());
    } else {
      emit(DashbordchangePasswordFail(result.failure));
    }
  }

  Future<void> getGreetings() async {
    emit(DashbordMyGreetingsLoading());
    Result result = await dashBordRepository.getGreeting();
    if (result.isSuccess) {


      dynamic resultData = result.success;
      List<MyGreetings> ordersListdata = await myGreetingssList(
        resultData,
      );

      emit(DashbordMyGreetingsSuccessFull(ordersListdata));
    } else {
      emit(DashbordMyGreetingsFail("Something went wrong"));
    }
  }


  Future<void> getOrders() async {
    emit(DashbordLoadingMyorders());
    Result result = await dashBordRepository.getOrders();
    if (result.isSuccess) {

      dynamic resultData = result.success;
      List<MyGreetings> ordersListdata = await myGreetingssList(
        resultData,
      );

      emit(DashbordMyordersSucssellfull(ordersListdata));
    } else {
      emit(DashbordLoadingMyordersFail(result.failure));
    }
  }
}



List<MyGreetings> myGreetingssList(List data) {
  List<MyGreetings> Greetings = [];
  var length = data.length;
  print(length.toString());

  for (int i = 0; i < length; i++) {
    MyGreetings greetings = MyGreetings(
        id: data[i]['id'],
        userId: data[i]['user_id'],
        restaurantId: data[i]['restaurant_id'],
        paymentId: data[i]['payment_id'],
        price: data[i]['price'],
        userSecret: data[i]['user_secret'],
        restaurantSecret: data[i]['restaurant_secret'],
        deliveryDate: data[i]['delivery_date'],
        deliveryType: data[i]['delivery_type'],
        name: data[i]['name'],
        dialcode: data[i]['dialcode'],
        phone: data[i]['phone'],
        dialcode2: 00,
        phone2: 00,
        dialcode3: 00,
        phone3: 00,
        message: data[i]['message'],
        note: "Greetings",
        fileName: "filename",
        greetingKey: data[i]['greeting_key'],
        status: data[i]['status'],
        paymentStatus: data[i]['payment_status'],
        createdAt: data[i]['created_at'],
        updatedAt: data[i]['updated_at']);
    Greetings.add(greetings);
  }
  return Greetings;
}