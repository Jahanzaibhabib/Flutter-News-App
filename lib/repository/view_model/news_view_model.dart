//import 'package:flutter/material.dart';
import 'package:news_app/Models/category_dart_model.dart';
import 'package:news_app/Models/news_channelHeadlines.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel {
  final _repository = NewsRepository();

  Future<newsChannelHeadlinesmodel> fetchNewChannelHeadlinesApi(
      String source) async {
    final response = await _repository.fetchNewChannelHeadlinesApi(source);
    return response;
  }

  Future<CategoryDartModel> fetchCategoryNewsApi(String category) async {
    final response = await _repository.fetchCategoryNewsApi(category);
    return response;
  }
}
