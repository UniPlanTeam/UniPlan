/// Login selection view
/// View screen to select mode of authentication
/// @author Julian Vu
import 'package:flutter/material.dart';
import 'package:cognito/views/login_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginSelectionView extends StatefulWidget {
  static String tag = "login-selection-view";
  @override
  _LoginSelectionViewState createState() => _LoginSelectionViewState();
}

class _LoginSelectionViewState extends State<LoginSelectionView> {
  @override
  Widget build(BuildContext context) {

    final logo = Hero(
      tag: "hero",
      child: CircleAvatar(

        backgroundColor: Colors.transparent,
        radius: 128.0,
        child: Image.asset("assets/circle_logo.png"),
      ),
    );

    final withGoogle = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ButtonTheme(
        minWidth: 200.0,
        height: 42.0,
        child: RaisedButton.icon(
          onPressed: () {},
          color: Colors.red,
          label: Text("Sign in with Google", style: Theme.of(context).accentTextTheme.body1),
          icon: Icon(Icons.explore),
          textColor: Colors.black,
        ),
      ),
    );

    final withEmail = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ButtonTheme(
        minWidth: 200.0,
        height: 42.0,
        child: RaisedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(LoginView.tag);
          },
          color: Theme.of(context).accentColor,
          child: Text("Sign in with Email", style: Theme.of(context).accentTextTheme.body1),
        ),
      ),
    );

    final signUp = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: ButtonTheme(
        minWidth: 200.0,
        height: 42.0,
        child: RaisedButton(
          onPressed: () {},
          color: Theme.of(context).primaryColorLight,
          child: Text("Sign Up", style: Theme.of(context).accentTextTheme.body1,),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 64.0,),
            withGoogle,
            withEmail,
            signUp,
          ],
        ),
      ),
    );
  }
}