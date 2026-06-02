import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../firebase/firestore_service.dart'; // This file now contains RealtimeDatabaseService
import '../models/book_model.dart';
import '../widgets/book_card.dart';
import 'book_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final RealtimeDatabaseService _dbService = RealtimeDatabaseService();
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text("Please log in to see your favorites.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Favorites")),
      body: StreamBuilder<List<BookModel>>(
        stream: _dbService.getFavorites(userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("No favorites yet.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          final favorites = snapshot.data!;
          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final bookModel = favorites[index];
              // Convert to Map for compatibility with BookCard and DetailScreen
              final bookData = bookModel.toMap(); 
              
              return BookCard(
                book: bookData,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookDetailScreen(bookData),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
