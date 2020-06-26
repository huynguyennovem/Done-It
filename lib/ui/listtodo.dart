import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/bloc/get_todo_bloc.dart';
import 'package:todoapp/db/tododao.dart';
import 'package:todoapp/entity/todo.dart';
import 'package:todoapp/bloc/event/todo_event.dart';
import 'package:todoapp/bloc/state/todo_state.dart';
import 'package:todoapp/ui/createtask.dart';

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

  @override
  Widget build(BuildContext context) {
    _todoBloc = BlocProvider.of<TodoBloc>(
        context); // get todoBloc instance from BlocProvider above
    return Scaffold(
      appBar: AppBar(
        title: Text("List tasks"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Navigator.pushNamed(context, "/add", arguments: null);
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => BlocProvider.value(
                      value: _todoBloc, child: CreateTaskPage())));
        },
        child: Icon(Icons.add),
      ),
      body: BlocConsumer<TodoBloc, TodoStates>(
        listener: (context, state) {
          //print("Current state $state");
        },
        builder: (context, state) {
//          print("state: " + state.props.length.toString());
//          print("state toString: " + state.toString());
          if (state is LoadingTodoState)
            return Center(child: CircularProgressIndicator());
          else if (state is LoadedTodoState) {
            //print("List data length : ${state.list.length}");
            return _buildListUser(state.list, context);
          } else {
            return Center(child: Text("No task was found!"));
          }
        },
      ),
    );
  }

  Widget _buildListUser(List<Todo> todos, BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, index) {
          return _buildListTile(todos[index], context);
        },
        separatorBuilder: (context, index) {
          return Divider(
            height: 1,
          );
        },
        itemCount: todos.length);
  }

  Widget _buildListTile(Todo todo, BuildContext context) {
    return ListTile(
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
//      onTap: () {
//        //Navigator.pushNamed(context, "/add", arguments: todo);
//        Navigator.push(
//            context,
//            CupertinoPageRoute(
//                builder: (context) => BlocProvider.value(
//                    value: _todoBloc, child: CreateTaskPage(todo: todo,))));
//      },
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
    );
  }
}
