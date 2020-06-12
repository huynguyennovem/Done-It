


class Todo {

  int id;
  String username, taskname, datecreate;
  bool hasDone;

  Todo(this.username, this.taskname, this.datecreate, this.hasDone);

  @override
  String toString() {
    return 'Todo{id: $id, username: $username, taskname: $taskname, datecreate: $datecreate, hasDone: $hasDone}';
  }

  Map<String, dynamic> toMap() {
    return {"username": username, "taskname": taskname, "hasDone": hasDone,"datecreate":datecreate};
  }

  Todo.fromMap(Map<String, dynamic> map) {
    username = map["username"];
    taskname: map["taskname"];
    datecreate: map["datecreate"];
    hasDone: map["hasDone"];
  }
}
