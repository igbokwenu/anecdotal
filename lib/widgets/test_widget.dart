import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';

class HealingJourneyEntry {
  final DateTime timestamp;
  final double percentage;
  final List<String> inProgressList;
  final List<String> doneList;

  HealingJourneyEntry({
    required this.timestamp,
    required this.percentage,
    required this.inProgressList,
    required this.doneList,
  });
}

class HealingJourneyApp extends StatefulWidget {
  @override
  _HealingJourneyAppState createState() => _HealingJourneyAppState();
}

class _HealingJourneyAppState extends State<HealingJourneyApp> {
  double _currentPercentage = 0;
  List<String> _inProgressList = [];
  List<String> _doneList = [];
  List<HealingJourneyEntry> _entries = [];
  TextEditingController _inProgressController = TextEditingController();
  TextEditingController _doneController = TextEditingController();

  void _addInProgressItem() {
    if (_inProgressController.text.isNotEmpty) {
      setState(() {
        _inProgressList.add(_inProgressController.text);
        _inProgressController.clear();
      });
    }
  }

  void _addDoneItem() {
    if (_doneController.text.isNotEmpty) {
      setState(() {
        _doneList.add(_doneController.text);
        _doneController.clear();
      });
    }
  }

  void _recordProgress() {
    setState(() {
      _entries.add(HealingJourneyEntry(
        timestamp: DateTime.now(),
        percentage: _currentPercentage,
        inProgressList: List.from(_inProgressList),
        doneList: List.from(_doneList),
      ));
      _inProgressList.clear();
      _doneList.clear();
    });
  }

  void _showEntryDetails(HealingJourneyEntry entry) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Journey Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(entry.timestamp)}'),
                Text('Feeling: ${entry.percentage.toStringAsFixed(1)}%'),
                SizedBox(height: 10),
                Text('In Progress:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...entry.inProgressList.map((item) => Text('• $item')),
                SizedBox(height: 10),
                Text('Done:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...entry.doneList.map((item) => Text('• $item')),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Healing Journey')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                Text('How are you feeling today?',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                Slider(
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
                SizedBox(height: 20),
                Text('In Progress Activities:', style: TextStyle(fontSize: 16)),
                TextField(
                  controller: _inProgressController,
                  decoration: InputDecoration(
                    hintText: 'Add an in-progress activity',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _addInProgressItem,
                    ),
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: _inProgressList
                      .map((item) => Chip(
                            label: Text(item),
                            onDeleted: () {
                              setState(() {
                                _inProgressList.remove(item);
                              });
                            },
                          ))
                      .toList(),
                ),
                SizedBox(height: 20),
                Text('Completed Activities:', style: TextStyle(fontSize: 16)),
                TextField(
                  controller: _doneController,
                  decoration: InputDecoration(
                    hintText: 'Add a completed activity',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: _addDoneItem,
                    ),
                  ),
                ),
                Wrap(
                  spacing: 8,
                  children: _doneList
                      .map((item) => Chip(
                            label: Text(item),
                            onDeleted: () {
                              setState(() {
                                _doneList.remove(item);
                              });
                            },
                          ))
                      .toList(),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Record Progress'),
                  onPressed: _recordProgress,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[_entries.length - 1 - index];
                return TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1,
                  isFirst: index == 0,
                  isLast: index == _entries.length - 1,
                  indicatorStyle: IndicatorStyle(
                    width: 20,
                    color: Colors.blue,
                    padding: EdgeInsets.all(6),
                  ),
                  endChild: ListTile(
                    title: Text('${entry.percentage.toStringAsFixed(1)}%'),
                    subtitle:
                        Text(DateFormat('yyyy-MM-dd').format(entry.timestamp)),
                    onTap: () => _showEntryDetails(entry),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
