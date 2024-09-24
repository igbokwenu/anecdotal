import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/views/deleted_tasks_view.dart';
import 'package:anecdotal/views/view_widgets.dart/tasks_widget.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ToDoScreen extends ConsumerWidget {
  const ToDoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;
    final themeStyle = Theme.of(context)
        .textTheme
        .titleMedium!
        .copyWith(fontSize: 17, fontWeight: FontWeight.bold);

    if (userData == null) {
      return const MySpinKitWaveSpinner();
    }

    return Scaffold(
      appBar: AppBar(
        title: const MyAppBarTitleWithAI(title: "Healing Tasks"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DeletedTasksScreen(uid: uid!)),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              mySpacing(),
              const Text(
                'Your tasks in progress and completed tasks are automatically added whenever you log your progress. This is to enable you to track what works best for you over time.',
                textAlign: TextAlign.center,
              ),
              Text('To-Do', style: themeStyle),
              TaskListWidget(
                tasks: userData.toDoList,
                listName: 'toDo',
                onMoveTask: (task, toList) =>
                    moveTask(context, uid!, task, 'toDo', toList),
                onDeleteTask: (task) => deleteTask(context, uid!, task, 'toDo'),
              ),
              const Divider(),
              Text('In Progress', style: themeStyle),
              TaskListWidget(
                tasks: userData.inProgressList,
                listName: 'inProgress',
                onMoveTask: (task, toList) =>
                    moveTask(context, uid!, task, 'inProgress', toList),
                onDeleteTask: (task) =>
                    deleteTask(context, uid!, task, 'inProgress'),
              ),
              const Divider(),
              Text('Completed', style: themeStyle),
              TaskListWidget(
                tasks: userData.doneList,
                listName: 'done',
                onMoveTask: (task, toList) =>
                    moveTask(context, uid!, task, 'done', toList),
                onDeleteTask: (task) => deleteTask(context, uid!, task, 'done'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open dialog to add new task to a selected list
          _addTaskDialog(context, uid!);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addTaskDialog(BuildContext context, String uid) {
    showDialog(
      context: context,
      builder: (context) {
        String newTask = '';
        String selectedList = 'toDo';

        return AlertDialog(
          title: const Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => newTask = value,
                decoration: const InputDecoration(labelText: 'Task Name'),
              ),
              DropdownButton<String>(
                value: selectedList,
                items: ['toDo', 'inProgress', 'done'].map((list) {
                  return DropdownMenuItem<String>(
                    value: list,
                    child: Text(list),
                  );
                }).toList(),
                onChanged: (value) => selectedList = value ?? 'toDo',
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                FirebaseFirestore.instance.collection('users').doc(uid).update({
                  selectedList: FieldValue.arrayUnion([newTask]),
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
