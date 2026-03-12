import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/hadith_service.dart';
import '../models/hadith.dart';
import 'hadith_detail_screen.dart';

class HadithListScreen extends StatefulWidget {
  final String sourceId;
  final int bookId;
  final String bookName;
  final int rangeStart;
  final int rangeEnd;

  const HadithListScreen({
    super.key,
    required this.sourceId,
    required this.bookId,
    required this.bookName,
    required this.rangeStart,
    required this.rangeEnd,
  });

  @override
  State<HadithListScreen> createState() => _HadithListScreenState();
}

class _HadithListScreenState extends State<HadithListScreen> {
  final HadithService _hadithService = HadithService();
  List<Hadith> _hadiths = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHadiths();
  }

  Future<void> _loadHadiths() async {
    setState(() => _isLoading = true);
    final results = await _hadithService.getHadithsByRange(
      widget.sourceId,
      widget.rangeStart,
      widget.rangeEnd,
    );
    if (mounted) {
      setState(() {
        _hadiths = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.bookName,
              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'No. ${widget.rangeStart} - ${widget.rangeEnd}',
              style: GoogleFonts.inter(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hadiths.isEmpty
              ? const Center(child: Text('Tiada hadis ditemui.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  physics: const BouncingScrollPhysics(),
                  itemCount: _hadiths.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final hadith = _hadiths[index];
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
                                sourceName: widget.sourceId == 'bukhari' ? 'Sahih Bukhari' : 'Sahih Muslim',
                                bookName: widget.bookName,
                                hadithData: {
                                  'number': hadith.id,
                                  'arab': hadith.arabic,
                                  'terjemahan': hadith.translation,
                                },
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
                                      'Hadis #${hadith.id}',
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
                                  hadith.arabic,
                                  textAlign: TextAlign.right,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Amiri',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    height: 1.8,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                hadith.translation,
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
