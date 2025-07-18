import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ Required import

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Map<String, Map<String, String>> _userData = {
    'admin': {'password': 'admin123', 'fullname': 'Admin User'},
    'eric': {'password': 'pass2025', 'fullname': 'Eric Hatungimana'},
    'david': {'password': 'davy2025', 'fullname': 'David Mugisha'},
  };

  bool _isRegistering = false;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _newUsernameController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  String? _errorMessage;

  Future<void> _loginUser() async {
  final username = _usernameController.text.trim();
  final password = _passwordController.text.trim();

  if (_userData.containsKey(username) &&
      _userData[username]!['password'] == password) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_fullname', _userData[username]!['fullname']!);
    await prefs.setString('user_username', username); 

    Navigator.pushReplacementNamed(context, '/dashboard');
  } else {
    setState(() {
      _errorMessage = 'Invalid username or password';
    });
  }
}


  void _registerUser() {
    final name = _fullNameController.text.trim();
    final username = _newUsernameController.text.trim();
    final password = _newPasswordController.text.trim();

    if (name.isEmpty || username.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'All fields are required');
      return;
    }

    if (_userData.containsKey(username)) {
      setState(() => _errorMessage = 'Username already exists');
      return;
    }

    setState(() {
      _userData[username] = {
        'fullname': name,
        'password': password,
      };
      _isRegistering = false;
      _errorMessage = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Account created successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isRegistering ? 'Register' : 'Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _isRegistering ? _registerFormKey : _loginFormKey,
          child: ListView(
            children: [
              if (_isRegistering)
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              if (_isRegistering) const SizedBox(height: 16),
              TextFormField(
                controller: _isRegistering
                    ? _newUsernameController
                    : _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _isRegistering
                    ? _newPasswordController
                    : _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: () {
                  final formKey =
                      _isRegistering ? _registerFormKey : _loginFormKey;
                  if (formKey.currentState!.validate()) {
                    _isRegistering ? _registerUser() : _loginUser();
                  }
                },
                child: Text(_isRegistering ? 'Register' : 'Login'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isRegistering = !_isRegistering;
                    _errorMessage = null;
                    _usernameController.clear();
                    _passwordController.clear();
                    _fullNameController.clear();
                    _newUsernameController.clear();
                    _newPasswordController.clear();
                  });
                },
                child: Text(
                  _isRegistering
                      ? 'Already have an account? Login'
                      : 'Don’t have an account? Register here',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
