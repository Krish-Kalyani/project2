import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StockDetailsScreen extends StatefulWidget {
  final String stockSymbol;

  const StockDetailsScreen({Key? key, required this.stockSymbol})
      : super(key: key);

  @override
  _StockDetailsScreenState createState() => _StockDetailsScreenState();
}

class _StockDetailsScreenState extends State<StockDetailsScreen> {
  late Future<Map<String, dynamic>> stockData;

  @override
  void initState() {
    super.initState();
    stockData = fetchRealtimeData(widget.stockSymbol);
  }

  Future<Map<String, dynamic>> fetchRealtimeData(String symbol) async {
    const String apiKey = 'ctdi0epr01qng9gela3gctdi0epr01qng9gela40';
    final response = await http.get(Uri.parse(
        'https://finnhub.io/api/v1/quote?symbol=$symbol&token=$apiKey'));
          if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isEmpty) {
        throw Exception('No data available for this stock.');
      }
      return data;
    } else {
      throw Exception(
          'Failed to fetch data. HTTP Status: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${widget.stockSymbol} Details'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/Logo.png',
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
               const SizedBox(height: 20),
              FutureBuilder<Map<String, dynamic>>(
                future: stockData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.red),
                    ));
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.stockSymbol} (${widget.stockSymbol})',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Current Price: \$${data['c']}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                         const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Text(
                                  'Daily High',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('\$${data['h']}'),
                              ],
                            ),
                            Column(
                              children: [
                                const Text(
                                  'Daily Low',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text('\$${data['l']}'),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Market Metrics',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Market Cap: 3.475T'),
                        const Text('P/E Ratio: 37.87'),
                        const Text('Dividend Yield: 1.00 (0.44%)'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                          ),
                          child: const Text(
                            'Add/Remove',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text('No data available');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}