import 'dart:ffi';

import 'package:auntravel/utility/my_style.dart';
import 'package:auntravel/utility/normal_dialog.dart';
import 'package:auntravel/widget/register.dart';
import 'package:auntravel/widget/travel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Authen extends StatefulWidget {
  @override
  _AuthenState createState() => _AuthenState();
}

class _AuthenState extends State<Authen> {
  //  Feild

  String user = '', password = '';

  // Method

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  Future<void> checkStatus() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await firebaseAuth.currentUser();
    if (firebaseUser != null) {
      routeToTravel();
    }


  }

  Widget singInButton() {
    return RaisedButton(
      color: MyStyle().textcolor,
      child: Text(
        'Sign In',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        checkAuthen();
      },
    );
  }

  Future<void> checkAuthen() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .signInWithEmailAndPassword(email: user, password: password)
        .then((response) {
      routeToTravel();
    }).catchError((response) {
      String title = response.code;
      String message = response.message;
      normalDialog(context, title, message);
    });
  }

  void routeToTravel() {
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext buildContext) => Travel());
    Navigator.of(context).pushAndRemoveUntil(
        materialPageRoute, (Route<dynamic> route) => false);
  }

  Widget singUpButton() {
    return OutlineButton(
      child: Text(
        'Sign Up',
        style: TextStyle(color: MyStyle().textcolor),
      ),
      onPressed: () {
        print('You Click Sign Up');

        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext buidContext) {
          return Register();
        });
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget showButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        singInButton(),
        SizedBox(
          width: 10.0,
        ),
        singUpButton(),
      ],
    );
  }

  Widget userForm() {
    return Container(
      width: 250.0,
      child: TextField(
        onChanged: (String string) {
          user = string.trim();
        },
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyStyle().textcolor)),
          prefixIcon: Icon(
            Icons.email,
            color: MyStyle().textcolor,
          ),
          hintText: 'User :',
          hintStyle: TextStyle(color: MyStyle().textcolor),
        ),
      ),
    );
  }

  Widget passForm() {
    return Container(
      width: 250.0,
      child: TextField(
        onChanged: (String string) {
          password = string.trim();
        },
        obscureText: true,
        decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: MyStyle().textcolor)),
          prefixIcon: Icon(
            Icons.lock,
            color: MyStyle().textcolor,
          ),
          hintText: 'password :',
          hintStyle: TextStyle(color: MyStyle().textcolor),
        ),
      ),
    );
  }

  Widget showLogo() {
    return Container(
      width: 120.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showAppName() {
    return Text(
      'ล็อคอินเข้าสู่ระบบ',
      style: MyStyle().h1Text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(color: MyStyle().mainColor),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 0.5,
            colors: <Color>[
              Colors.white,
              MyStyle().mainColor,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              showLogo(),
              showAppName(),
              userForm(),
              passForm(),
              SizedBox(
                height: 10.0,
              ),
              showButton(),
            ],
          ),
        ),
      ),
    );
  }
}
