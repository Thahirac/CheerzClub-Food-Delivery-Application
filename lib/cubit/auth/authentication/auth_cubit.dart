import 'package:bloc/bloc.dart';
import 'package:cheersclub/Utils/managers/user_manager.dart';
import 'package:cheersclub/cubit/repository/authentication_repository.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

//after push
class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit(AuthenticationState state, this.authRepository)
      : super(AuthenticationIntial());
  final AuthenticationRepository authRepository;

  Future<void> getAuthenticationState() async {
    bool isUserLoggedIn = await UserManager.instance.isUserAlreadyLoggedIn();
    String token = await authRepository.getToken();
    String accountType = await authRepository.getAccountType();
    if (isUserLoggedIn && token != null) {
      emit(Authenticated(token,accountType));
    } else {
      emit(UnAuthenticated());
    }
  }
}
