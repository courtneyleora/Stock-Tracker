import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stock_tracker/screens/login.dart';
import 'stockhandling.dart';
import 'watchlist.dart';
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
  String? firstName;

  @override
  void initState() {
    super.initState();
    getname();
  }

  Future<void> getname() async {
    if (user != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .get();

      setState(() {
        firstName = doc.data()?['firstName'] ?? 'User';
      });
    }
  }

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
    final displayName = firstName ?? user?.email ?? "User";
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
            Wrap(
              spacing: 16,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WatchlistScreen(),
                      ),
                    );
                  },
                  icon: Icon(Icons.star_border, color: Colors.lightGreen[600]),
                  label: Text("Watchlist"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.lightGreen,
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  icon: Icon(Icons.bar_chart, color: Colors.lightGreen[600]),
                  label: Text("Charts"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.lightGreen,
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  icon: Icon(
                    Icons.article_outlined,
                    color: Colors.lightGreen[600],
                  ),
                  label: Text("Newsfeed"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.lightGreen,
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            TextField(
              controller: search,
              decoration: InputDecoration(
                hintText: "Enter Stock Name by Symbol",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                suffixIcon: IconButton(
                  onPressed: () => search.clear(),
                  icon: Icon(Icons.clear),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: searchstock,
              icon: Icon(Icons.search, color: Colors.lightGreen[100]),
              label: Text("Search"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreen[600],
                foregroundColor: Colors.white,
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
            SizedBox(height: 16),
            if (error != null)
              Text(error!, style: TextStyle(color: Colors.red)),
            if (stockprice != null)
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: Icon(Icons.trending_up),
                  title: Text(
                    stocksymbol!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    stockprice!,
                    style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                  ),
                  trailing: ElevatedButton.icon(
                    label: Text("Add Stock"),
                    onPressed: addtowatchlist,
                    icon: Icon(Icons.add_circle_outline, color: Colors.green),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
