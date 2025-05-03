import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:stock_tracker/screens/stockhandling.dart';

class WatchlistScreen extends StatefulWidget {
  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  Timer? updatetimer;

  @override
  void initState() {
    super.initState();
    startupdate();
  }

  void startupdate() {
    updatetimer = Timer.periodic(Duration(minutes: 1), (timer) {
      updatefavorites();
    });
  }

  Future<void> updatefavorites() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('watchlist')
            .get();

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final symbol = data['symbol'];

      final newprice = await getprice(symbol);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('watchlist')
          .doc(doc.id)
          .update({'price': newprice});
    }
  }

  @override
  void dispose() {
    updatetimer?.cancel();
    super.dispose();
  }

  void deletefavorite(String docId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('watchlist')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Watchlist",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.lightGreen[300],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .collection('watchlist')
                .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No favorites yet!'));
          }
          final docs = snapshot.data!.docs;
          final Map<String, List<QueryDocumentSnapshot>> categorized = {};

          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            final category = data['category'] ?? 'Uncategorized';
            categorized.putIfAbsent(category, () => []).add(doc);
          }

          return ListView(
            children:
                categorized.entries.map((entry) {
                  final category = entry.key;
                  final stocks = entry.value;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                      ...stocks.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final symbol = data['symbol'];
                        final rawPrice = data['price'];
                        final priceStr = rawPrice.toString().replaceAll(
                          '\$',
                          '',
                        );
                        final priceNum = double.tryParse(priceStr) ?? 0.0;

                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              symbol,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            subtitle: Text(
                              "\$${priceNum.toStringAsFixed(2)}",
                              style: TextStyle(fontSize: 15),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                deletefavorite(doc.id);
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
