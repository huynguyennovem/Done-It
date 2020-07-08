import 'package:bloc/bloc.dart';
import 'package:todoapp/db/tododao.dart';
import 'package:todoapp/entity/todo.dart';
import 'package:todoapp/bloc/event/todo_event.dart';
import 'package:todoapp/bloc/state/todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoStates> {
  final TodoDao _todoDao;
  int tdlCount = 0;

  TodoBloc(this._todoDao);

  @override
  TodoStates get initialState => LoadingTodoState();

  @override
  Stream<TodoStates> mapEventToState(TodoEvent event) async* {
    if (event is AddTodoEvent) {
      Todo todo = Todo(event.username, event.taskname, event.datecreate, event.hasDone);
      await _todoDao.insert(todo);

      add(QueryTodoEvent());
    } else if (event is UpdateTodoEvent) {
      await _todoDao.update(event.todo);
      //await Future.delayed(Duration(seconds: 1));

      add(QueryTodoEvent());
    } else if (event is DeleteTodoEvent) {
      await _todoDao.delete(event.id);

      add(QueryTodoEvent());
    } else if (event is QueryTodoEvent) {
      yield LoadingTodoState();
      //await Future.delayed(Duration(seconds: 1));

      final tdl = await _todoDao.getAllSortedByTimeStamp();
      //print("List to do size: " + tdl.length.toString());
      if (tdl != null && tdl.length == 0) {
        yield EmptyTodoState();
      } else {
        yield LoadedTodoState(tdl);
      }
    }
  }
}
