import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_tracker/screens/login.dart';
import 'stockhandling.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController search = TextEditingController();

  String? stocksymbol;
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
        stocksymbol = symbol;
        stockprice = price != null ? "\$$price" : "Not Found";
      });
    } catch (e) {
      setState(() {
        error = "API Handling Error";
      });
    }
  }

  void addtowatchlist() async {
    if (stocksymbol != null && stockprice != null) {
      try {
        final uid = user!.uid;
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('watchlist')
            .doc(stocksymbol);

        await docRef.set({'symbol': stocksymbol, 'price': stockprice});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Added $stocksymbol to favorites")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Cannot add stock to favorites")),
        );
      }
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
              Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(
                    stocksymbol!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(stockprice!, style: TextStyle(fontSize: 15)),
                  trailing: IconButton(
                    onPressed: addtowatchlist,
                    icon: Icon(Icons.add, color: Colors.green),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
