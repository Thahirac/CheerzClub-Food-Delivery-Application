import 'package:bloc/bloc.dart';
import 'package:cheersclub/Utils/managers/user_manager.dart';
import 'package:cheersclub/cubit/repository/LoginRepository.dart';
import 'package:cheersclub/models/auth/user.dart';
import 'package:meta/meta.dart';
import 'package:result_type/result_type.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {

  int? isCompany;
  bool? isCompleted;


  final LoginRepository loginRepository;
  LoginCubit(this.loginRepository) : super(LoginInitial());



  Future<void> authenticateUser(String? username, String? password) async {
    emit(LoginLoading());
    Result? result = await loginRepository.authenticateUser(username, password);

    if (result.isSuccess) {
      UserSession userSession = UserSession.fromJson(result.success);
      UserManager.instance.setUserSession(userSession);

      isCompany=result.success["user"]["is_company"];
      isCompleted=result.success["user"]["is_completed"];

      emit(LoginSuccessFull(userSession,isCompany,isCompleted));
    }
    else {
      emit(LoginFailed(result.failure));
    }
  }



  Future<void> socialauthenticateUser(String? token, String? provider) async {
    emit(LoginLoading());
    Result? result = await loginRepository.socialauthenticateUser(token, provider);

    if (result.isSuccess) {
      UserSession userSession = UserSession.fromJson(result.success);
      UserManager.instance.setUserSession(userSession);

      isCompany=result.success["user"]["is_company"];
      isCompleted=result.success["user"]["is_completed"];

      emit(LoginSuccessFull(userSession,isCompany,isCompleted));
    }
    else {
      emit(LoginFailed(result.failure));
    }
  }




}
