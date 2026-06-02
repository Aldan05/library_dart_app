import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final dynamic book;
  final VoidCallback onTap;

  const BookCard({super.key, required this.book, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Handling different image structures from different API endpoints
    int? coverId;
    if (book["cover_i"] != null) {
      coverId = book["cover_i"];
    } else if (book["cover_id"] != null) {
      coverId = book["cover_id"];
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: coverId != null
            ? Image.network(
                "https://covers.openlibrary.org/b/id/$coverId-M.jpg",
                width: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.book),
              )
            : const Icon(Icons.book, size: 40),
        title: Text(book["title"] ?? "No Title", maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          (book["author_name"] != null && (book["author_name"] as List).isNotEmpty) 
              ? book["author_name"][0] 
              : "No Author",
        ),
        onTap: onTap,
      ),
    );
  }
}
