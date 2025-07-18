import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HealthLogsScreen extends StatefulWidget {
  const HealthLogsScreen({super.key});

  @override
  State<HealthLogsScreen> createState() => _HealthLogsScreenState();
}

class _HealthLogsScreenState extends State<HealthLogsScreen> {
  List<Map<String, String>> _logs = [];

  final List<Map<String, String>> _defaultLogs = const [
    {
      'date': '2025-07-15',
      'summary': 'Feeling tired, slight headache',
      'note': 'Slept late and woke up dizzy. Took paracetamol.',
    },
    {
      'date': '2025-07-14',
      'summary': 'Normal day',
      'note': 'No symptoms. Took all medications as scheduled.',
    },
    {
      'date': '2025-07-13',
      'summary': 'Mild fever in evening',
      'note': 'Temperature was 38°C. Drank water and rested.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString('health_logs');

    if (storedData != null) {
      final decoded = json.decode(storedData) as List<dynamic>;
      final savedLogs = decoded.map((e) => Map<String, String>.from(e)).toList();
      setState(() {
        _logs = [..._defaultLogs, ...savedLogs];
      });
    } else {
      setState(() {
        _logs = [..._defaultLogs];
      });
    }
  }

  Future<void> _saveLogs(List<Map<String, String>> customLogsOnly) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(customLogsOnly);
    await prefs.setString('health_logs', encoded);
  }

  void _addNewLog() {
    final dateController = TextEditingController();
    final summaryController = TextEditingController();
    final noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Health Log'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
            ),
            TextField(
              controller: summaryController,
              decoration: const InputDecoration(labelText: 'Summary'),
            ),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(labelText: 'Note'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newLog = {
                'date': dateController.text,
                'summary': summaryController.text,
                'note': noteController.text,
              };
              setState(() {
                _logs.add(newLog);
              });

              // Save only logs added by user (excluding defaults)
              final savedLogs = _logs.skip(_defaultLogs.length).toList();
              _saveLogs(savedLogs);

              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(Map<String, String> log) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        leading: const Text(
          '🩺',
          style: TextStyle(fontSize: 24),
        ),
        title: Text(log['summary'] ?? '',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Date: ${log['date']}'),
            const SizedBox(height: 4),
            Text('Note: ${log['note']}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Logs'),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _logs.isEmpty
            ? const Center(child: Text('No health logs available.'))
            : ListView(children: _logs.map(_buildLogCard).toList()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewLog,
        backgroundColor: Colors.green[800],
        child: const Icon(Icons.add),
        tooltip: 'Add Log',
      ),
    );
  }
}
