import 'package:flutter/material.dart';
import '../services/library_api.dart';
import '../services/library_service.dart';

class BookDetailScreen extends StatefulWidget {
  final dynamic book;
  const BookDetailScreen(this.book, {super.key});

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  Map<String, dynamic>? details;
  Map<String, dynamic>? authorDetails;
  bool loading = true;
  bool isBookAvailable = true;
  final libraryService = LibraryService();

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  Future<void> loadAllData() async {
    setState(() => loading = true);
    
    try {
      final String key = widget.book["key"] ?? "";
      final workId = key.replaceAll("/works/", "");
      
      if (workId.isNotEmpty) {
        details = await LibraryAPI.getBookDetails(workId);
        // Check availability in Realtime Database
        isBookAvailable = await libraryService.isAvailable(workId);
      }

      if (widget.book["author_key"] != null && (widget.book["author_key"] as List).isNotEmpty) {
        final authorId = widget.book["author_key"][0];
        authorDetails = await LibraryAPI.getAuthor(authorId);
      }
    } catch (e) {
      debugPrint("Error loading full details: $e");
    }

    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final String workId = (book["key"] ?? "").toString().replaceAll("/works/", "");

    return Scaffold(
      appBar: AppBar(title: Text(book["title"] ?? "Book Details")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: book["cover_i"] != null
                            ? Image.network(
                                "https://covers.openlibrary.org/b/id/${book["cover_i"]}-L.jpg",
                                height: 300,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.book, size: 150),
                              )
                            : const Icon(Icons.book, size: 150),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    book["title"] ?? "No Title",
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    authorDetails?["name"] ?? (book["author_name"] != null ? book["author_name"][0] : "Unknown Author"),
                    style: const TextStyle(fontSize: 20, color: Colors.indigo, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 16),

                  // Borrow / Return Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isBookAvailable ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          isBookAvailable ? "Available to Borrow" : "Currently Borrowed",
                          style: TextStyle(
                            color: isBookAvailable ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: isBookAvailable ? () async {
                            await libraryService.borrowBook(
                              workId, 
                              book["title"], 
                              book["author_name"] != null ? book["author_name"][0] : "Unknown"
                            );
                            setState(() => isBookAvailable = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Book Borrowed Successfully")),
                            );
                          } : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("Borrow This Book"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem(Icons.calendar_today, "First Published", book["first_publish_year"]?.toString() ?? "N/A"),
                      _buildInfoItem(Icons.library_books, "Editions", book["edition_count"]?.toString() ?? "N/A"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text("Description", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    _getDescription(),
                    style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.indigo),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  String _getDescription() {
    if (details == null || details!["description"] == null) return "No description available.";
    final desc = details!["description"];
    if (desc is Map) return desc["value"] ?? "No description available.";
    return desc.toString();
  }
}
