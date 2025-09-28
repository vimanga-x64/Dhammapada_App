// Defines the data structure for a single verse.
class Verse {
  final String id;
  final int verseNumber;
  final String chapterTitle;
  final Map<String, String> text;
  final String storyTitle;

  Verse({
    required this.id,
    required this.verseNumber,
    required this.chapterTitle,
    required this.text,
    required this.storyTitle,
  });

  factory Verse.fromJson(
      Map<String, dynamic> json, String chapterTitle) {
    return Verse(
      id: json['id'],
      // Safely parse the verse number, handling both int and String.
      verseNumber: int.tryParse(json['verse_number'].toString()) ?? 0,
      chapterTitle: chapterTitle,
      text: Map<String, String>.from(json['text'] ?? {}),
      storyTitle: json['story_title'] ?? '',
    );
  }
}