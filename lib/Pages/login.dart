import 'dart:convert';

import 'package:RestaurantAppMobile/Models/LoginResponse.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:RestaurantAppMobile/Pages/table_selection.dart';
import 'package:RestaurantAppMobile/Services/AuthService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:RestaurantAppMobile/Models/constants.dart' as Constants;

class LoginUI extends StatefulWidget {
  LoginUI({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  SharedPreferences _pref;
  AuthService _authService = AuthService();
  bool _isLoading = false;
  static TextEditingController usernameController = new TextEditingController();
  static TextEditingController passwordController = new TextEditingController();
  _doNotAllowLoggedUser(context) async {
    SharedPreferences _pref;
    _pref = await SharedPreferences.getInstance();
    print(_pref.getString("userId"));
    if (_pref.getString("userId") != null) {
      _pushToTableSelectionPage(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _doNotAllowLoggedUser(context);
  }

  _pushToTableSelectionPage(context) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => TableSelectionPage()));
  }

  _login(String username, String password, BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      _pref = await SharedPreferences.getInstance();
      var _result =
          await _authService.signIn(Constants.login, username, password);
      LoginResponseModel response = LoginResponseModel.fromJson(_result);
      print(response.data.id);
      print(json.encode(_result));
      if (response.code == "200") {
        await _pref.setString(
            "userId", response.data == null ? null : response.data.id);
        await _pref.setString("userName", username);
        setState(() {
          _isLoading = false;
        });
        _pushToTableSelectionPage(context);
        //return SpinKitCircle();
      } else {
        showDialog(
            context: context,
            builder: (context) => CustomDialog(
                title: "Wrong Credentials",
                description: "Username or password is incorrect!"));
        setState(() {
          _isLoading = false;
        });
        //_showFailedMessage(context);
      }
    } catch (ex) {
      showDialog(
          context: context,
          builder: (context) => CustomDialog(
              title: "Errore",
              description:
                  "Qualcosa è andato storto. Si prega di contattare l'amministratore"));
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    inputField(controllerName, obscureText, hint) {
      return TextFormField(
        controller: controllerName,
        obscureText: obscureText,
        style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: hint,
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
      );
    }

    final emailField = inputField(usernameController, false, "Nome Utente");
    final passwordField = inputField(passwordController, true, "Password");

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          _login(usernameController.text, passwordController.text, context);
        },
        child: _isLoading
            ? SpinKitThreeBounce(
                color: Colors.white,
                size: 20.0,
              )
            : Text("Login",
                textAlign: TextAlign.center,
                style: style.copyWith(
                    color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(150, 40.0, 150, 40.0),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height - 80,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                      height: 40.0,
                      child: Image.asset(
                        "assets/ItemCategory/cat_chinese.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    emailField,
                    passwordField,
                    loginButon,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

  CustomDialog({this.title, this.description, this.buttonText, this.image});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: 400,
          padding: EdgeInsets.only(top: 30, bottom: 16, left: 2, right: 2),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                )
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error,
                color: Colors.pink,
                size: 40.0,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 10.0),
              Text(description, style: TextStyle(fontSize: 16.0)),
              SizedBox(height: 10.0),
              Align(
                alignment: Alignment.center,
                child: FlatButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    child: Text("Ok",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white)),
                    alignment: Alignment.center,
                    width: 90,
                    padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
