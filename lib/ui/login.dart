import 'package:flutter/material.dart';


void main() {
  runApp(Login());
}

class Login extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Login",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }

}

class LoginPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    throw UnimplementedError();
  }

}