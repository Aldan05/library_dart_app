import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/book_model.dart';

class RealtimeDatabaseService {
  // Access the Realtime Database instance with the URL from your screenshot
  final DatabaseReference _db = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://library-97e7a-default-rtdb.firebaseio.com",
  ).ref();

  // Add book to favorites
  Future<void> addToFavorites(String userId, BookModel book) async {
    // In Realtime Database, we use .child() instead of .collection()
    // We clean the key because certain characters aren't allowed in paths
    String safeKey = book.key.replaceAll(RegExp(r'[.#$\[\]/]'), '_');

    await _db
        .child('users')
        .child(userId)
        .child('favorites')
        .child(safeKey)
        .set(book.toMap());
  }

  // Remove from favorites
  Future<void> removeFromFavorites(String userId, String bookKey) async {
    String safeKey = bookKey.replaceAll(RegExp(r'[.#$\[\]/]'), '_');

    await _db
        .child('users')
        .child(userId)
        .child('favorites')
        .child(safeKey)
        .remove(); // Use .remove() instead of .delete()
  }

  // Get favorites stream
  Stream<List<BookModel>> getFavorites(String userId) {
    return _db
        .child('users')
        .child(userId)
        .child('favorites')
        .onValue // This is the Realtime Database equivalent of snapshots()
        .map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return data.values.map((item) {
        return BookModel.fromMap(Map<String, dynamic>.from(item));
      }).toList();
    });
  }
}
