import 'package:equatable/equatable.dart';
import 'package:todoapp/entity/todo.dart';
import 'package:todoapp/entity/user.dart';

abstract class UserStates extends Equatable {
  UserStates([List props = const []]) : super(props);
}

class LoadingUserState extends UserStates {}

class EmptyUserState extends UserStates {}

class LoadedUserState extends UserStates {
  User user;

  LoadedUserState(this.user) : super([user]);
}
