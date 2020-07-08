import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/entity/user.dart';
import 'package:todoapp/util/constant.dart';

class Pref {
  static void saveUserInfo(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('login_user', jsonEncode(user.toMap()));
    await prefs.setInt('user_session_expire',
        DateTime.now().millisecondsSinceEpoch + Constant.SESSION_DURATION_TEST);
  }

  static Future<User> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userString = prefs.getString('login_user');
    return User.fromMap(jsonDecode(userString));
  }

  static Future<bool> isSessionValid() async {
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int expireTime = prefs.getInt('user_session_expire');
    if(expireTime != null)
      return expireTime < currentTime;
    return false;
  }

  static Future<void> extendSessionTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_session_expire',
        DateTime.now().millisecondsSinceEpoch + Constant.SESSION_DURATION_TEST);
  }

}
