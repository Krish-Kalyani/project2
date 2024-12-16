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
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Financial News'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Image.asset(
                  'assets/Logo.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Financial News',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search stocks (e.g., TSLA, AAPL)',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onSubmitted: (value) => _searchNews(),
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _newsData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'No articles found. Try a different search.',
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final articles = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        final article = articles[index];
                        return buildNewsCard(article);
                      },
                    );
                  } else {
                    return const Center(child: Text('No data available.'));
                  }
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }