import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/model/todo.dart';


class TodosProvider extends ChangeNotifier {
  static const _todosKey = 'todos'; // Key for storing todos in SharedPreferences

  List<Todo> _todos = [];

  TodosProvider() {
    _loadTodos(); // Load todos when the provider is created
  }

  List<Todo> get todos => _todos.where((todo) => !todo.isDone).toList();
  List<Todo> get todosCompleted => _todos.where((todo) => todo.isDone).toList();

  // Create a new todo and save it
  Future<void> createTodo(Todo todo) async {
    _todos.add(todo);
    _saveTodos(); // Save todos after adding
    notifyListeners();
  }

  // void addTodo(Todo todo) {
  //   _todos.add(todo);
  //   _saveTodos(); // Save todos after adding
  //   notifyListeners();
  // }

  void removeTodo(Todo todo) {
    _todos.remove(todo);
    _saveTodos(); // Save todos after removing
    notifyListeners();
  }

  bool toggleTodoStatus(Todo todo) {
    todo.isDone = !todo.isDone;
    _saveTodos(); // Save todos after toggling
    notifyListeners();
    return todo.isDone;
  }
  // Load todos from SharedPreferences
  Future<void> _loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosData = prefs.getStringList(_todosKey);

    if (todosData != null) {
      _todos = todosData.map((jsonString) {
        final json = jsonDecode(jsonString);
        return Todo.fromJson(json);
      }).toList();
      notifyListeners();
    }
  }

  // Save todos to SharedPreferences
  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosData = _todos.map((todo) => todo.toJson()).toList();
    await prefs.setStringList(_todosKey, todosData.map((json) => jsonEncode(json)).toList());
  }
  // Update an existing todo
  void updateTodo(Todo todo) {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      _saveTodos(); // Save todos after updating
      notifyListeners();
    }
  }

  // Delete a todo
  Future<void> deleteTodo(String todoId) async {
    _todos.removeWhere((t) => t.id == todoId);
    _saveTodos(); // Save todos after removing
    notifyListeners();
  }
}
