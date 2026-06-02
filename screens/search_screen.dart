import 'package:flutter/material.dart';
import '../services/library_api.dart';
import '../widgets/book_card.dart';
import 'book_detail_screen.dart';
import 'trending_screen.dart';
import 'borrowed_books_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();
  List<dynamic> books = [];
  bool loading = false;

  void searchBook() async {
    if (controller.text.isEmpty) return;
    setState(() => loading = true);
    try {
      books = await LibraryAPI.searchBooks(controller.text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OpenLibrary App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            tooltip: "My Borrowed Books",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BorrowedBooksScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.trending_up),
            tooltip: "Trending Now",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TrendingScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Search for a book...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: searchBook,
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => searchBook(),
            ),
          ),

          if (loading) const LinearProgressIndicator(),

          Expanded(
            child: books.isEmpty && !loading
              ? const Center(child: Text("Search or explore trending books!"))
              : ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (_, index) {
                    return BookCard(
                      book: books[index],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookDetailScreen(books[index]),
                          ),
                        );
                      },
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
