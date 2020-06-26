


import 'package:equatable/equatable.dart';

class Todo extends Equatable {

  int id;
  String username, taskname, deadline;
  bool hasDone;

  Todo(this.username, this.taskname, this.deadline, this.hasDone): super([username, taskname, deadline, hasDone]);

  @override
  String toString() {
    return 'Todo{id: $id, username: $username, taskname: $taskname, datecreate: $deadline, hasDone: $hasDone}';
  }

  Map<String, dynamic> toMap() {
    return {"username": username, "taskname": taskname, "hasDone": hasDone,"datecreate":deadline};
  }

  Todo.fromMap(Map<String, dynamic> map) {
    this.username = map["username"];
    taskname = map["taskname"];
    deadline = map["datecreate"];
    hasDone = map["hasDone"];
  }
}
