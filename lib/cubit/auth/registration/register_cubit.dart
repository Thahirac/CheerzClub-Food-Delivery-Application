import 'package:bloc/bloc.dart';
import 'package:cheersclub/Utils/managers/user_manager.dart';
import 'package:cheersclub/cubit/repository/RegistrationRepository.dart';
import 'package:cheersclub/models/auth/user.dart';
import 'package:result_type/result_type.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {

  int? isCompany;
  bool? isCompleted;

  final RegistrationRepository registrationRepository;
  RegisterCubit(this.registrationRepository) : super(RegisterInitial());



  Future<void> authenticateUser(String? username, String? email,
      int? is_company, String? password, String password_confirmation) async {
    emit(RegistrationLoading());
    Result? result = await registrationRepository.registerUser(
        username, email, is_company, password, password_confirmation);

    if (result.isSuccess) {
      // UserSession userSession = UserSession.fromJson(result.success);
      // UserManager.instance.setUserSession(userSession);
      // isCompany=result.success["user"]["is_company"];
      // isCompleted=result.success["user"]["is_completed"];

      emit(RegistrationLoginSuccessFull(result.success));
    } else {
      emit(RegistrationFailed(result.failure));
    }
  }


  Future<void> socialauthenticateUser(String? token, String? provider) async {
    emit(RegistrationLoading());
    Result? result = await registrationRepository.socialauthenticateUser(token, provider);

    if (result.isSuccess) {
      UserSession userSession = UserSession.fromJson(result.success);
      UserManager.instance.setUserSession(userSession);
      emit(RegistrationSuccessFull(userSession,isCompany,isCompleted,));
    }
    else {
      emit(RegistrationFailed(result.failure));
    }
  }


}
