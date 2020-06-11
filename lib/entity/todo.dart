


class Todo {

  int id;
  String username, taskname, datecreate;
  bool hasDone;

  Todo(this.username, this.taskname, this.datecreate, this.hasDone);

  @override
  String toString() {
    return 'Todo{id: $id, username: $username, taskname: $taskname, datecreate: $datecreate, hasDone: $hasDone}';
  }

}
