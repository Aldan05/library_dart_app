import 'package:flutter/material.dart';
import '../services/library_api.dart';
import '../widgets/book_card.dart';
import 'book_detail_screen.dart';

class SubjectScreen extends StatefulWidget {
  final String subject;
  const SubjectScreen(this.subject, {super.key});

  @override
  _SubjectScreenState createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  List<dynamic> books = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadSubject();
  }

  void loadSubject() async {
    setState(() => loading = true);
    books = await LibraryAPI.getSubject(widget.subject);
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subject)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : books.isEmpty
              ? const Center(child: Text("No books found for this subject."))
              : ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (_, index) {
                    final book = books[index];
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
