import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MyWatchlistScreen.dart';

class MarketOverviewScreen extends StatelessWidget {
  MarketOverviewScreen({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Row(
                children: [
                  Image.asset(
                    'assets/logotopleft.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Market Overview',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search stocks (e.g., TSLA, AAPL)',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('marketData')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No data available"));
                  }

                  final stocks = snapshot.data!.docs;

                  return Column(
                    children: stocks.map((stock) {
                      final stockData = stock.data() as Map<String, dynamic>;
                      return buildStockTile(
                        stockData['name'] ?? 'N/A',
                        stockData['value'] ?? 'N/A',
                        stockData['change'] ?? 'N/A',
                        stockData['iconPath'] ?? 'assets/greenarrow.png',
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 30),
              const Text(
                'Trending Stocks',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('trendingStocks')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text("No trending stocks available"));
                  }

                  final trendingStocks = snapshot.data!.docs;

                  return Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: trendingStocks.map((stock) {
                      final stockData = stock.data() as Map<String, dynamic>;
                      return buildTrendingStockTile(
                        stockData['name'] ?? 'N/A',
                        stockData['value'] ?? 'N/A',
                        stockData['change'] ?? 'N/A',
                        stockData['iconPath'] ?? 'assets/greenarrow.png',
                        100,
                      );
                    }).toList(),
                  );
                },
              ),