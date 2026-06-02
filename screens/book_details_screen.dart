import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../utils/helpers.dart';
import '../config/app_styles.dart';

class BookDetailsScreen extends StatelessWidget {
  final BookModel book;

  const BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Center(
              child: Card(
                elevation: 8,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    Helpers.getBookCoverUrl(book.coverId, size: 'L'),
                    height: 350,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 150, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              book.title,
              style: AppStyles.heading,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "by ${book.author}",
              style: AppStyles.subtitle.copyWith(fontSize: 18, color: Colors.indigo),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildInfoColumn(Icons.calendar_today, "Published", book.firstPublishYear ?? "N/A"),
                _buildInfoColumn(Icons.language, "Language", "English"),
                _buildInfoColumn(Icons.star, "Rating", "4.5/5"),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              "About this Book",
              style: AppStyles.title,
            ),
            const SizedBox(height: 12),
            const Text(
              "This book is available on Open Library. It provides a wealth of information for readers and researchers alike. Search more details on the official website to explore chapters, editions, and more.",
              textAlign: TextAlign.justify,
              style: TextStyle(height: 1.6, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
