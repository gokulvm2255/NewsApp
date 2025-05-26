import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class BookmarkProviderHelper with ChangeNotifier {
    List<Map<String, dynamic>> _bookmarkedArticles = [];
  static const String _bookmarksKey = 'saved_bookmarks';



  // final List<Map<String, dynamic>> _bookmarkedArticles = [];

  List<Map<String, dynamic>> get bookmarkedArticles => _bookmarkedArticles;

  BookmarkProviderHelper() {
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? bookmarksJson = prefs.getString(_bookmarksKey);
      
      if (bookmarksJson != null) {
        final List<dynamic> decodedList = json.decode(bookmarksJson);
        _bookmarkedArticles = decodedList.map<Map<String, dynamic>>((item) => Map<String, dynamic>.from(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading bookmarks: $e');
    }
  }

  Future<void> _saveBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_bookmarksKey, json.encode(_bookmarkedArticles));
    } catch (e) {
      debugPrint('Error saving bookmarks: $e');
    }
  }




  void addBookmark(Map<String, dynamic> article) async {
    if (!_bookmarkedArticles.any((item) => item['title'] == article['title'])) {
      _bookmarkedArticles.add(article);
      await _saveBookmarks();
      notifyListeners();
    }
  }

  void removeBookmark(Map<String, dynamic> article) async{
    _bookmarkedArticles.removeWhere((item) => item['title'] == article['title']);
    await _saveBookmarks();
    notifyListeners();
  }

  bool isBookmarked(Map<String, dynamic> article) {
    return _bookmarkedArticles.any((item) => item['title'] == article['title']);
  }
}