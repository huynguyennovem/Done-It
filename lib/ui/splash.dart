import 'package:flutter/material.dart';
import 'package:todoapp/local/pref/pref.dart';
import 'package:todoapp/util/strings.dart';

class SplashPage extends StatelessWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashPageful();
  }
}

class SplashPageful extends StatefulWidget {
  SplashPageful({Key key}) : super(key: key);

  @override
  _SplashPagefulState createState() {
    return _SplashPagefulState();
  }
}

class _SplashPagefulState extends State<SplashPageful> {
  bool checkSessionValid;

  @override
  void initState() {
    super.initState();
    // count down 2s
    // check session login
    _getSessionStt();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        if (checkSessionValid) {
          Navigator.pushNamedAndRemoveUntil(context, "/list", (r) => false);
          Pref.extendSessionTime();
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, "/loginmethod", (r) => false);
        }
      });
    });
  }

  _getSessionStt() async {
    checkSessionValid = await Pref.isSessionValid();
    print("Has logined: " + checkSessionValid.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg_loginmethod.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(8.0),
                child: Image(
                    image: AssetImage("assets/images/app_icon.png"),
                    height: 48.0,
                    width: 48.0),
              ),
              Text(Strings.appName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0)),
            ],
          ),
        )
    );
  }
}
