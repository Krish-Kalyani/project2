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