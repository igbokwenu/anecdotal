import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TaskListWidget extends StatefulWidget {
  final List<String> tasks;
  final String listName;
  final Function(String, String) onMoveTask;
  final Function(String) onDeleteTask;
  final Function(String, String) onEditTask;
  final bool isDefaultUI;

  const TaskListWidget({
    super.key,
    required this.tasks,
    required this.listName,
    required this.onMoveTask,
    required this.onDeleteTask,
    required this.onEditTask,
    this.isDefaultUI = true,
  });

  @override
  _TaskListWidgetState createState() => _TaskListWidgetState();
}

class _TaskListWidgetState extends State<TaskListWidget> {
  // bool isDefaultUI = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.tasks.map((task) {
        return ListTile(
          title: Text(
            task,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          trailing: widget.isDefaultUI
              ? _menuButton(context, task)
              : _defaultButtons(task),
        );
      }).toList(),
    );
  }

  // Default icon buttons
  Row _defaultButtons(String task) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _editTaskDialog(task),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => widget.onDeleteTask(task),
        ),
        if (widget.listName != 'done')
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => widget.onMoveTask(task, 'done'),
          ),
        if (widget.listName != 'inProgress')
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () => widget.onMoveTask(task, 'inProgress'),
          ),
        if (widget.listName != 'toDo')
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => widget.onMoveTask(task, 'toDo'),
          ),
      ],
    );
  }

  // Popup menu button for new UI
  Widget _menuButton(BuildContext context, String task) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'done':
            widget.onMoveTask(task, 'done');
            break;
          case 'inProgress':
            widget.onMoveTask(task, 'inProgress');
            break;
          case 'toDo':
            widget.onMoveTask(task, 'toDo');
            break;
          case 'edit':
            _editTaskDialog(task);
            break;
          case 'delete':
            widget.onDeleteTask(task);
            break;
        }
      },
      itemBuilder: (context) => [
        if (widget.listName != 'done')
          const PopupMenuItem(
            value: 'done',
            child: Text('Move to Done'),
          ),
        if (widget.listName != 'inProgress')
          const PopupMenuItem(
            value: 'inProgress',
            child: Text('Move to In Progress'),
          ),
        if (widget.listName != 'toDo')
          const PopupMenuItem(
            value: 'toDo',
            child: Text('Move to To-Do'),
          ),
        const PopupMenuItem(
          value: 'edit',
          child: Text('Edit Task'),
        ),
        const PopupMenuItem(
          value: 'delete',
          child: Text('Delete Task'),
        ),
      ],
      icon: const Icon(Icons.more_vert),
    );
  }

  // Edit task dialog
  void _editTaskDialog(String task) {
    String newTaskName = task;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: TextField(
            onChanged: (value) => newTaskName = value,
            controller: TextEditingController(text: task),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                widget.onEditTask(task, newTaskName);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

Future<void> moveTask(BuildContext context, String uid, String task,
    String fromList, String toList, bool isCompact) async {
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

if(isCompact) {  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Moved to $toList')),
  );}

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

Future<void> editTask(
  BuildContext context,
  String uid,
  String oldTask,
  String newTask,
  String listName,
) async {
  try {
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final userDocSnapshot = await userDocRef.get();

    if (!userDocSnapshot.exists) return;

    final userData = userDocSnapshot.data() as Map<String, dynamic>;

    List<dynamic> taskList = userData[listName] ?? [];

    // Find and update the task in the list
    final taskIndex = taskList.indexOf(oldTask);
    if (taskIndex != -1) {
      taskList[taskIndex] = newTask;
    }

    // Update Firestore with the edited task list
    await userDocRef.update({listName: taskList});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Task updated successfully')),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating task: $e')),
    );
  }
}

void addTaskDialog(BuildContext context, String uid) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      String newTask = '';
      String selectedList = 'toDo';

      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text('Add New Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      newTask = value.trim();
                    });
                  },
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
                  onChanged: (value) {
                    setState(() {
                      selectedList = value ?? 'toDo';
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                onPressed: newTask.isEmpty
                    ? null // Disable the button if newTask is empty
                    : () {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .update({
                          selectedList: FieldValue.arrayUnion([newTask]),
                        });
                        Navigator.pop(context);
                      },
                child: const Text('Add'),
              ),
            ],
          );
        },
      );
    },
  );
}
