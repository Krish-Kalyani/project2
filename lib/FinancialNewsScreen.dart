import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FinancialNewsScreen extends StatefulWidget {
  const FinancialNewsScreen({Key? key}) : super(key: key);

  @override
  _FinancialNewsScreenState createState() => _FinancialNewsScreenState();
}

class _FinancialNewsScreenState extends State<FinancialNewsScreen> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<Map<String, dynamic>>> _newsData;

  @override
  void initState() {
    super.initState();
    _newsData = fetchNews();
  }

  Future<List<Map<String, dynamic>>> fetchNews({String query = ''}) async {
    const String apiKey = 'ctdi0epr01qng9gela3gctdi0epr01qng9gela40';
    final String url = query.isEmpty
        ? 'https://finnhub.io/api/v1/news?category=general&token=$apiKey'
        : 'https://finnhub.io/api/v1/news?category=general&token=$apiKey&keyword=$query';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> news = json.decode(response.body);
      return news.map((article) {
        return {
          'headline': article['headline'],
          'source': article['source'],
          'image': article['image'],
          'summary': article['summary'],
          'url': article['url']
        };
      }).toList();
    } else {
      throw Exception('Failed to load news articles');
    }
  }

  void _searchNews() {
    setState(() {
      _newsData = fetchNews(query: _searchController.text.trim());
    });
  }

