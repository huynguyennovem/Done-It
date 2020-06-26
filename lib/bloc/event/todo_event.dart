import 'package:equatable/equatable.dart';
import 'package:todoapp/entity/todo.dart';

abstract class TodoEvent extends Equatable {
  TodoEvent([List props = const []]) : super(props);
}

// Get all
class QueryTodoEvent extends TodoEvent {}

// Get by ID
class GetTodoEvent extends TodoEvent {
  int id;
  GetTodoEvent(this.id) : super([id]);
}

// Add new entity
class AddTodoEvent extends TodoEvent {
  final String username, taskname, datecreate;
  final bool hasDone;
  AddTodoEvent({this.username, this.taskname, this.datecreate, this.hasDone});
}

// Update new entity
class UpdateTodoEvent extends TodoEvent {
  final Todo todo;
  UpdateTodoEvent(this.todo) : super([todo]);
}

// Delete by ID
class DeleteTodoEvent extends TodoEvent {
  int id;
  DeleteTodoEvent(this.id) : super([id]);
}
