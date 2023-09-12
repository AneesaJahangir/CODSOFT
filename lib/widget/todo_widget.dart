import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/page/edit_todo_page.dart';
import 'package:todo_app/provider/todos.dart';
import 'package:todo_app/utils.dart';

class TodoWidget extends StatelessWidget {
  final Todo todo;

  const TodoWidget({
    required this.todo,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Color(0xFFF3E5F5),
      border: Border.all(
        color: Colors.purple,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(16),
    ),
    padding: EdgeInsets.all(20),
    child: Row(
      children: [
        Checkbox(
          activeColor: Theme.of(context).primaryColor,
          checkColor: Colors.white,
          value: todo.isDone,
          onChanged: (_) async {
            final provider =
            Provider.of<TodosProvider>(context, listen: false);
            final isDone = provider.toggleTodoStatus(todo);

            Utils.showSnackBar(
              context,
              isDone ? 'Task completed' : 'Task marked incomplete',
            );

            // Save the updated task status to shared preferences
            await saveTaskStatusLocally(todo);
          },
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                todo.title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              if (todo.description.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: 4),
                  child: Text(
                    todo.description,
                    style: TextStyle(fontSize: 17, height: 1.5),
                  ),
                ),
            ],
          ),
        ),
        Column(
          children: [
            IconButton(
              onPressed: () => editTodo(context, todo),
              icon: Icon(Icons.edit, color: Colors.green),
            ),
            IconButton(
              onPressed: () => deleteTodo(context, todo),
              icon: Icon(Icons.delete, color: Colors.red),
            ),
          ],
        )
      ],
    ),
  );

  void deleteTodo(BuildContext context, Todo todo) async {
    final provider = Provider.of<TodosProvider>(context, listen: false);
    provider.removeTodo(todo);

    Utils.showSnackBar(context, 'Deleted the task');

    // Remove the task from shared preferences
    await removeTaskLocally(todo);
  }


  void editTodo(BuildContext context, Todo todo) => Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => EditTodoPage(todo: todo),
    ),
  );

  Future<void> saveTaskStatusLocally(Todo todo) async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = prefs.getStringList('tasks') ?? [];

    final index = taskList.indexWhere((taskJson) {
      final task = Todo.fromJson(jsonDecode(taskJson));
      return task.id == todo.id;
    });

    if (index != -1) {
      taskList[index] = todo.toJson() as String;
      await prefs.setStringList('tasks', taskList);
    }
  }

  Future<void> removeTaskLocally(Todo todo) async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = prefs.getStringList('tasks') ?? [];

    taskList.removeWhere((taskJson) {
      final task = Todo.fromJson(jsonDecode(taskJson));
      return task.id == todo.id;
    });

    await prefs.setStringList('tasks', taskList);
  }
}
