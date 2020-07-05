import 'package:flutter/material.dart';
import 'package:magnetgram/helper/helper.dart';
import 'package:magnetgram/helper/lang.dart';
import 'package:magnetgram/helper/style.dart';
import 'package:magnetgram/helper/variables.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  _LoginPageState();

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    print("login");
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext appContext) {
    final emailField = TextField(
      obscureText: false,
      controller: usernameController,
      style: Styles.TEXTSTYLE,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: Lang.get(Lang.TELEGRAM_USERNAME_HINT),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      controller: passwordController,
      style: Styles.TEXTSTYLE,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: Lang.get(Lang.PASSWORD_HINT),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Styles.secondaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(appContext).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (usernameController.text == "" || passwordController.text == "") {
            final snackBar = SnackBar(
              content: Text('نام کاربری و گذرواژه را وارد نمایید '),
              action: SnackBarAction(
                label: 'بستن',
                textColor: Colors.yellow,
                onPressed: () {
                  Scaffold.of(appContext).hideCurrentSnackBar();
                },
              ),
            );
            Scaffold.of(appContext).showSnackBar(snackBar);
          } else
            Helper.login(
                appContext, usernameController.text, passwordController.text);
        },
        child: Text(Lang.get(Lang.LOGIN),
            textAlign: TextAlign.center,
            style: Styles.TEXTSTYLE
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Styles.secondaryColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(appContext).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (await canLaunch("https://telegram.me/${Variable.BOT_ID}")) {
            await launch("https://telegram.me/${Variable.BOT_ID}");
          }
        },
        child: Text(Lang.get(Lang.REGISTER),
            textAlign: TextAlign.center,
            style: Styles.TEXTSTYLE
                .copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return SingleChildScrollView(
      child: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: Image.asset(
                    "images/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 45.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButton,
                SizedBox(
                  height: 15.0,
                ),
                registerButton,
                Text(
                  Lang.get(Lang.REGISTER_IS_FROM_BOT),
                  style: Styles.TEXTSTYLE,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
