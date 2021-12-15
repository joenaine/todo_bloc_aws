import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qazapp/todo_repository.dart';

import 'models/Todo.dart';

abstract class TodoState {}

class LoadingTodos extends TodoState {}

class ListTodosSuccess extends TodoState {
  final List<Todo> todos;

  ListTodosSuccess({this.todos});
}

class ListTodosFailure extends TodoState {
  final Exception exception;

  ListTodosFailure({this.exception});
}

class TodoCubit extends Cubit<TodoState> {
  final _todoRepo = TodoRepository();
  final String userId;

  TodoCubit({this.userId}) : super(LoadingTodos());

  void getTodos() async {
    if (state is ListTodosSuccess == false) {
      emit(LoadingTodos());
    }
    try {
      final todos = await _todoRepo.getTodos(userId);
      emit(ListTodosSuccess(todos: todos));
    } catch (e) {
      print(e);
    }
  }

  void observeTodo() {
    final todosStream = _todoRepo.observeTodos();
    todosStream.listen((_) => getTodos());
  }

  void createTodo(String title) async {
    await _todoRepo.createTodo(title, userId);
  }

  void updateTodoIsComplete(Todo todo, bool isComplete) async {
    await _todoRepo.updateTodoIsComplete(todo, isComplete);
  }
}