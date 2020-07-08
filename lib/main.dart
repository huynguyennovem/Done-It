import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todoapp/ui/createtask.dart';
import 'package:todoapp/ui/listtodo.dart';
import 'package:todoapp/ui/loginemail.dart';
import 'package:todoapp/ui/loginmethod.dart';
import 'package:todoapp/ui/splash.dart';
import 'package:todoapp/util/strings.dart';

void main() {
  //debugPaintSizeEnabled = true;
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
      routes: {
        '/loginmethod': (context) => LoginMethodPage(),
        '/loginemail': (context) => LoginEmail(),
        '/list': (context) => ListTodoPage(),
        '/add': (context) => CreateTaskPage(),
      },
    );
  }
}
