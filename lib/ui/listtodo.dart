import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/bloc/blocs/todo_bloc.dart';
import 'package:todoapp/db/tododao.dart';
import 'package:todoapp/entity/todo.dart';
import 'package:todoapp/bloc/event/todo_event.dart';
import 'package:todoapp/bloc/state/todo_state.dart';
import 'package:todoapp/entity/todocategory.dart';
import 'package:todoapp/entity/user.dart';
import 'package:todoapp/local/pref/pref.dart';
import 'package:todoapp/ui/createtask.dart';
import 'package:todoapp/util/strings.dart';

class ListTodoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<TodoBloc>(
        create: (context) => TodoBloc(TodoDao())..add(QueryTodoEvent()),
        child: ListTodoPageful());
  }
}

class ListTodoPageful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListTodoState();
  }
}

class ListTodoState extends State<ListTodoPageful> {
  TodoBloc _todoBloc;
  List<Todo> filteredListTodo = List<Todo>();
  List<Todo> filteredListTodoDone = List<Todo>();
  List<TodoCategory> listCats = List<TodoCategory>();
  User _savedUser;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      //'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  void _handleSignOut() async{
    await _googleSignIn.signOut();
    print("User Sign Out");
  }

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  _getUser() async{
    _savedUser = await Pref.getUserInfo();
  }

  _clearData() {
    filteredListTodo.clear();
    filteredListTodoDone.clear();
    listCats.clear();
  }

  @override
  Widget build(BuildContext context) {
    _todoBloc = BlocProvider.of<TodoBloc>(
        context); // get todoBloc instance from BlocProvider above
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            FutureBuilder<User>(
                future: Pref.getUserInfo(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var urlImage = snapshot.data.avatar;
                    return DrawerHeader(
                      child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: urlImage.isEmpty
                                          ? AssetImage(
                                              "assets/images/person.png")
                                          : NetworkImage(urlImage),
                                    )),
                                width: 60.0,
                                height: 60.0,
                                margin:
                                    const EdgeInsets.fromLTRB(8.0, 0, 16.0, 0),
                              ),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: Text(
                                        snapshot.data.name ?? "",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                    ),
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            snapshot.data.email ?? "",
                                            style: TextStyle(
                                                color: Colors.white60),
                                          ),
                                          /*Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                                            child: SizedBox(
                                              width: 16.0,
                                              height: 16.0,
                                              child: IconButton(padding: const EdgeInsets.all(0.0),
                                                  icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                                                  iconSize: 16.0,
                                                  onPressed: () {

                                                  }),
                                            ),
                                          )*/
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    return DrawerHeader(
                      child: Text(Strings.appName),
                    );
                  }
                }),
            ListTile(
              title: Text(Strings.allTasks),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            /*ListTile(
              title: Text(Strings.settings),
              onTap: () {
                Navigator.pop(context);
              },
            ),*/
            ListTile(
              title: Text(Strings.logout),
              onTap: () {
                _handleSignOut();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/loginmethod", (r) => false);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(Strings.yourTasks),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => BlocProvider.value(
                      value: _todoBloc, child: CreateTaskPage())));
        },
        child: Icon(Icons.add),
      ),
      body: BlocConsumer<TodoBloc, TodoStates>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is LoadingTodoState)
            return Center(child: CircularProgressIndicator());
          else if (state is LoadedTodoState) {
//            return FutureBuilder<User>(
//                future: Pref.getUserInfo(),
//                builder: (context, snapshot) {
//                  if (snapshot.hasData) {
//                    _filterListTodo(state.list, snapshot.data);
//                    return _buildListTodo(context);
//                  }
//                  return ListView();
//                });
            print("saved user: " + _savedUser.toString());
            _filterListTodo(state.list, _savedUser);
            return _buildListTodo(context);
          } else {
            return Center(child: Text(Strings.noTaskFound));
          }
        },
      ),
    );
  }

  _filterListTodo(List<Todo> rawList, User user) {
    _clearData();
    if (rawList.length > 0) {
      filteredListTodo =
          rawList.where((element) => element.username == user.email && element.hasDone == false).toList();
      filteredListTodoDone =
          rawList.where((element) => element.username == user.email && element.hasDone == true).toList();
      TodoCategory catCurrent =
          TodoCategory(Strings.currentTasks, filteredListTodo);
      TodoCategory catDone =
          TodoCategory(Strings.doneTasks, filteredListTodoDone);
      listCats.add(catCurrent);
      listCats.add(catDone);
    }
  }

  Widget _buildListTodo(BuildContext context) {
    print("list cats: " + listCats.length.toString());
    return ListView.builder(
        itemBuilder: (context, index) {
          return _buildListTileExpand(listCats[index], context);
        },
        itemCount: listCats.length);
  }

  Widget _buildListTileExpand(TodoCategory todoCategory, BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(todoCategory.title),
      children: <Widget>[
        Column(
          children: _buildExpandableContent(todoCategory),
        )
      ],
    );
  }

  _buildExpandableContent(TodoCategory todoCategory) {
    List<Widget> columnContent = [];
    for (Todo todo in todoCategory.listTodo)
      columnContent.add(
        ListTile(
          title: todo.hasDone
              ? Text(
                  todo.taskname,
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.blue,
                      color: Colors.blue),
                )
              : Text(todo.taskname),
          leading: GestureDetector(
            onTap: () {
              //toggle task bloc.state
              if (todo.hasDone) {
                todo.hasDone = false;
              } else {
                todo.hasDone = true;
              }
              //update item
              _todoBloc.add(UpdateTodoEvent(todo));
            },
            child: Container(
              child: todo.hasDone
                  ? Icon(
                      Icons.check_circle_outline,
                      color: Colors.blue,
                    )
                  : Icon(Icons.radio_button_unchecked),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            builder: (context) => BlocProvider.value(
                                value: _todoBloc,
                                child: CreateTaskPage(
                                  todo: todo,
                                ))));
                  }),
              IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () {
                    //delete item
                    _todoBloc.add(DeleteTodoEvent(todo.id));
                  }),
            ],
          ),
          onLongPress: () {
            //toggle task bloc.state
            if (todo.hasDone) {
              todo.hasDone = false;
            } else {
              todo.hasDone = true;
            }
            //update item
            _todoBloc.add(UpdateTodoEvent(todo));
          },
        ),
      );

    return columnContent;
  }
}
