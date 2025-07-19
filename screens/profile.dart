import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import '../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _fullName = 'User';
  String _username = 'username';
  String _age = '';
  String _condition = '';
  String _reminders = '';
  File? _profileImageFile;
  String _statusMessage = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _remindersController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedProfile();
  }

  Future<void> _loadSavedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final savedImagePath = prefs.getString('profile_image_path');

    setState(() {
      _fullName = prefs.getString('user_fullname') ?? 'User';
      _username = prefs.getString('user_username') ?? 'username';
      _age = prefs.getString('user_age') ?? '';
      _condition = prefs.getString('user_condition') ?? '';
      _reminders = prefs.getString('user_reminders') ?? '';

      _nameController.text = _fullName;
      _ageController.text = _age;
      _conditionController.text = _condition;
      _remindersController.text = _reminders;

      if (savedImagePath != null && File(savedImagePath).existsSync()) {
        _profileImageFile = File(savedImagePath);
      }
    });
  }

  Future<void> _pickAndSaveImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    final appDir = await getApplicationDocumentsDirectory();
    final savedPath = join(appDir.path, basename(pickedFile.path));
    final savedImage = await File(pickedFile.path).copy(savedPath);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', savedPath);

    setState(() {
      _profileImageFile = savedImage;
      _statusMessage = 'Profile image updated!';
    });
  }

  Future<void> _updateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_fullname', _nameController.text.trim());
    await prefs.setString('user_age', _ageController.text.trim());
    await prefs.setString('user_condition', _conditionController.text.trim());
    await prefs.setString('user_reminders', _remindersController.text.trim());

    setState(() {
      _fullName = _nameController.text.trim();
      _age = _ageController.text.trim();
      _condition = _conditionController.text.trim();
      _reminders = _remindersController.text.trim();
      _statusMessage = 'Profile updated successfully!';
    });
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      runApp(const MyMedBuddyApp());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.green[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickAndSaveImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.green[100],
                  backgroundImage: _profileImageFile != null
                      ? FileImage(_profileImageFile!)
                      : const AssetImage('assets/default_profile.png')
                          as ImageProvider,
                  child: _profileImageFile == null
                      ? const Icon(Icons.camera_alt, size: 32, color: Colors.green)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _conditionController,
                decoration: const InputDecoration(
                  labelText: 'Health Condition',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _remindersController,
                decoration: const InputDecoration(
                  labelText: 'Medication Reminders',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                ),
                child: const Text('Update Profile'),
              ),
              const SizedBox(height: 12),
              Text(
                '@$_username',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              if (_statusMessage.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  _statusMessage,
                  style: const TextStyle(color: Colors.green),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
