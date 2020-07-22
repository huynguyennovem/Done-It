import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/entity/user.dart';
import 'package:todoapp/util/constant.dart';

class Pref {

  static const String KEY_USER_LOGIN = "login_user";
  static const String KEY_USER_SS_EXPIRE = "user_session_expire";

  static void saveUserInfo(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(KEY_USER_LOGIN, jsonEncode(user.toMap()));
    await prefs.setInt(KEY_USER_SS_EXPIRE,
        DateTime.now().millisecondsSinceEpoch + Constant.SESSION_DURATION_TEST);
  }

  static Future<User> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userString = prefs.getString(KEY_USER_LOGIN);
    return User.fromMap(jsonDecode(userString));
  }

  static void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(KEY_USER_LOGIN);
    prefs.remove(KEY_USER_SS_EXPIRE);
  }

  static Future<bool> isSessionValid() async {
    var currentTime = DateTime.now().millisecondsSinceEpoch;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int expireTime = prefs.getInt(KEY_USER_SS_EXPIRE);
    if(expireTime != null)
      return expireTime < currentTime;
    return false;
  }

  static Future<void> extendSessionTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(KEY_USER_SS_EXPIRE,
        DateTime.now().millisecondsSinceEpoch + Constant.SESSION_DURATION_TEST);
  }

}
