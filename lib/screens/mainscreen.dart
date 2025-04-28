import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_tracker/screens/login.dart';
import 'stockhandling.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController search = TextEditingController();

  String? stockprice;
  String? error;

  Future<void> searchstock() async {
    final symbol = search.text.trim().toUpperCase();
    if (symbol.isEmpty) return;

    setState(() {
      error = null;
    });

    try {
      final price = await getprice(symbol);
      setState(() {
        stockprice = price != null ? "\$$price" : "Not Found";
      });
    } catch (e) {
      setState(() {
        error = "API Handling Error";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = user?.email ?? "User";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen[300],
        title: Text(
          "Welcome, $displayName!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text("Watchlist"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text("Charts"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    child: Text("News Feed"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: search,
              decoration: InputDecoration(
                hintText: "Enter Stock Name by Symbol",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton(onPressed: searchstock, child: Text("Search")),
            SizedBox(height: 16),
            if (error != null)
              Text(error!, style: TextStyle(color: Colors.red)),
            if (stockprice != null)
              Text(
                "Current Price: $stockprice",
                style: TextStyle(fontSize: 20),
              ),
          ],
        ),
      ),
    );
  }
}
