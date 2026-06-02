import 'package:flutter/material.dart';
import '../services/library_api.dart';
import '../widgets/book_card.dart';
import 'book_detail_screen.dart';

class TrendingScreen extends StatefulWidget {
  const TrendingScreen({super.key});

  @override
  _TrendingScreenState createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  List<dynamic> trending = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTrending();
  }

  void loadTrending() async {
    setState(() => loading = true);
    trending = await LibraryAPI.trendingNow();
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trending Books")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : trending.isEmpty
              ? const Center(child: Text("No trending books found."))
              : ListView.builder(
                  itemCount: trending.length,
                  itemBuilder: (_, index) {
                    final book = trending[index];
                    return BookCard(
                      book: book,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookDetailScreen(book),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
