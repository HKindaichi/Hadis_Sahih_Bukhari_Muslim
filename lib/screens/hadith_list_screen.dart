import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'hadith_detail_screen.dart';

// Dummy data for Hadiths
final List<Map<String, dynamic>> dummyHadiths = [
  {
    'number': 1,
    'arab': 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى',
    'terjemahan': 'Sesungguhnya setiap amalan itu bergantung pada niat, dan sesungguhnya setiap orang akan dibalas berdasarkan apa yang dia niatkan.',
  },
  {
    'number': 2,
    'arab': 'مَنْ يُرِدِ اللَّهُ بِهِ خَيْرًا يُفَقِّهْهُ فِي الدِّينِ',
    'terjemahan': 'Sesiapa yang Allah kehendaki kebaikan baginya, nescaya Allah akan memberinya kefahaman dalam agama.',
  },
  {
    'number': 3,
    'arab': 'كَلِمَتَانِ حَبِيبَتَانِ إِلَى الرَّحْمَنِ، خَفِيفَتَانِ عَلَى اللِّسَانِ، ثَقِيلَتَانِ فِي الْمِيزَانِ: سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ',
    'terjemahan': 'Dua kalimah yang dicintai ar-Rahman, ringan di lisan (lidah), yakni disebutkan dan berat di mizan (timbangan amalan): Subhanallah Wa Bihamdih, Subhanallahil Azim.',
  },
];

class HadithListScreen extends StatelessWidget {
  final String sourceId;
  final int bookId;
  final String bookName;

  const HadithListScreen({
    super.key,
    required this.sourceId,
    required this.bookId,
    required this.bookName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          bookName,
          style: GoogleFonts.outfit(fontSize: 18),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        itemCount: dummyHadiths.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final hadith = dummyHadiths[index];
          return Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
              ),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HadithDetailScreen(
                      sourceName: sourceId == 'bukhari' ? 'Sahih Bukhari' : 'Sahih Muslim',
                      bookName: bookName,
                      hadithData: hadith,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Hadis #${hadith['number']}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.bookmark_border_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        hadith['arab'],
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'Amiri', // Preferable for Arabic text
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          height: 1.8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      hadith['terjemahan'],
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
