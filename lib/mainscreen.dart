import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainScreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final displayName = user?.email ?? "User";

    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, $displayName!", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
