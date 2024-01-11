import 'package:bloc/bloc.dart';
import 'package:cheersclub/cubit/repository/forgotPassRepo.dart';
import 'package:result_type/result_type.dart';

part 'forget_pass_word_state.dart';

class ForgetPassWordCubit extends Cubit<ForgetPassWordState> {
  final ForgetPassRe forgetPassRe;
  ForgetPassWordCubit(this.forgetPassRe) : super(ForgetPassWordInitial());

  Future<void> authenticateUser(String? username,) async {
    emit(ForgetPassWordLoading());
    Result? result = await forgetPassRe.ForgetPassReo(username);

    if (result.isSuccess) {
      emit(ForgetPassWordSuccessFull());
    } else {
      emit(ForgetPassWordFailed(result.failure));
    }
  }

  Future<void> ResetPass(String? email,String? token,String? password,String? password_confirmation) async {
    emit(ResetPasswordLoading());
    Result? result = await forgetPassRe.ResetPass(email,token, password,password_confirmation);

    if (result.isSuccess) {
      emit(ResetPasswordSuccessFull());
    } else {
      emit(ResetPasswordFailed(result.failure));
    }
  }

}
