import 'dart:developer';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:ngoerahsun/model/article_model.dart';
import 'package:ngoerahsun/utils/repository.dart';
import 'package:http/http.dart' as http;

class ArticleService {
  final ResourceRepository repo = ResourceRepository();

  static String? bearerToken =
      "1c5144f6be97655d7076b25791a21224c437ac09662dc9231871a01da271a0c913281a060c26207ecf8db301ddab0a2c3f4848ce9d4154cce88071256f7baa0bdb459cdbe9aad8d2cd91a2233802fb074cc103565879b9cd56afc9a9a49a580e24e73312435d77808022fa7fc1f3ce92e6c5faed99c8be4ff28141c26b5b3cce";

  Future<List<ArticleModel>> getAllArticles({
    String? search,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final String baseUrl = repo.getArticlesUrl;

    try {
      final baseUri = Uri.parse(baseUrl);

      final Map<String, String> qp = {
        'populate': 'Thumbnail',
      };

      final q = search?.trim();
      if (q != null && q.isNotEmpty) {
        qp['filters[\$or][0][Title][\$containsi]'] = q;
        qp['filters[\$or][1][ShortDescription][\$containsi]'] = q;
      }

      final uri = Uri(
        scheme: baseUri.scheme,
        host: baseUri.host,
        port: baseUri.hasPort ? baseUri.port : null,
        path: baseUri.path,
        queryParameters: qp,
      );

      final headers = <String, String>{};
      if (bearerToken != null) {
        headers['Authorization'] = 'Bearer $bearerToken';
      }

      final response = await http.get(uri, headers: headers).timeout(timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = await compute(jsonDecode, response.body);
        final List<dynamic> articlesJson = (decoded['data'] as List?) ?? [];

        return articlesJson
            .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        log('getAllArticles failed: HTTP ${response.statusCode} ${response.reasonPhrase}');
        return [];
      }
    } catch (e, st) {
      log('getAllArticles error: $e\n$st');
      return [];
    }
  }

  /// Ambil detail artikel berdasarkan slug
  Future<ArticleModel?> getArticleDetailBySlug(
    String slug, {
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final String baseUrl = repo.getArticlesUrl;

    try {
      final uri = Uri.parse('$baseUrl/$slug').replace(
        queryParameters: {
          'populate': 'Thumbnail',
        },
      );

      final headers = <String, String>{};
      if (bearerToken != null) {
        headers['Authorization'] = 'Bearer $bearerToken';
      }

      final response = await http.get(uri, headers: headers).timeout(timeout);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = await compute(jsonDecode, response.body);
        final dataJson = decoded['data'] as Map<String, dynamic>?;

        if (dataJson == null) return null;

        return ArticleModel.fromJson(dataJson);
      } else {
        log('getArticleDetailBySlug failed: HTTP ${response.statusCode}');
        return null;
      }
    } catch (e, st) {
      log('getArticleDetailBySlug error: $e\n$st');
      return null;
    }
  }
}
