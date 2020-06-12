
import 'package:todoapp/entity/todo.dart';

class AddTodoState {}

class AddTodoUnInitial extends AddTodoState {}

class AddTodoLoading extends AddTodoState {}

class AddTodoSuccess extends AddTodoState {
  Todo todo;
  AddTodoSuccess(this.todo) : assert(todo != null);
}

class AddTodoError extends AddTodoState {}