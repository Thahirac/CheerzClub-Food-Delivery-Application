import 'package:cheersclub/localization/app_localization.dart';
import 'package:cheersclub/localization/language_const.dart';
import 'package:cheersclub/pages/Home.dart';
import 'package:cheersclub/pages/splashScreen.dart';
import 'package:cheersclub/widgets/cheerzclub_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';



void main() async{
  //  set the publishable key for Stripe - this is mandatory
  // WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey = STRIPE_PUBLISHED_KEY;
  // await Stripe.instance.applySettings();

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // if (this._locale == null) {
    //   return Container(
    //     child: Center(
    //       child: CircularProgressIndicator(
    //           valueColor: AlwaysStoppedAnimation<Color?>(Colors.blue[800])),
    //     ),
    //   );
    // }
    // else{
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        locale: _locale,
        supportedLocales: [Locale('en', 'US'), Locale('fr', 'FR'),Locale('nl','NL'),Locale('de','DE'),Locale('es','ES')],
        localizationsDelegates:  const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale!.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        theme: ThemeData.dark(
          // primarySwatch: Colors.blue,
        ),
        home: const  Splash_screen(),
      );
    // }
  }
}
