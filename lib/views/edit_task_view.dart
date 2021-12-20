import 'package:flutter/material.dart';

import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';

class EditTaskView extends StatefulWidget {
  final Todo todo;
  const EditTaskView({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<EditTaskView> createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskView> {
  late TextEditingController newTaskController;

  @override
  void initState() {
    newTaskController = TextEditingController(text: widget.todo.task);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var todoController = TodoController.instance;

    return SafeArea(
      child: AnimatedBuilder(
        animation: todoController,
        builder: (BuildContext context, Widget? child) {
          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            appBar: AppBar(
              title: const Text(
                'Edit task',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(
                color: Colors.black,
              ),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: newTaskController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (newTaskController.text.trim().isNotEmpty) {
                      widget.todo.task = newTaskController.text.trim();
                      todoController.update(widget.todo);
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(Icons.save),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
