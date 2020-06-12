import 'dart:html';

import 'package:flutter/material.dart';
import 'package:todoapp/ui/listtodo.dart';
import 'package:todoapp/util/constant.dart';

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
    return _LoginState();
  }
}

class _LoginState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
              padding: EdgeInsets.all(16.0), child: _buildMainLayout()),
        ),
      ),
    );
  }

  Widget _buildMainLayout() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Text("Email:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0))),
              Expanded(
                  flex: 3,
                  child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailController,
                      validator: (value) {
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (value.isEmpty) {
                          return "Email is required!";
                        } else if (!emailValid) {
                          return "Email is wrong format!";
                        } else if (value != Constant().EMAIL) {
                          return "Login info is wrong!";
                        } else {
                          return null;
                        }
                      }))
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Text("Password:",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0))),
              Expanded(
                  flex: 3,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _passController,
                    obscureText: _passwordVisible,
                    //This will obscure text dynamically
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      // Here is key idea
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Based on passwordVisible state choose the icon
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          // Update the state i.e. toogle the state of passwordVisible variable
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Password is required!";
                      } else if (value.length < 6) {
                        return "Password too short";
                      } else if (value != Constant().PASS) {
                        return "Login info is wrong!";
                      } else {
                        return null;
                      }
                    },
                  ))
            ],
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(vertical: 22.0, horizontal: 22.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("LOGIN"),
                    ),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      if (_formKey.currentState.validate()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ListTodo()));
                      }
                    },
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
