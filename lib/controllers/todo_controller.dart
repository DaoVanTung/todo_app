import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/todo_model.dart';

class TodoController with ChangeNotifier {
  TodoController._() {
    loadTodos();
  }

  static final TodoController _instance = TodoController._();
  static TodoController get instance => _instance;

  Map<String, Todo> todoList = {};

  void loadTodos() async {
    Uri url = Uri.parse('http://localhost:8000/api/todos');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      todoList = {};
      var body = json.decode(response.body);

      body.forEach((e) {
        final todo = Todo(
          id: e['_id'],
          task: e['task'],
        );
        todoList.putIfAbsent(todo.id, () => todo);
      });
    } else {
      // ignore: avoid_print
      print('Request failed with status: ${response.statusCode}.');
    }
    notifyListeners();
  }

  Future<Todo?> loadById({required String id}) async {
    Uri url = Uri.parse('http://localhost:8000/api/todo/$id');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      final todo = Todo(
        id: body['_id'],
        task: body['task'],
      );
      return todo;
    } else {
      // ignore: avoid_print
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void create({required String task}) async {
    Uri url = Uri.parse('http://localhost:8000/api/todo/create');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'task': task}),
    );
    if (response.statusCode == 200) {
      var body = json.decode(response.body);

      final todo = Todo(
        id: body['task']['_id'],
        task: body['task']['task'],
      );

      todoList.putIfAbsent(todo.id, () => todo);
    } else {
      // ignore: avoid_print
      print('Request failed with status: ${response.statusCode}.');
    }
    notifyListeners();
  }

  void update(Todo todo) async {
    Uri url = Uri.parse('http://localhost:8000/api/todo/${todo.id}/update');
    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"task": todo.task}),
    );
    if (response.statusCode == 200) {
      todoList.update(todo.id, (value) => todo);
    } else {
      // ignore: avoid_print
      print('Request failed with status: ${response.statusCode}.');
    }
    notifyListeners();
  }

  void delete({required String id}) async {
    Uri url = Uri.parse('http://localhost:8000/api/todo/$id/delete');
    var response = await http.delete(url);
    if (response.statusCode == 200) {
      todoList.remove(id);
    } else {
      // ignore: avoid_print
      print('Request failed with status: ${response.statusCode}.');
    }
    notifyListeners();
  }
}
