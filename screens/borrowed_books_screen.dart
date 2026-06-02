import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BorrowedBooksScreen extends StatelessWidget {
  const BorrowedBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String? userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("Please log in to view borrowed books.")),
      );
    }

    final DatabaseReference dbRef = FirebaseDatabase.instance.ref("users/$userId/borrowed_books");

    return Scaffold(
      appBar: AppBar(title: const Text("My Borrowed Books")),
      body: StreamBuilder(
        stream: dbRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("No Borrowed Books"));
          }

          // Use explicit casting to Map
          final Map<dynamic, dynamic> books = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          return ListView(
            padding: const EdgeInsets.all(8),
            children: books.entries.map((entry) {
              final bookData = entry.value as Map<dynamic, dynamic>;
              return Card(
                child: ListTile(
                  title: Text(bookData["title"] ?? "Unknown Title"),
                  subtitle: Text("Due: ${bookData['dueDate'] ?? 'N/A'}\nStatus: ${bookData['status'] ?? 'borrowed'}"),
                  trailing: bookData['status'] == 'borrowed' 
                    ? ElevatedButton(
                        onPressed: () {
                          // Return Book Logic
                          dbRef.child("${entry.key}/status").set("returned");
                          // You would also update global book availability here
                        }, 
                        child: const Text("Return")
                      )
                    : const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
