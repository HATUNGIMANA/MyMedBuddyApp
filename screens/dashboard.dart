import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/theme_provider.dart'; 

class DashboardScreen extends StatefulWidget {
  static const Color primaryTheme = Color.fromRGBO(46, 125, 50, 1.0);

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _fullName = 'User';
  late Future<String> _healthTip;

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _healthTip = _fetchHealthTip();
  }

  Future<void> _loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName = prefs.getString('user_fullname') ?? 'User';
    });
  }

  Future<String> _fetchHealthTip() async {
    try {
      final response =
          await http.get(Uri.parse('https://dummyjson.com/quotes/random'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['quote'] ?? 'Stay healthy!';
      } else {
        throw Exception('Failed to load tip');
      }
    } catch (e) {
      return '⚠️ Could not load health tip.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: DashboardScreen.primaryTheme,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Hello,',
                style: TextStyle(fontSize: 14, color: Colors.white70)),
            Text(
              _fullName,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
        actions: [
          Switch(
            value: themeProvider.isDarkMode,
            activeColor: Colors.white,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: DashboardScreen.primaryTheme.withOpacity(0.8),
              alignment: Alignment.center,
              child: const Text(
                'DASHBOARD',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),

            // Summary Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Theme.of(context).cardColor,
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      Flexible(
                        child: Column(
                          children: [
                            Icon(Icons.schedule, color: Colors.green),
                            SizedBox(height: 8),
                            Text('Next Medication',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('Paracetamol - 8:00 PM',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.red),
                            SizedBox(height: 8),
                            Text('Missed Doses',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('2 this week',
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            Icon(Icons.event, color: Colors.blue),
                            SizedBox(height: 8),
                            Text('Appointments',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('2 this week',
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Health Tip Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: FutureBuilder<String>(
                future: _healthTip,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text('❌ Error loading health tip');
                  } else {
                    return Card(
                      color: Colors.green[50],
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.health_and_safety,
                                color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                snapshot.data ?? '💡 Stay healthy!',
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),

            // Grid Navigation
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildDashboardButton(context, 'Medication Schedule',
                    Icons.medication, '/schedule'),
                _buildDashboardButton(context, 'Health Logs', Icons.favorite,
                    '/logs'),
                _buildDashboardButton(context, 'Appointments',
                    Icons.calendar_month, '/appointments'),
                _buildDashboardButton(
                    context, 'Profile', Icons.person, '/profile'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardButton(
      BuildContext context, String title, IconData icon, String route) {
    return Card(
      elevation: 3,
      color: DashboardScreen.primaryTheme.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pushNamed(context, route),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
