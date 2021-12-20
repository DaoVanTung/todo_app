import 'package:flutter/material.dart';

import 'edit_task_view.dart';
import '../models/todo_model.dart';
import '../controllers/todo_controller.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final newTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var todoController = TodoController.instance;
    Widget todoCard(Todo todo) {
      return Card(
        child: ListTile(
          leading: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.task),
          ),
          contentPadding: EdgeInsets.zero,
          minLeadingWidth: 0,
          title: Text(todo.task),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditTaskView(todo: todo),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                splashRadius: 22,
              ),
              IconButton(
                onPressed: () {
                  todoController.delete(id: todo.id);
                },
                icon: const Icon(Icons.delete),
                splashRadius: 22,
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: AnimatedBuilder(
        animation: todoController,
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            appBar: AppBar(
              title: const Text(
                'TODO',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                  onPressed: () {
                    todoController.loadTodos();
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.black,
                  ),
                  splashRadius: 22,
                )
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: todoController.todoList.length,
                    itemBuilder: (context, index) {
                      final todo =
                          todoController.todoList.values.elementAt(index);
                      return todoCard(todo);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: newTaskController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 8,
                            ),
                            hintText: 'New task',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (newTaskController.text.trim().isNotEmpty) {
                            todoController.create(
                              task: newTaskController.text.trim(),
                            );

                            newTaskController.text = '';
                            FocusScope.of(context).unfocus();
                          }
                        },
                        icon: const Icon(Icons.add),
                        splashRadius: 22,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
