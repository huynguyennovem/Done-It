import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/bloc/event/todo_event.dart';
import 'package:todoapp/bloc/get_todo_bloc.dart';
import 'package:todoapp/bloc/state/todo_state.dart';
import 'package:todoapp/entity/todo.dart';

class CreateTaskPage extends StatefulWidget {
  final Todo todo;

  CreateTaskPage({Key key, this.todo}) : super(key: key);

  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreateTaskPage> {
  TodoBloc _todoBloc;
  final _formKey = GlobalKey<FormState>();
  final _textTasknameEditingController = TextEditingController();
  final _textDatetimeController = TextEditingController();
  String _email;
  bool _hasDone = false;

  @override
  void initState() {
    super.initState();
    _getCredential();
    if (widget.todo != null) {
      _textTasknameEditingController.text = widget.todo.taskname;
      _textDatetimeController.text = widget.todo.deadline;
      _hasDone = widget.todo.hasDone;
    }
  }

  @override
  Widget build(BuildContext context) {
    _todoBloc = BlocProvider.of<TodoBloc>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Add new task"),
            centerTitle: true,
            leading: Padding(
              padding: EdgeInsets.only(left: 12),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  _back();
                },
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                  padding: EdgeInsets.all(16.0), child: _buildMainLayout()),
            ),
          )),
    );
  }

  Widget _buildMainLayout() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: TextField(
                controller: _textTasknameEditingController,
                decoration: InputDecoration(
                    labelText: 'Task name', hintText: "Enter task name"),
              ))
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: TextField(
                    enabled: false,
                    controller: _textDatetimeController,
                    decoration: InputDecoration(
                      labelText: 'Deadline',
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 16.0),
                  )),
              Expanded(
                flex: 1,
                child: RaisedButton(
                  onPressed: () => {_showDatePicker()},
                  child: Text('Select date'),
                ),
              )
            ],
          ),
          Visibility(
            visible: widget.todo == null ? false : true,
            child: Row(
              children: <Widget>[
                Expanded(
                    flex: 3,
                    child: Text("Status",
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 16.0))),
                Expanded(
                    flex: 1,
                    child: Checkbox(
                      value: _hasDone,
                      onChanged: (bool newValue) {
                        setState(() {
                          _hasDone = newValue;
                        });
                      },
                    ))
              ],
            ),
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(vertical: 22.0, horizontal: 22.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 22.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("SAVE"),
                    ),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      if (_formKey.currentState.validate()) {
                        if (_textTasknameEditingController.text.isEmpty) {
                          _showToast("Task name is required!");
                        } else if (_textDatetimeController.text.isEmpty) {
                          _showToast("Deadline is required!");
                        } else {
                          if (widget.todo == null) {
                            _todoBloc.add(AddTodoEvent(
                                username: _email,
                                taskname: _textTasknameEditingController.text,
                                datecreate: _textDatetimeController.text,
                                hasDone: _hasDone));
                          } else {
                            var todoupdate = Todo(
                                _email,
                                _textTasknameEditingController.text,
                                _textDatetimeController.text,
                                _hasDone);
                            todoupdate.id = widget.todo.id;
                            _todoBloc.add(UpdateTodoEvent(todoupdate));
                          }
                          _back();
                        }
                      }
                    },
                  ),
                  Container(
                    child: RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text("CANCEL"),
                      ),
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () {
                        // Validate returns true if the form is valid, or false
                        _back();
                      },
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _back() {
    Navigator.pop(context);
  }

  void _showDatePicker() {
    DatePicker.showDatePicker(context,
        showTitleActions: true, onChanged: (date) {}, onConfirm: (date) {
      _textDatetimeController.text = DateFormat("MM-dd-yyyy").format(date);
    }, currentTime: DateTime.now(), locale: LocaleType.vi);
  }

  void _showToast(String mess) {
    Fluttertoast.showToast(
        msg: mess,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.amberAccent,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  _getCredential() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = prefs.getString("login_email").toString();
  }
}
