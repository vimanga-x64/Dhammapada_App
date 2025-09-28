import 'package:flutter/material.dart';
import 'chapter.dart';

class BuddhistText {
  final String id;
  final String title;
  final String description;
  final String language;
  final List<Chapter> chapters;
  final String coverImagePath;
  final Color themeColor;

  BuddhistText({
    required this.id,
    required this.title,
    required this.description,
    required this.language,
    required this.chapters,
    required this.coverImagePath,
    required this.themeColor,
  });

  factory BuddhistText.fromJson(Map<String, dynamic> json) {
    var chapterList = json['chapters'] as List;
    List<Chapter> chapters = chapterList.map((c) => Chapter.fromJson(c)).toList();
    
    return BuddhistText(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      language: json['language'],
      chapters: chapters,
      coverImagePath: json['cover_image'] ?? '',
      themeColor: Color(int.parse(json['theme_color'] ?? '0xFF5E35B1')),
    );
  }
}