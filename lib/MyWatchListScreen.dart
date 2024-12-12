import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'StockDetailsScreen.dart';

class MyWatchlistScreen extends StatelessWidget {
  const MyWatchlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              Image.asset(
                'assets/Logo.png',
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                'My Watchlist',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Watchlist Table',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _showAddStockDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      '+Add Stock',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('watchlist')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return buildEmptyWatchlistTile();
                  }

                  final docs = snapshot.data!.docs;
                  return Column(
                    children: docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return buildWatchlistTile(
                        data['name'] ?? 'N/A',
                        data['symbol'] ?? 'N/A',
                        data['price']?.toString() ?? 'N/A',
                        data['change']?.toString() ?? 'N/A',
                        data['percentChange']?.toString() ?? 'N/A',
                        data['trend'] ?? 'up',
                        context,
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
