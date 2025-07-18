import 'package:flutter/material.dart';
import 'screens/login.dart';
import 'screens/dashboard.dart';
import 'screens/medSchedule.dart';
import 'screens/healthLogs.dart';
import 'screens/appointments.dart';
import 'screens/profile.dart';

void main() => runApp(const MyMedBuddyApp());

class MyMedBuddyApp extends StatelessWidget {
  const MyMedBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyMedBuddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[800],
          foregroundColor: Colors.white,
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/dashboard': (context) => const DashboardScreen(),
        '/schedule': (context) => const MedicationScheduleScreen(),
        '/logs': (context) => const HealthLogsScreen(),
        '/appointments': (context) => const AppointmentsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
