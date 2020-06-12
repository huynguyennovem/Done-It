
import 'package:bloc/bloc.dart';
import 'package:todoapp/entity/todo.dart';
import 'package:todoapp/event/todo_event.dart';
import 'package:todoapp/state/add_todo_state.dart';

class AddTodoBloc extends Bloc<TodoEvent, AddTodoState> {

  @override
  AddTodoState get initialState => AddTodoUnInitial();

  @override
  Stream<AddTodoState> mapEventToState(TodoEvent event) async*{
    // to notify that is loading
    yield AddTodoLoading();
    // if you have multiple event
    if(event is GetTodoEvent){
      yield AddTodoSuccess(_addTodo());
    }
    // if have error you can yield GetUsersError state
  }

  Todo _addTodo() {
    return Todo("huynq@gmail.com", "Fixbug", "2020-06-10", false);
  }

}