import 'package:bloc/bloc.dart';
import 'package:cheersclub/cubit/repository/ResorentsListRepository.dart';
import 'package:cheersclub/models/SingleRestorent.dart';
import 'package:result_type/result_type.dart';

part 'restourents_state.dart';

class RestourentsCubit extends Cubit<RestourentsState> {
  RestourentsCubit(this.restorentListRepository) : super(RestourentsInitial());
  final RestorentListRepository restorentListRepository;
  List<SingleRestorent> RetourentList = [];

  Future<void> loadrestourent(String lat,String long) async {
    emit(RestourentsLoading());
    Result? result = await restorentListRepository.restourentList(lat,long);

    if (result.isSuccess) {
      dynamic resultData = result.success;
      List<SingleRestorent> Listdata = await ordersList(
        resultData,
      );

      emit(RestourentsSucces(Listdata));
    } else {
      emit(RestourentFail(result.failure));
    }

  }

  Future<void> loadrestourentFilter(String keyword,String ziporplace) async {
    emit(RestourentsSearchloading());
    Result? result = await restorentListRepository.restourentListFilter(keyword,ziporplace);

    if (result.isSuccess) {
      dynamic resultData = result.success;
      print("result data");
      print(resultData);

      List<SingleRestorent> Listdata = await ordersList(
        resultData,
      );

      print("result list data");
      print(Listdata.toString());

      emit(RestourentsSearchSucess(Listdata));
    } else {
      emit(RestourentsSearcfail(result.failure));
    }
  }


  Future<void> Letusknow(String name,String address,String contact, String phone) async {
    emit(LetusknowLoading());
    Result? result = await restorentListRepository.letusKnow(name,address,contact,phone);
    if (result.isSuccess) {
      emit(LetusknowSuccessFull());
    } else {
      emit(LetusknowFail(result.failure));
    }
  }

}

List<SingleRestorent> ordersList(List data) {
  List<SingleRestorent> _orders = [];
  var length = data.length;
  print(length.toString());

  for (int i = 0; i < length; i++) {
    SingleRestorent order = SingleRestorent(
        id: data[i]["id"],
        name: data[i]["name"],
        email: data[i]["email"],
        address: data[i]["address"],
        city: data[i]["city"],
        country: data[i]["country"],
        userType: data[i]["user_type"],
        longitude: data[i]["longitude"],
        latitude: data[i]["latitude"],
        // distance: data[i]["distance"],
        profilePhotoUrl: data[i]["profile_photo_url"],
        zip: data[i]["zip"],
        website: data[i]["website"],
        followers: data[i]["followers"],
        followings: data[i]["followings"]);
    _orders.add(order);
  }
  return _orders;
}
