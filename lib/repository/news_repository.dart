import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:news_app/Models/category_dart_model.dart';
import 'package:news_app/Models/news_channelHeadlines.dart';
import 'package:http/http.dart' as http;

class NewsRepository {
  Future<newsChannelHeadlinesmodel> fetchNewChannelHeadlinesApi(
      String source) async {
    String url =
        "https://newsapi.org/v2/top-headlines?sources=$source&apiKey=96ee6797ce3d44c88be8d08c9f282b42";
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return newsChannelHeadlinesmodel.fromJson(body);
    }
    throw Exception('error fetching data');
  }

  Future<CategoryDartModel> fetchCategoryNewsApi(String category) async {
    String url =
        "https://newsapi.org/v2/everything?q=$category&apiKey=96ee6797ce3d44c88be8d08c9f282b42";
    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print(response.body);
    }
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CategoryDartModel.fromJson(body);
    }
    throw Exception('error fetching data');
  }
}
