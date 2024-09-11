import 'package:flutter/material.dart';
import 'package:timelines/timelines.dart';
import 'package:intl/intl.dart';

class HealingJourneyPage extends StatefulWidget {
  @override
  _HealingJourneyPageState createState() => _HealingJourneyPageState();
}

class _HealingJourneyPageState extends State<HealingJourneyPage> {
  double _healingPercentage = 0.0;
  final List<Map<String, dynamic>> _healingRecords = [];
  final List<String> _inProgressList = ['Meditation', 'Physical Therapy'];
  final List<String> _doneList = ['Diet Change', 'Daily Walking'];
  TextEditingController _notesController = TextEditingController();

  void _recordProgress() {
    final timestamp = DateFormat.yMd().add_jm().format(DateTime.now());

    if (_notesController.text.length > 500) return; // Limit notes to 500 chars

    setState(() {
      _healingRecords.add({
        'percentage': _healingPercentage,
        'inProgressList': List.from(_inProgressList),
        'doneList': List.from(_doneList),
        'timestamp': timestamp,
        'note': _notesController.text,
      });
      _notesController.clear(); // Clear the notes after recording
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Healing Journey')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How are you feeling today?', style: TextStyle(fontSize: 18)),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _healingPercentage,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '${_healingPercentage.round()}%',
                    onChanged: (value) {
                      setState(() {
                        _healingPercentage = value;
                      });
                    },
                  ),
                ),
                Text('${_healingPercentage.round()}%',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 10),
            _buildActivityList('In Progress Activities', _inProgressList),
            _buildActivityList('Done Activities', _doneList),
            SizedBox(height: 20),
            _buildNotesSection(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _recordProgress,
              child: Text('Record Progress'),
            ),
            SizedBox(height: 30),
            Expanded(child: _buildTimeline())
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList(String label, List<String> activityList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Wrap(
          children: List.generate(
            activityList.length,
            (index) => Chip(
              label: Text(activityList[index]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Notes (optional)', style: TextStyle(fontSize: 16)),
        TextField(
          controller: _notesController,
          maxLength: 500,
          decoration: InputDecoration(hintText: 'Enter any notable activities'),
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildTimeline() {
    return Timeline.tileBuilder(
      builder: TimelineTileBuilder.fromStyle(
        contentsAlign: ContentsAlign.alternating,
        contentsBuilder: (context, index) {
          final record = _healingRecords[index];
          return GestureDetector(
            onTap: () => _showRecordDetails(record),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Progress: ${record['percentage']}%\nRecorded on: ${record['timestamp']}',
              ),
            ),
          );
        },
        indicatorStyle: IndicatorStyle
            .dot, // Use indicatorStyle instead of indicatorBuilder
        indicatorPositionBuilder: (context, index) {
          return 0.5; // Adjust as needed for positioning
        },
        connectorStyle: ConnectorStyle.solidLine,
        itemCount: _healingRecords.length,
      ),
    );
  }

  void _showRecordDetails(Map<String, dynamic> record) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Progress: ${record['percentage']}%'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Recorded on: ${record['timestamp']}'),
                SizedBox(height: 10),
                Text('In Progress:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...record['inProgressList']
                    .map<Widget>((task) => Text('- $task')),
                SizedBox(height: 10),
                Text('Done:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...record['doneList'].map<Widget>((task) => Text('- $task')),
                SizedBox(height: 10),
                if (record['note'].isNotEmpty)
                  Text('Note:', style: TextStyle(fontWeight: FontWeight.bold)),
                if (record['note'].isNotEmpty) Text(record['note']),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
