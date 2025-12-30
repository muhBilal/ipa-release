import 'dart:convert';
import 'dart:developer';
import 'package:ngoerahsun/model/cms/about_us_model.dart';
import 'package:ngoerahsun/utils/repository.dart';
import 'package:http/http.dart' as http;

class AboutUsService {
  final ResourceRepository repo = ResourceRepository();

  Future<List<AboutUsModel>> getAboutUs(String lang) async {
    final String url = repo.getAboutUsUrl; 
    try {
      final resp = await http.get(Uri.parse('$url?lang=$lang'));
      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final decoded = jsonDecode(resp.body);
        final data = decoded['data'];

        if (data is List) {
          return AboutUsModel.listFromJson(data);
        } else {
          log('Unexpected data format: ${data.runtimeType}');
          return [];
        }
      } else {
        log('debug fetchAboutUs failed: HTTP ${resp.statusCode}');
        log('debug fetchAboutUs body: ${resp.body}');
        return [];
      }
    } catch (e) {
      log('fetchAboutUs error: $e');
      return [];
    }
  }
}
