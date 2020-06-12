

class TodoEvent{}

class GetTodoEvent extends TodoEvent{
  String id;
  GetTodoEvent({this.id});
}

class AddTodoEvent extends TodoEvent {
  String username, taskname, datecreate;
  bool hasDone;
  AddTodoEvent({this.username, this.taskname, this.datecreate, this.hasDone});
}