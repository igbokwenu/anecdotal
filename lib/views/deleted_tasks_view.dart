import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/database_service.dart';
import 'package:anecdotal/utils/constants/constants.dart';
import 'package:anecdotal/views/view_widgets.dart/tasks_widget.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeletedTasksScreen extends ConsumerWidget {
  final String uid;

  const DeletedTasksScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;
    final databaseService = DatabaseService(uid: uid);

    if (userData == null) {
      return const MySpinKitWaveSpinner();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Deleted Tasks'), actions: [
        TextButton.icon(
          icon: const Icon(
            Icons.delete_forever,
            color: Colors.red,
          ),
          onPressed: () {
            databaseService.updateAnyUserData(
              fieldName: userDeletedTasksList,
              newValue: [],
            );
          },
          label: Text(
            'Empty',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ]),
      body: ListView(
        children: userData.deletedTasks.map((task) {
          return ListTile(
            title: Text(task),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.restore),
                  onPressed: () => restoreTask(uid, task),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () => permanentlyDeleteTask(uid, task),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
