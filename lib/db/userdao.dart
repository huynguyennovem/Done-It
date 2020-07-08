import 'package:sembast/sembast.dart';
import 'package:todoapp/db/dbhelper.dart';
import 'package:todoapp/entity/user.dart';

class UserDao {
  static const String USER_STORE_NAME = "user_Store";

  final _userStore = intMapStoreFactory.store(USER_STORE_NAME);

  Future<Database> get _db async => await DBHelper.instance.database;

  Future insert(User user) async {
    await _userStore.add(await _db, user.toMap());
  }

  Future delete(String email) async {
    final finder = Finder(filter: Filter.byKey(email));
    await _userStore.delete(await _db, finder: finder);
  }

  Future<bool> isExist(String email) async {
    final f = Finder(filter: Filter.byKey(email));
    var listRs = await _userStore.find(await _db, finder: f);
    if (listRs.length > 0) return true;
    return false;
  }
}
