

class TodoEvent{}

class GetTodoEvent extends TodoEvent{
  String id;
  GetTodoEvent({this.id});
}