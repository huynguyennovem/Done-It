import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/bloc/get_todo_bloc.dart';
import 'package:todoapp/entity/todo.dart';
import 'package:todoapp/entity/user.dart';
import 'package:todoapp/event/todo_event.dart';
import 'package:todoapp/state/get_todo_state.dart';

class ListTodo extends StatelessWidget {

  final User user;
  ListTodo({Key key, this.user}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo app',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ListTodoPage(user: user,),
    );
  }
}

class ListTodoPage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final User user;

  ListTodoPage({Key key, this.user}) : super(key: key);

  @override
  _ListTodoPageState createState() => _ListTodoPageState();
}

class _ListTodoPageState extends State<ListTodoPage> {

  GetTodoBloc _getTodoBloc;

  @override
  void initState() {
    super.initState();
    _getTodoBloc = new GetTodoBloc();
  }

  @override
  Widget build(BuildContext context) {

    _getTodoBloc.dispatch(GetTodoEvent());

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return BlocProvider(
      builder: (context) => _getTodoBloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text("List tasks"),
          centerTitle: true,
        ),
        body: BlocBuilder(
          bloc: _getTodoBloc,
          builder: (context, GetTodoState state) {
            if (state is GetTodoUnInitial)
              return Container();
            else if (state is GetTodoLoading)
              return Center(child: CircularProgressIndicator());
            else if (state is GetTodoSuccess)
              return _buildListUser(state.todos);
            else {
              return Center(child: Text("No task was found!"));
            }
          },
        ),
      ),
    );
  }

  Widget _buildListUser(List<Todo> todos) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.person, color: Colors.black,size: 48),
            title: Text(
              todos[index].username,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            subtitle: Text(
              todos[index].taskname,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 1,
          );
        },
        itemCount: todos.length);
  }
}
