import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final firstname = TextEditingController();
  final lastname = TextEditingController();

  bool _success = false;
  String? _userEmail;

  void _register() async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await firestorestorage(result.user!);
      setState(() {
        _success = true;
        _userEmail = _emailController.text;
      });
    } catch (e) {
      setState(() {
        _success = false;
      });
    }
  }

  Future<void> firestorestorage(User user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'firstName': firstname.text.trim(),
      'lastName': lastname.text.trim(),
      'role': 'user',
      'registrationDateTime': DateTime.now().toUtc().toIso8601String(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create a New Account",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightGreen[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: firstname,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        (value?.isEmpty ?? true) ? 'Enter first name' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: lastname,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        (value?.isEmpty ?? true) ? 'Enter last name' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) => (value?.isEmpty ?? true) ? 'Enter email' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        (value?.isEmpty ?? true) ? 'Enter password' : null,
                obscureText: true,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) _register();
                },
                child: Text("Register"),
              ),
              if (_success)
                Text(
                  "Registered as $_userEmail",
                  style: TextStyle(color: Colors.green),
                )
              else if (!_success && _userEmail != null)
                Text(
                  "Registration failed",
                  style: TextStyle(color: Colors.red),
                ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: Text("Already have an account? Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
