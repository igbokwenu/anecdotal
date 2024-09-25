import 'package:anecdotal/providers/user_data_provider.dart';
import 'package:anecdotal/services/database_service.dart';
import 'package:anecdotal/views/visualise_progress_view.dart';
import 'package:anecdotal/widgets/reusable_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class ProgressTracker extends ConsumerStatefulWidget {
  const ProgressTracker({super.key});

  @override
  ProgressTrackerAppState createState() => ProgressTrackerAppState();
}

class ProgressTrackerAppState extends ConsumerState<ProgressTracker> {
  double _currentPercentage = 0;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializePercentage();
    });
  }

  void _initializePercentage() {
    final userData = ref
        .read(anecdotalUserDataProvider(FirebaseAuth.instance.currentUser?.uid))
        .value;
    if (userData != null && userData.healingJourneyMap.isNotEmpty) {
      setState(() {
        _currentPercentage =
            userData.healingJourneyMap.last['percentage'].toDouble();
      });
    }
  }

  void _showEntryDetails(HealingJourneyEntry entry) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Journey Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(entry.timestamp)}'),
                Text('Feeling ${entry.percentage.toStringAsFixed(1)}% better'),
                const SizedBox(height: 10),
                const Text('Tasks In Progress:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...entry.inProgressList.map((item) => Text('• $item')),
                const SizedBox(height: 10),
                const Text('Completed Tasks:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...entry.doneList.map((item) => Text('• $item')),
                const SizedBox(height: 10),
                const Text('Notes:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(entry.notes),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showProgressRecordedPopup(HealingJourneyEntry entry) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Progress Recorded'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(entry.timestamp)}'),
                Text('Feeling ${entry.percentage.toStringAsFixed(1)}% better'),
                const SizedBox(height: 10),
                const Text('Tasks In Progress:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...entry.inProgressList.map((item) => Text('• $item')),
                const SizedBox(height: 10),
                const Text('Completed Tasks:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...entry.doneList.map((item) => Text('• $item')),
                const SizedBox(height: 10),
                const Text('Notes:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(entry.notes),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('View Progress Timeline'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const VisualizeProgress(),
                ));
              },
            ),
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> recordProgress(String progressMessage) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final dbService = DatabaseService(uid: uid!);
    final userData = ref.read(anecdotalUserDataProvider(uid)).value;

    if (userData != null && userData.healingJourneyMap.isNotEmpty) {
      final lastPercentage =
          userData.healingJourneyMap.last['percentage'].toDouble();
      if (_currentPercentage == lastPercentage) {
        final proceed = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'No Mood Change Detected 😐',
                textAlign: TextAlign.center,
              ),
              content: Text(
                "$progressMessage If your current feelings have shifted, please adjust the slider at the top of the page. \n\nWould you like to continue without updating how you feel about your progress?",
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );
        if (proceed != true) return;
      }
    }

    final newEntry = HealingJourneyEntry(
      timestamp: DateTime.now(),
      percentage: _currentPercentage,
      inProgressList: userData!.inProgressList,
      doneList: userData.doneList,
      notes: _notesController.text,
    );

    // Add the new entry to Firestore
    await dbService.addToHealingJourneyMap({
      'timestamp': newEntry.timestamp.millisecondsSinceEpoch,
      'percentage': newEntry.percentage,
      'inProgressList': newEntry.inProgressList,
      'doneList': newEntry.doneList,
      'notes': newEntry.notes,
    });

    // Clear the notes field
    _notesController.clear();

    // Show the progress recorded popup
    _showProgressRecordedPopup(newEntry);
  }

  String getDynamicProgressMessage(
      List<Map<String, dynamic>> healingJourneyMap) {
    if (healingJourneyMap.isEmpty) {
      return "You haven't recorded any progress yet.";
    }

    final lastEntry = healingJourneyMap.last;
    final lastPercentage = lastEntry['percentage'].toDouble();

    if (healingJourneyMap.length == 1) {
      return "You previously indicated feeling ${lastPercentage.round()}% better.";
    }

    final secondLastEntry = healingJourneyMap[healingJourneyMap.length - 2];
    final secondLastPercentage = secondLastEntry['percentage'].toDouble();

    final difference = lastPercentage - secondLastPercentage;
    final lastEntryDate = DateFormat('MMM d, yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(lastEntry['timestamp']));

    if (difference > 0) {
      return "Looks like how you're feeling improved 🙂 \n\nOn $lastEntryDate, you reported feeling ${lastPercentage.round()}% better, which is ${difference.abs().round()} percent higher than your previous entry.";
    } else if (difference < 0) {
      return "You seem to be experiencing some challenges with your wellbeing. \n\nOn $lastEntryDate, you reported feeling ${lastPercentage.round()}% better, which is ${difference.abs().round()} percent lower than your previous entry.";
    } else {
      return "Your feeling seems steady. \n\nOn $lastEntryDate, you reported feeling ${lastPercentage.round()}% better, which is the same as your previous entry.";
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userData = ref.watch(anecdotalUserDataProvider(uid)).value;
    final progressMessage =
        getDynamicProgressMessage(userData?.healingJourneyMap ?? []);

    return Scaffold(
      appBar: AppBar(
        title: const MyAppBarTitleWithAI(
          title: 'Track Your Healing',
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Use the slider below to tell us how you are feeling about your wellness journey. 0% means your symptoms are debilitating and 100% means you are symptom free.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _currentPercentage,
                        min: 0,
                        max: 100,
                        divisions: 100,
                        label: '${_currentPercentage.round()}%',
                        onChanged: (value) {
                          setState(() {
                            _currentPercentage = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: Text(
                        '${_currentPercentage.round()}%',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Text('Notes (Optional):', style: TextStyle(fontSize: 16)),
                TextField(
                  controller: _notesController,
                  maxLength: 500,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText:
                        'Enter any notable details about your health journey.',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      label: const Text('Record Progress'),
                      onPressed: () async {
                        await recordProgress(progressMessage);
                      },
                      icon: const Icon(Icons.check),
                    ),
                    ElevatedButton.icon(
                      label: const Text('View Progress'),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const VisualizeProgress(),
                        ));
                      },
                      icon: const Icon(Icons.timeline),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (userData != null && userData.healingJourneyMap.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Progress:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      ...userData.healingJourneyMap.reversed
                          .take(10)
                          .map((entry) => TimelineTile(
                                alignment: TimelineAlign.manual,
                                lineXY: 0.1,
                                isFirst:
                                    userData.healingJourneyMap.indexOf(entry) ==
                                        0,
                                isLast:
                                    userData.healingJourneyMap.indexOf(entry) ==
                                        9,
                                indicatorStyle: IndicatorStyle(
                                  width: 20,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  padding: const EdgeInsets.all(6),
                                ),
                                endChild: ListTile(
                                  title: Text(
                                      '${entry['percentage'].toStringAsFixed(1)}%'),
                                  subtitle:
                                      Text(DateFormat('yyyy-MM-dd').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        entry['timestamp']),
                                  )),
                                  onTap: () =>
                                      _showEntryDetails(HealingJourneyEntry(
                                    timestamp:
                                        DateTime.fromMillisecondsSinceEpoch(
                                            entry['timestamp']),
                                    percentage: entry['percentage'],
                                    inProgressList: List<String>.from(
                                        entry['inProgressList']),
                                    doneList:
                                        List<String>.from(entry['doneList']),
                                    notes: entry['notes'],
                                  )),
                                ),
                              )),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const VisualizeProgress(),
                            ));
                          },
                          child: const Text('See More'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HealingJourneyEntry {
  final DateTime timestamp;
  final double percentage;
  final List<String> inProgressList;
  final List<String> doneList;
  final String notes;

  HealingJourneyEntry({
    required this.timestamp,
    required this.percentage,
    required this.inProgressList,
    required this.doneList,
    required this.notes,
  });
}
