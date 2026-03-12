import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/hadith.dart';

class HadithService {
  static final HadithService _instance = HadithService._internal();
  factory HadithService() => _instance;
  HadithService._internal();

  final Map<String, List<Hadith>> _cache = {};

  Future<List<Hadith>> getHadiths(String sourceId) async {
    if (_cache.containsKey(sourceId)) {
      return _cache[sourceId]!;
    }

    final String fileName = sourceId == 'bukhari' ? 'shahih-bukhari.json' : 'shahih-muslim.json';
    try {
      final String response = await rootBundle.loadString('data/$fileName');
      final List<dynamic> data = json.decode(response);
      final List<Hadith> hadiths = data.map((e) => Hadith.fromJson(e)).toList();
      _cache[sourceId] = hadiths;
      return hadiths;
    } catch (e) {
      print('Error loading hadiths: $e');
      return [];
    }
  }

  Future<List<Hadith>> getHadithsByRange(String sourceId, int start, int end) async {
    final all = await getHadiths(sourceId);
    return all.where((h) => h.id >= start && h.id <= end).toList();
  }
  
  // Logic to group by 'Book' can be added here or in the UI layer
  // For now, we will handle categorization in the KitabListScreen
}
