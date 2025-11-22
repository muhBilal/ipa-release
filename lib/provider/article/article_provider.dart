import 'dart:developer';
import 'package:Ngoerahsun/services/article/article_service.dart';
import 'package:flutter/foundation.dart';

import 'package:Ngoerahsun/model/article_model.dart';

class ArticleProvider with ChangeNotifier {
  final ArticleService _articleService = ArticleService();

  List<ArticleModel> _articles = [];
  List<ArticleModel> get articles => _articles;

  bool _isLoadingArticles = false;
  bool get isLoadingArticles => _isLoadingArticles;

  ArticleModel? _articleDetail;
  ArticleModel? get articleDetail => _articleDetail;

  bool _isLoadingDetail = false;
  bool get isLoadingDetail => _isLoadingDetail;

  Future<void> fetchAllArticles({String? search}) async {
    _isLoadingArticles = true;
    notifyListeners();

    try {
      final result = await _articleService.getAllArticles(search: search);
      _articles = result;
    } catch (e) {
      log('fetchAllArticles error: $e');
      _articles = [];
    } finally {
      _isLoadingArticles = false;
      notifyListeners();
    }
  }

  Future<void> fetchArticleBySlug(String slug) async {
    _isLoadingDetail = true;
    notifyListeners();

    try {
      final result = await _articleService.getArticleDetailBySlug(slug);
      _articleDetail = result;
    } catch (e) {
      log('fetchArticleBySlug error: $e');
      _articleDetail = null;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }
}
