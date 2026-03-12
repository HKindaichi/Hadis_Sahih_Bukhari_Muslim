class Hadith {
  final int id;
  final String arabic;
  final String translation;

  Hadith({
    required this.id,
    required this.arabic,
    required this.translation,
  });

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      id: json['id'] as int,
      arabic: json['arabic'] as String,
      translation: json['terjemahan_ms'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabic': arabic,
      'terjemahan_ms': translation,
    };
  }
}
