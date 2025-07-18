import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicationScheduleScreen extends StatefulWidget {
  const MedicationScheduleScreen({super.key});

  @override
  State<MedicationScheduleScreen> createState() =>
      _MedicationScheduleScreenState();
}

class _MedicationScheduleScreenState extends State<MedicationScheduleScreen> {
  // Hardcoded defaults
  final List<Map<String, String>> _defaultMedications = [
    {
      'name': 'Paracetamol',
      'dosage': '500mg',
      'time': '8:00 AM and 8:00 PM',
    },
    {
      'name': 'Amoxicillin',
      'dosage': '250mg',
      'time': 'Every 6 hours',
    },
    {
      'name': 'Vitamin D',
      'dosage': '1000 IU',
      'time': 'Once every morning',
    },
  ];

  // User-added meds
  List<Map<String, String>> _customMedications = [];

  @override
  void initState() {
    super.initState();
    _loadCustomMedications();
  }

  Future<void> _loadCustomMedications() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getString('medications');

    if (storedData != null) {
      final decoded = json.decode(storedData) as List<dynamic>;
      _customMedications =
          decoded.map((item) => Map<String, String>.from(item)).toList();
    }

    setState(() {});
  }

  Future<void> _saveCustomMedications() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_customMedications);
    await prefs.setString('medications', encoded);
  }

  void _addNewMedication() {
    final nameController = TextEditingController();
    final dosageController = TextEditingController();
    final timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Medication'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: dosageController,
              decoration: const InputDecoration(labelText: 'Dosage'),
            ),
            TextField(
              controller: timeController,
              decoration: const InputDecoration(labelText: 'Time'),
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
              final newMed = {
                'name': nameController.text,
                'dosage': dosageController.text,
                'time': timeController.text,
              };
              setState(() {
                _customMedications.add(newMed);
              });
              _saveCustomMedications();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationList(List<Map<String, String>> meds) {
    return Column(
      children: meds
          .map(
            (med) => Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.medication, color: Colors.green),
                title: Text(med['name'] ?? ''),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dosage: ${med['dosage']}'),
                    Text('Time: ${med['time']}'),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Schedule'),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            _buildMedicationList(_defaultMedications),
            const SizedBox(height: 20),
            if (_customMedications.isNotEmpty) ...[
              const SizedBox(height: 10),
              _buildMedicationList(_customMedications),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewMedication,
        backgroundColor: Colors.green[800],
        child: const Icon(Icons.add),
      ),
    );
  }
}
