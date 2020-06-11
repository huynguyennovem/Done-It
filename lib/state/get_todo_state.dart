
import 'package:todoapp/entity/todo.dart';

class GetTodoState {}

class GetTodoUnInitial extends GetTodoState {}

class GetTodoLoading extends GetTodoState {}

class GetTodoSuccess extends GetTodoState {
  List<Todo> todos;

  GetTodoSuccess(this.todos) : assert(todos != null);
}

class GetTodoError extends GetTodoState {}