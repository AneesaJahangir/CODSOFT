import 'package:flutter/cupertino.dart';
import 'package:todo_app/utils.dart';

class TodoField {
  static const createdTime = 'createdTime';
}

class Todo {
  final String id;
  late final String title;
  late final String description;
  final DateTime createdTime;
  bool isDone;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.createdTime,
    this.isDone = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    isDone: json['isDone'] as bool,
    createdTime: DateTime.parse(json['createdAt'] as String),
  );

  // Add a method to convert the Todo object to a JSON map
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'isDone': isDone,
    'createdAt': createdTime.toIso8601String(), // Convert DateTime to ISO 8601 string
  };
}
