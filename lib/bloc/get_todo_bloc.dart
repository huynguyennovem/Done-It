
import 'package:bloc/bloc.dart';
import 'package:todoapp/entity/todo.dart';
import 'package:todoapp/event/todo_event.dart';
import 'package:todoapp/state/get_todo_state.dart';

class GetTodoBloc extends Bloc<TodoEvent, GetTodoState> {

  @override
  GetTodoState get initialState => GetTodoUnInitial();

  @override
  Stream<GetTodoState> mapEventToState(TodoEvent event) async*{
    // to notify that is loading
    yield GetTodoLoading();
    // if you have multiple event
    if(event is GetTodoEvent){
      yield GetTodoSuccess(listUsers());
    }
    // if have error you can yield GetUsersError state
  }

  List<Todo> listUsers() {
    List<Todo> todos = List();
    todos.add(Todo("huynq", "fixbug 1", "2020-06-01", false));
    todos.add(Todo("huynq", "fixbug 2", "2020-06-01", false));
    todos.add(Todo("huynq", "fixbug 3", "2020-06-01", false));
    todos.add(Todo("huynq", "fixbug 4", "2020-06-01", false));
    todos.add(Todo("huynq", "fixbug 5", "2020-06-01", false));
    todos.add(Todo("huynq", "fixbug 6", "2020-06-01", false));
    return todos;
  }

}