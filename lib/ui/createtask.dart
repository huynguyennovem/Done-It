import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/bloc/blocs/todo_bloc.dart';
import 'package:todoapp/bloc/event/todo_event.dart';
import 'package:todoapp/entity/ReceivedNotification.dart';
import 'package:todoapp/entity/todo.dart';
import 'package:todoapp/entity/user.dart';
import 'package:todoapp/local/pref/pref.dart';
import 'package:todoapp/util/strings.dart';
import 'package:todoapp/util/utilities.dart';
import 'package:rxdart/subjects.dart';

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
  bool _hasDone = false;
  User _savedUser;
  DateTime diffTime;

  // notification
  final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject = BehaviorSubject<ReceivedNotification>();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();
  NotificationAppLaunchDetails notificationAppLaunchDetails;

  Future<void> _init() async {
    notificationAppLaunchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    // Note: permissions aren't requested here just to demonstrate that can be done later using the `requestPermissions()` method
    // of the `IOSFlutterLocalNotificationsPlugin` class
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:(int id, String title, String body, String payload) async {
          didReceiveLocalNotificationSubject.add(ReceivedNotification(id: id, title: title, body: body, payload: payload));
        });
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (String payload) async {
      if (payload != null) {
        debugPrint('notification payload: ' + payload);
      }
      selectNotificationSubject.add(payload);
    });
  }

  /// Schedules a notification that specifies a different icon, sound and vibration pattern
  Future<void> _scheduleNotification(String message) async {
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        //icon: 'app_icon',
        //sound: RawResourceAndroidNotificationSound('slow_spring_board'),
        //largeIcon: DrawableResourceAndroidBitmap('app_icon'),
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: 'slow_spring_board.aiff');
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(0, Strings.appName, message,
        diffTime, platformChannelSpecifics);
  }

  @override
  void initState() {
    super.initState();
    _init();
    _initNotification();
    _getUser();
    if (widget.todo != null) {
      _textTasknameEditingController.text = widget.todo.taskname;
      _textDatetimeController.text = widget.todo.deadline;
      _hasDone = widget.todo.hasDone;
    }
  }

  _initNotification() {
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      print("invoked on _configureDidReceiveLocalNotificationSubject " + receivedNotification.toString());
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      print("invoked on _configureSelectNotificationSubject " + payload);
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
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
            title: const Text(Strings.addNewTask),
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
                    labelText: Strings.taskName,
                    hintText: Strings.enterTaskName),
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
                      labelText: Strings.deadline,
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 16.0),
                  )),
              Expanded(
                flex: 1,
                child: RaisedButton(
                  onPressed: () => {_showDatePicker()},
                  child: Text(Strings.selectDate),
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
                    child: Text(Strings.status,
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
                      child: Text(Strings.save),
                    ),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      // Validate returns true if the form is valid, or false
                      if (_formKey.currentState.validate()) {
                        if (_textTasknameEditingController.text.isEmpty) {
                          Util().showToast(Strings.taskNameRequired);
                        } else if (_textDatetimeController.text.isEmpty) {
                          Util().showToast(Strings.deadlineRequired);
                        } else {
                          if (widget.todo == null) {
                            _todoBloc.add(AddTodoEvent(
                                username: _savedUser.email,
                                taskname: _textTasknameEditingController.text,
                                datecreate: _textDatetimeController.text,
                                hasDone: _hasDone));
                          } else {
                            var todoupdate = Todo(
                                _savedUser.email,
                                _textTasknameEditingController.text,
                                _textDatetimeController.text,
                                _hasDone);
                            todoupdate.id = widget.todo.id;
                            _todoBloc.add(UpdateTodoEvent(todoupdate));
                          }
                          _back();
                          _scheduleNotification(
                              _textTasknameEditingController.text);
                        }
                      }
                    },
                  ),
                  Container(
                    child: RaisedButton(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(Strings.cancel),
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
    DatePicker.showDateTimePicker(
        context,
        minTime: DateTime.now(),
        showTitleActions: true,
        onChanged: (date) {},
        onConfirm: (date) {
          _textDatetimeController.text = DateFormat("MM-dd-yyyy hh:mm").format(date);
          diffTime = date;
        },
        currentTime: DateTime.now(), locale: LocaleType.vi
    );
  }

  _getUser() async {
    _savedUser = await Pref.getUserInfo();
  }
}

