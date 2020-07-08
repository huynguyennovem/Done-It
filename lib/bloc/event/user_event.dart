import 'package:equatable/equatable.dart';
import 'package:todoapp/entity/todo.dart';
import 'package:todoapp/entity/user.dart';

abstract class UserEvent extends Equatable {
  UserEvent([List props = const []]) : super(props);
}

// Get by email
class GetUserEvent extends UserEvent {
  String email;

  GetUserEvent(this.email) : super([email]);
}

// Add new entity
class AddUserEvent extends UserEvent {
  User user;

  AddUserEvent({this.user});
}

// Delete by ID
class DeleteUserEvent extends UserEvent {
  String email;

  DeleteUserEvent(this.email) : super([email]);
}
