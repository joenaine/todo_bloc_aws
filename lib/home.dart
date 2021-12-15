import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qazapp/auth_cubit.dart';
import 'package:qazapp/loading_view.dart';
import 'package:qazapp/todo_cubit.dart';

import 'models/Todo.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _titleController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _navBar(),
      floatingActionButton: _floatingActionButton(),
      body: BlocBuilder<TodoCubit, TodoState>(builder: (context, state) {
        if (state is ListTodosSuccess) {
          return state.todos.isEmpty
              ? _emptyTodosView()
              : _todoListView(state.todos);
        } else if (state is ListTodosFailure) {
          return _exceptionView(state.exception);
        } else {
          return LoadingView();
        }
      }),
    );
  }

  Widget _newTodoView() {
    return Column(
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(hintText: "Enter Todo Title"),
        ),
        ElevatedButton(
            onPressed: () {
              BlocProvider.of<TodoCubit>(context)
                  .createTodo(_titleController.text);
              _titleController.text = '';
              Navigator.of(context).pop();
            },
            child: Text("Save Todo"))
      ],
    );
  }

  Widget _floatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => _newTodoView(),
        );
      },
    );
  }

  Widget _exceptionView(Exception exception) {
    return Center(
      child: Text(exception.toString()),
    );
  }

  AppBar _navBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () => BlocProvider.of<AuthCubit>(context).signOut(),
        icon: Icon(Icons.logout),
      ),
      title: Text('Todos'),
      centerTitle: true,
    );
  }

  Widget _emptyTodosView() {
    return Center(
      child: Text("No Todos yet"),
    );
  }

  Widget _todoListView(List<Todo> todos) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          child: CheckboxListTile(
            title: Text(todo.title),
            value: todo.isComplete,
            onChanged: (newValue) {
              BlocProvider.of<TodoCubit>(context)
                  .updateTodoIsComplete(todo, newValue);
            },
          ),
        );
      },
    );
  }
}
