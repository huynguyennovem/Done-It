import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import "package:http/http.dart" as http;
import 'package:todoapp/entity/user.dart';
import 'package:todoapp/local/pref/pref.dart';
import 'package:todoapp/util/constant.dart';
import 'package:todoapp/util/strings.dart';
import 'dart:convert' show json;

import 'package:todoapp/util/utilities.dart';

class LoginMethodPage extends StatefulWidget {
  LoginMethodPage({Key key}) : super(key: key);

  @override
  _LoginMethodPageState createState() {
    return _LoginMethodPageState();
  }
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    //'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class _LoginMethodPageState extends State<LoginMethodPage> {
  GoogleSignInAccount _currentUser;
  String _contactText;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _contactText = _currentUser.displayName;
        Util().showToast("Hi $_contactText!");
        User user = User(_currentUser.displayName, _currentUser.email, "", Constant.LOGIN_GG, _currentUser.photoUrl);
        print("User info: " + user.toString());
        _saveCredential(user);
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pushNamedAndRemoveUntil(context, "/list", (r) => false);
        });
      }
    });
    _googleSignIn.signInSilently();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _mainBuildLayout(context);
  }

  Widget _mainBuildLayout(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg_loginmethod.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        alignment: Alignment.bottomCenter,
        margin: const EdgeInsets.symmetric(vertical: 15.0),
        child: SingleChildScrollView(
          child: Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  //_test(),
                  _buildButton(
                      Image(
                          image: AssetImage("assets/images/ic_google.png"),
                          height: 30.0,
                          width: 40.0),
                      Text(Strings.signInWithGoogle,
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Colors.blue,
                      () => {_loginWithGoogle()}),
                  _buildButton(
                      Image(
                          image: AssetImage("assets/images/ic_facebook.png"),
                          height: 30.0,
                          width: 40.0),
                      Text(Strings.signInWithFacebook,
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Colors.blueAccent,
                      () => {_loginWithFacebook()}),
                  _buildButton(
                      Image(
                        image: AssetImage("assets/images/ic_email.png"),
                        height: 30.0,
                        width: 40.0,
                      ),
                      Text(Strings.signInWithEmail,
                          style: TextStyle(fontSize: 16, color: Colors.grey)),
                      Colors.white,
                      () => {_loginWithEmail(context)}),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildButton(
      Image drawableStart, Text textButton, Color bgColor, Function function) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        width: 256.0,
        child: FlatButton(
          color: bgColor,
          splashColor: Colors.grey,
          onPressed: () {
            function();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            //side: BorderSide(width: 0.5, color: Colors.grey)
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 12, 4, 12),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                drawableStart,
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: textButton,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }
/*

  Widget _test() {
    if (_currentUser != null) {
      return Container(
          margin: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(_contactText));
    } else {
      return Text("");
    }
  }

  Future<void> _handleGetContact() async {
    setState(() {
      _contactText = "Loading contact info...";
    });
    final http.Response response = await http.get(
      'https://people.googleapis.com/v1/people/me/connections'
      '?requestMask.includeField=person.names',
      headers: await _currentUser.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = "People API gave a ${response.statusCode} "
            "response. Check logs for details.";
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = "I see you know $namedContact!";
      } else {
        _contactText = "No contacts to display.";
      }
    });
  }
*/

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'];
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    );
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      );
      if (name != null) {
        return name['displayName'];
      }
    }
    return null;
  }

  _loginWithEmail(BuildContext context) {
    print("Select login with Email");
    Navigator.pushNamedAndRemoveUntil(context, "/loginemail", (r) => false);
  }

  _loginWithGoogle() {
    print("Select login with Google");
    _handleSignIn();
  }

  _loginWithFacebook() {
    print("Select login with Facebook");
  }

  _saveCredential(User user) {
    Pref.saveUserInfo(user);
  }
}
