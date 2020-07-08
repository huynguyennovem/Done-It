import 'package:bloc/bloc.dart';
import 'package:todoapp/bloc/event/user_event.dart';
import 'package:todoapp/bloc/state/user_state.dart';
import 'package:todoapp/db/userdao.dart';
import 'package:todoapp/entity/user.dart';

class UserBloc extends Bloc<UserEvent, UserStates> {
  final UserDao _userDao;

  UserBloc(this._userDao);

  @override
  UserStates get initialState => LoadingUserState();

  @override
  Stream<UserStates> mapEventToState(UserEvent event) async* {
    if (event is AddUserEvent) {
      User user = event.user;
      await _userDao.insert(user);
    } else if (event is DeleteUserEvent) {
      await _userDao.delete(event.email);
    }
  }
}
