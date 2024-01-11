/*
import 'package:cheersclub/auth_controller/instagram_login/instagram_constants.dart';
import 'package:cheersclub/auth_controller/instagram_login/instagram_model.dart';
import 'package:cheersclub/cubit/auth/login/login_cubit.dart';
import 'package:cheersclub/cubit/repository/LoginRepository.dart';
import 'package:cheersclub/pages/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class InstagramView extends StatefulWidget {
  const InstagramView({Key? key}) : super(key: key);

  @override
  State<InstagramView> createState() => _InstagramViewState();
}

class _InstagramViewState extends State<InstagramView> {
  late LoginCubit loginCubit;

  @override
  void initState() {
    loginCubit = LoginCubit(UserLoginRepository());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(builder: (context) {
        final webview = FlutterWebviewPlugin();
        final InstagramModel instagram = InstagramModel();

        buildRedirectToHome(webview, instagram, context);

        return WebviewScaffold(
          url: InstagramConstant.instance.url,
          resizeToAvoidBottomInset: true,
          // appBar: buildAppBar(context),
        );
      }),
    );
  }

  Future<void> buildRedirectToHome(FlutterWebviewPlugin webview,
      InstagramModel instagram, BuildContext context) async {
    webview.onUrlChanged.listen((String url) async {
      if (url.contains(InstagramConstant.redirectUri)) {
        instagram.getAuthorizationCode(url);
        await instagram.getTokenAndUserID().then((isDone) {
          if (isDone) {
            instagram.getUserProfile().then((isDone) async {
              await webview.close();

              print('${instagram.username} logged in!');

              await  loginCubit.socialauthenticateUser(
                  instagram.accessToken, "instagram");


              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => LoginScreen(
              //       token: instagram.accessToken.toString(),
              //     ),
              //   ),
              // );

            });
          }
        });
      }
    });
  }
}
*/
