import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/hadith_service.dart';
import '../models/hadith.dart';
import 'hadith_list_screen.dart';

// Mapping for Kitabs (Books) - This can be expanded based on standard Sahih Bukhari/Muslim books
final Map<String, List<Map<String, dynamic>>> kitabMapping = {
  'bukhari': [
    {'id': 1, 'name': 'Wahyu', 'start': 1, 'end': 7},
    {'id': 2, 'name': 'Iman', 'start': 8, 'end': 58},
    {'id': 3, 'name': 'Ilmu', 'start': 59, 'end': 134},
    {'id': 4, 'name': 'Wuduk', 'start': 135, 'end': 247},
    {'id': 5, 'name': 'Mandi', 'start': 248, 'end': 293},
    // More can be added...
    {'id': 6, 'name': 'Lain-lain', 'start': 294, 'end': 7008},
  ],
  'muslim': [
    {'id': 1, 'name': 'Iman', 'start': 1, 'end': 431},
    {'id': 2, 'name': 'Bersuci', 'start': 432, 'end': 576},
    // More can be added...
    {'id': 3, 'name': 'Lain-lain', 'start': 577, 'end': 5359},
  ],
};

class KitabListScreen extends StatefulWidget {
  final String kitabName;
  final String sourceId; // 'bukhari' or 'muslim'

  const KitabListScreen({
    super.key,
    required this.kitabName,
    required this.sourceId,
  });

  @override
  State<KitabListScreen> createState() => _KitabListScreenState();
}

class _KitabListScreenState extends State<KitabListScreen> {
  final HadithService _hadithService = HadithService();
  bool _isLoading = false;
  int _totalHadiths = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final all = await _hadithService.getHadiths(widget.sourceId);
    if (mounted) {
      setState(() {
        _totalHadiths = all.length;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final books = kitabMapping[widget.sourceId] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.kitabName),
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              physics: const BouncingScrollPhysics(),
              itemCount: books.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final book = books[index];
                final count = book['end'] - book['start'] + 1;
                
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
                      '$count Hadis (${book['start']} - ${book['end']})',
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
                            sourceId: widget.sourceId,
                            bookId: book['id'] as int,
                            bookName: book['name'] as String,
                            rangeStart: book['start'] as int,
                            rangeEnd: book['end'] as int,
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
