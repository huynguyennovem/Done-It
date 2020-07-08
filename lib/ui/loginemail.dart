import 'package:flutter/material.dart';
import 'package:todoapp/entity/user.dart';
import 'package:todoapp/local/pref/pref.dart';
import 'package:todoapp/util/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/util/strings.dart';

class LoginEmail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginEmailPage();
  }
}

class LoginEmailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginEmailState();
  }
}

class _LoginEmailState extends State<LoginEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _passwordVisible = true;

  @override
  void initState() {
    _emailController.text = Constant.EMAIL;
    _passController.text = Constant.PASS;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(Strings.login),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16.0),
                child: _buildMainLayout()),
          ),
        ),
      ),
    );
  }

  Widget _buildMainLayout() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Text(Strings.email,
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
                              return Strings.emailRequired;
                            } else if (!emailValid) {
                              return Strings.emailWrongFormat;
                            } else if (value != Constant.EMAIL) {
                              return Strings.loginWrongInfo;
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
                      child: Text(Strings.password,
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
                          hintText: Strings.enterPassword,
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
                            return Strings.passwordRequired;
                          } else if (value.length < 6) {
                            return Strings.passwordTooShort;
                          } else if (value != Constant.PASS) {
                            return Strings.loginWrongInfo;
                          } else {
                            return null;
                          }
                        },
                      ))
                ],
              ),
            ],
          ),
          Container(
            margin:
            const EdgeInsets.symmetric(vertical: 22.0, horizontal: 22.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(Strings.login),
                    ),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      if (_formKey.currentState.validate()) {
                        _saveCredential(User("", _emailController.text, _passController.text, Constant.LOGIN_EMAIL, ""));
//                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
//                            ListTodo()), (Route<dynamic> route) => false);
                        Navigator.pushNamedAndRemoveUntil(context, "/list", (r) => false);
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

  _saveCredential(User user) {
    Pref.saveUserInfo(user);
  }
}
