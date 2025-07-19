import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final List<Map<String, String>> _defaultAppointments = const [
    {
      'date': '2025-07-20',
      'time': '10:00 AM',
      'hospital': 'Greenfield Medical Center',
      'doctor': 'Dr. Linda Agyeman',
    },
    {
      'date': '2025-07-22',
      'time': '3:30 PM',
      'hospital': 'Hope Hospital',
      'doctor': 'Dr. Michael Owusu',
    },
    {
      'date': '2025-07-25',
      'time': '9:00 AM',
      'hospital': 'Sunrise Clinic',
      'doctor': 'Dr. Fatima Bello',
    },
  ];

  List<Map<String, String>> _customAppointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('appointments');
    if (stored != null) {
      final decoded = json.decode(stored) as List<dynamic>;
      _customAppointments =
          decoded.map((e) => Map<String, String>.from(e)).toList();
    }
    setState(() {});
  }

  Future<void> _saveAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_customAppointments);
    await prefs.setString('appointments', encoded);
  }

  void _addAppointmentDialog() {
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final hospitalController = TextEditingController();
    final doctorController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Appointment'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(labelText: 'Time'),
              ),
              TextField(
                controller: hospitalController,
                decoration: const InputDecoration(labelText: 'Hospital'),
              ),
              TextField(
                controller: doctorController,
                decoration: const InputDecoration(labelText: 'Doctor'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newAppointment = {
                'date': dateController.text.trim(),
                'time': timeController.text.trim(),
                'hospital': hospitalController.text.trim(),
                'doctor': doctorController.text.trim(),
              };
              setState(() {
                _customAppointments.add(newAppointment);
              });
              _saveAppointments();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Map<String, String> appointment) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: const Icon(Icons.calendar_month, color: Colors.green),
        title: Text(
          '${appointment['date']} at ${appointment['time']}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hospital: ${appointment['hospital']}'),
            Text('Doctor: ${appointment['doctor']}'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allAppointments = [..._defaultAppointments, ..._customAppointments];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: allAppointments.isEmpty
            ? const Center(child: Text('No appointments available.'))
            : ListView(
                children: allAppointments
                    .map((appointment) => _buildAppointmentCard(appointment))
                    .toList(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addAppointmentDialog,
        backgroundColor: Colors.green[800],
        tooltip: 'Add Appointment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
