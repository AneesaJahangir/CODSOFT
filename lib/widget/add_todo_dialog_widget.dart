import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/model/todo.dart';
import 'package:todo_app/provider/todos.dart';
import 'package:todo_app/widget/todo_form_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTodoDialogWidget extends StatefulWidget {
  @override
  _AddTodoDialogWidgetState createState() => _AddTodoDialogWidgetState();
}

class _AddTodoDialogWidgetState extends State<AddTodoDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';

  @override
  Widget build(BuildContext context) => AlertDialog(
    content: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Add Todo',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(height: 8),
          TodoFormWidget(
            title: title,
            description: description,
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
            onSavedTodo: addTodo,
          ),
        ],
      ),
    ),
  );
  void addTodo() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    } else {
      final todo = Todo(
        id: DateTime.now().toString(),
        title: title,
        description: description,
        createdTime: DateTime.now(),
      );

      final provider = Provider.of<TodosProvider>(context, listen: false);
      provider.createTodo(todo);

      Navigator.of(context).pop();
    }
  }

}

  // void addTodo() async {
  //   try {
  //   final isValid = _formKey.currentState!.validate();
  //
  //   if (!isValid) {
  //     return;
  //   } else {
  //     final todo = Todo(
  //       id: DateTime.now().toString(),
  //       title: title,
  //       description: description,
  //       createdTime: DateTime.now(),
  //     );
  //
  //     final provider = Provider.of<TodosProvider>(context, listen: false);
  //     provider.addTodo(todo);
  //
  //     // Save the new task locally
  //     print('Before saving task locally');
  //     await saveTaskLocally(todo);
  //     print('After saving task locally');
  //
  //     // Show a success dialog
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Task Added'),
  //           content: Text('Your task has been successfully added.'),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //                 Navigator.of(context).pop(); // Close the AddTodoDialogWidget
  //               },
  //               child: Text('OK'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // } catch (e) {
  // print('Error: $e');
  // }
  // }
  //
  // Future<void> saveTaskLocally(Todo todo) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final taskList = prefs.getStringList('tasks') ?? [];
  //
  //   // Convert the Todo object to a JSON string
  //   final todoJson = jsonEncode(todo.toJson()); // Assuming you have a toJson method in your Todo class
  //
  //   // Add the JSON string to the taskList
  //   taskList.add(todoJson);
  //
  //   await prefs.setStringList('tasks', taskList);
  // }

