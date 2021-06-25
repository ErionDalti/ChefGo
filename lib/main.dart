import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:RestaurantAppMobile/Pages/login.dart';
import 'package:RestaurantAppMobile/Pages/table_selection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Locale/locales.dart';
import 'Routes/routes.dart';
import 'Theme/style.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
  runApp(RestaurantApp());
}

class RestaurantApp extends StatefulWidget {
  RestaurantApp({Key key}) : super(key: key);
  @override
  _RestaurantAppState createState() => _RestaurantAppState();
}

class _RestaurantAppState extends State<RestaurantApp> {
  // This widget is the root of your application.
  bool loggedIn = false;

  _getUserLoggedIn() async {
    SharedPreferences _pref;
    _pref = await SharedPreferences.getInstance();
    setState(() {
      loggedIn = _pref.getString("userId") != null ? true : false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      ///supported Languages
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: loggedIn ? TableSelectionPage() : LoginUI(),
      routes: PageRoutes().routes(),
    );
  }
}
