import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'hadith_list_screen.dart';

// Dummy data to simulate API response since the real site returns 403
final Map<String, List<Map<String, dynamic>>> dummyKitabList = {
  'bukhari': [
    {'id': 1, 'name': 'Kitab Wahyu', 'total': 7},
    {'id': 2, 'name': 'Kitab Iman', 'total': 51},
    {'id': 3, 'name': 'Kitab Ilmu', 'total': 76},
    {'id': 4, 'name': 'Kitab Wuduk', 'total': 111},
    {'id': 5, 'name': 'Kitab Mandi', 'total': 44},
  ],
  'muslim': [
    {'id': 1, 'name': 'Kitab Iman', 'total': 431},
    {'id': 2, 'name': 'Kitab Bersuci', 'total': 144},
    {'id': 3, 'name': 'Kitab Haid', 'total': 143},
    {'id': 4, 'name': 'Kitab Solat', 'total': 324},
    {'id': 5, 'name': 'Kitab Masjid & Tempat Solat', 'total': 382},
  ],
};

class KitabListScreen extends StatelessWidget {
  final String kitabName;
  final String sourceId; // 'bukhari' or 'muslim'

  const KitabListScreen({
    super.key,
    required this.kitabName,
    required this.sourceId,
  });

  @override
  Widget build(BuildContext context) {
    final books = dummyKitabList[sourceId] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(kitabName),
        backgroundColor: Colors.transparent,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        itemCount: books.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final book = books[index];
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  '${book['id']}',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              title: Text(
                book['name'],
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                '${book['total']} Hadis',
                style: GoogleFonts.inter(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HadithListScreen(
                      sourceId: sourceId,
                      bookId: book['id'] as int,
                      bookName: book['name'] as String,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
