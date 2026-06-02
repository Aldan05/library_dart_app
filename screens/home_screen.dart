import 'package:flutter/material.dart';
import '../config/app_styles.dart';
import '../config/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library App'),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu_book_rounded,
              size: 120,
              color: AppColors.primary,
            ),
            const SizedBox(height: 30),
            const Text(
              'Welcome to Open Library',
              style: AppStyles.heading,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Discover millions of books and track your reading journey.',
              style: AppStyles.subtitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/search'),
              icon: const Icon(Icons.search),
              label: const Text('Search for Books'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
