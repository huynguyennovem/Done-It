

import 'package:sembast/sembast.dart';
import 'package:todoapp/db/dbhelper.dart';
import 'package:todoapp/entity/todo.dart';

class TodoDao {

  static const String TODO_STORE_NAME = "todo_Store";

  //create store, passing the store name as an argument
  final _todoStore = intMapStoreFactory.store(TODO_STORE_NAME);

  //get the db from the AppDatabase class. this db object will
  //be used through out the app to perform CRUD operations
  Future<Database> get _db  async=> await DBHelper.instance.database;

  //insert _todo to store
  Future insert(Todo todo) async {
    await _todoStore.add( await _db, todo.toMap());
  }

  //update _todo item in db
  Future update(Todo todo) async{
    // finder is used to filter the object out for update
    final finder = Finder(filter: Filter.byKey(todo.id));
    await _todoStore.update( await _db, todo.toMap(),finder: finder);
  }

  //delete _todo item
  Future delete(int id) async {
    //get refence to object to be deleted using the finder method of sembast,
    //specifying it's id
    final finder = Finder(filter: Filter.byKey(id));

    await _todoStore.delete(await _db, finder: finder);
  }

  //get all listem from the db
  Future<List<Todo>> getAllSortedByTimeStamp() async {

    //sort the _todo item in order of their timestamp
    //that is entry time
    final finder = Finder(sortOrders: [SortOrder("timeStamp",false)]);

    //get the data
    final snapshot = await _todoStore.find(
      await _db,
      finder: finder,
    );

    //call the map operator on the data
    //this is so we can assign the correct value to the id from the store
    //After we return it as a list
    return snapshot.map((snapshot) {
      final todo = Todo.fromMap(snapshot.value);

      todo.id = snapshot.key;
      return todo;
    }).toList();
  }

}