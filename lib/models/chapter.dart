import 'verse.dart';

class Chapter {
  final int id;
  final String title;
  final List<Verse> verses;

  Chapter({required this.id, required this.title, required this.verses});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    var verseList = json['verses'] as List;
    List<Verse> verses =
        verseList.map((v) => Verse.fromJson(v, json['title'])).toList();
    return Chapter(
      id: json['id'],
      title: json['title'],
      verses: verses,
    );
  }
}