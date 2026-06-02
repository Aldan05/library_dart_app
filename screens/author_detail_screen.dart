import 'package:flutter/material.dart';
import '../services/library_api.dart';

class AuthorDetailScreen extends StatefulWidget {
  final String authorId;
  const AuthorDetailScreen(this.authorId, {super.key});

  @override
  _AuthorDetailScreenState createState() => _AuthorDetailScreenState();
}

class _AuthorDetailScreenState extends State<AuthorDetailScreen> {
  dynamic author;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAuthor();
  }

  void loadAuthor() async {
    setState(() => loading = true);
    author = await LibraryAPI.getAuthor(widget.authorId);
    if (mounted) setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Author Details")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : author == null
              ? const Center(child: Text("Author details not found."))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        author["name"] ?? "Unknown Author",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Biography:",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        author["bio"] != null 
                          ? (author["bio"] is Map ? author["bio"]["value"] : author["bio"].toString()) 
                          : "No Bio available.",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      if (author["birth_date"] != null)
                        Text("Birth Date: ${author["birth_date"]}", style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
    );
  }
}
