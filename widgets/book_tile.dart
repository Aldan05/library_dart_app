import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../utils/helpers.dart';
import '../config/app_styles.dart';

class BookTile extends StatelessWidget {
  final BookModel book;
  final VoidCallback onTap;

  const BookTile({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            Helpers.getBookCoverUrl(book.coverId),
            width: 50,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 50),
          ),
        ),
        title: Text(book.title, style: AppStyles.title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(book.author, style: AppStyles.subtitle),
        onTap: onTap,
      ),
    );
  }
}
