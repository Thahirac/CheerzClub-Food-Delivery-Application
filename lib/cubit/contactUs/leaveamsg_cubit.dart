import 'package:bloc/bloc.dart';
import 'package:cheersclub/cubit/repository/PlaceOrderRepo.dart';
import 'package:cheersclub/cubit/repository/ViewgreetingsRepo.dart';
import 'package:cheersclub/cubit/repository/leaveamessaRepo.dart';
import 'package:cheersclub/models/Restourent/MyGreetings.dart';
import 'package:cheersclub/models/Restourent/RestourentViewModel.dart';
import 'package:cheersclub/models/Restourent/Singlegreeting.dart';
import 'package:cheersclub/models/Restourent/products.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

part 'leaveamsg_state.dart';

class LeaveaMsgCubit extends Cubit<LeaveaMsgState> {

  LeaveaMsgCubit(this.leavemsg) : super(LeaveamessageInitial());
  final PostleaveaMsg leavemsg;


  Future<void> leaveamessage(String name,String email, String phone,String message) async {
    emit(LeaveamessageLoading());
    Result? result = await leavemsg.leaveamessage(name,email,phone,message);
    if (result.isSuccess) {


      emit(LeaveamessageSuccess());
    } else {
      emit(LeaveamessageFail(result.failure));
    }
  }

}


