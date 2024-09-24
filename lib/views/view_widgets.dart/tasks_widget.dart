import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskListWidget extends StatelessWidget {
  final List<String> tasks;
  final String listName;
  final Function(String, String) onMoveTask;
  final Function(String) onDeleteTask;

  TaskListWidget(
      {required this.tasks,
      required this.listName,
      required this.onMoveTask,
      required this.onDeleteTask});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: tasks.map((task) {
        return ListTile(
          title: Text(
            task,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  size: 15,
                  color: Colors.red,
                ),
                onPressed: () => onDeleteTask(task),
              ),
              if (listName != 'done')
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () => onMoveTask(task, 'done'),
                ),
              if (listName != 'inProgress')
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () => onMoveTask(task, 'inProgress'),
                ),
              if (listName != 'toDo')
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => onMoveTask(task, 'toDo'),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

Future<void> moveTask(BuildContext context, String uid, String task,
    String fromList, String toList) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
  final userSnapshot = await userDoc.get();

  // Remove task from the fromList
  List<dynamic> fromTasks = userSnapshot.data()?[fromList];
  fromTasks.remove(task);

  // Add task to the toList
  List<dynamic> toTasks = userSnapshot.data()?[toList];
  toTasks.add(task);

  // Update Firestore
  await userDoc.update({
    fromList: fromTasks,
    toList: toTasks,
  });

  // Show Snackbar to indicate task movement
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Moved to $toList')),
  );
}

Future<void> deleteTask(
    BuildContext context, String uid, String task, String fromList) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
  final userSnapshot = await userDoc.get();

  // Remove task from the original list
  List<dynamic> fromTasks = userSnapshot.data()?[fromList];
  fromTasks.remove(task);

  // Add task to deletedTasks
  List<dynamic> deletedTasks = userSnapshot.data()?['deletedTasks'] ?? [];
  deletedTasks.add(task);

  // Update Firestore
  await userDoc.update({
    fromList: fromTasks,
    'deletedTasks': deletedTasks,
  });

  // Show Snackbar to indicate deletion
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Task deleted')),
  );
}

Future<void> restoreTask(String uid, String task) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
  final userSnapshot = await userDoc.get();

  // Remove task from deletedTasks
  List<dynamic> deletedTasks = userSnapshot.data()?['deletedTasks'];
  deletedTasks.remove(task);

  // Add task to toDo
  List<dynamic> toDoTasks = userSnapshot.data()?['toDo'] ?? [];
  toDoTasks.add(task);

  // Update Firestore
  await userDoc.update({
    'deletedTasks': deletedTasks,
    'toDo': toDoTasks,
  });
}

Future<void> permanentlyDeleteTask(String uid, String task) async {
  final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
  final userSnapshot = await userDoc.get();

  // Remove task from deletedTasks
  List<dynamic> deletedTasks = userSnapshot.data()?['deletedTasks'];
  deletedTasks.remove(task);

  // Update Firestore
  await userDoc.update({
    'deletedTasks': deletedTasks,
  });
}
