import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'screens/login.dart';
import 'screens/dashboard.dart';
import 'screens/medSchedule.dart';
import 'screens/healthLogs.dart';
import 'screens/appointments.dart';
import 'screens/profile.dart';
import 'providers/theme_provider.dart'; 

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyMedBuddyApp(),
    ),
  );
}

class MyMedBuddyApp extends StatelessWidget {
  const MyMedBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'MyMedBuddy',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green[800],
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
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
