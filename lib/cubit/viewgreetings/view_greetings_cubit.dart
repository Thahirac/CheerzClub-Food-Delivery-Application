import 'package:bloc/bloc.dart';
import 'package:cheersclub/cubit/repository/PlaceOrderRepo.dart';
import 'package:cheersclub/cubit/repository/ViewgreetingsRepo.dart';
import 'package:cheersclub/models/Restourent/MyGreetings.dart';
import 'package:cheersclub/models/Restourent/RestourentViewModel.dart';
import 'package:cheersclub/models/Restourent/Singlegreeting.dart';
import 'package:cheersclub/models/Restourent/products.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

part 'view_greetings_state.dart';

class MygreetingsCubit extends Cubit<MygreetingsState> {

  String? gmessage;
  dynamic filename;
  dynamic greetingpreview;

  MygreetingsCubit(this.getOnegreet) : super(MygreetingsInitial());
  final GetOneGreeting getOnegreet;


  Future<void> GetoneGreetingGet(int id) async {
    emit(MygreetingsLoading());
    Result? result = await getOnegreet.GetoneGreetingGet(id);
    if (result.isSuccess) {

      dynamic mygreetItems = result.success['greetings'];
      gmessage = mygreetItems['message'];
      filename = mygreetItems['file_name'];
      greetingpreview =mygreetItems['greeting_preview'];


      emit(MygreetingsSuccess(gmessage,filename,greetingpreview));
    } else {
      emit(MygreetingsFail());
    }
  }



  Future<void> updateGreeting(String id,String message, String message_attachment,) async {
    emit(UpdategreetingsLoading());
    Result? result = await getOnegreet.updateGreeting(id,message, message_attachment,);
    if (result.isSuccess) {


      emit(UpdategreetingsSuccess(gmessage,filename,greetingpreview));
    } else {
      emit(UpdategreetingsFail("Something went wrong"));
    }
  }

}


