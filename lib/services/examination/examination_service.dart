import 'dart:convert';
import 'dart:developer';
import 'package:ngoerahsun/model/examination_model.dart';
import 'package:ngoerahsun/services/preferences/user_preferences.dart';
import 'package:ngoerahsun/utils/repository.dart';
import 'package:http/http.dart' as http;

class ExaminationService {
  ResourceRepository repo = ResourceRepository();

  Future<List<Examination>> fetchExaminations() async {
    final String baseUrl = repo.getExaminationsUrl;
    final user = await UserPreferences.getUser();
    final nik = user?.nik;
    final response = await http.get(Uri.parse("$baseUrl/$nik"));
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic> && decoded['results'] is List) {
        return (decoded['results'] as List)
            .map((e) => Examination.fromJson(e))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to load examinations");
    }
  }

  
  Future<List<String>> fetchMenus() async {
    try {
      final uri = Uri.parse(repo.getExaminationMenuUrl);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> menu = decoded['data']?['menu'] ?? [];
        return menu.map((e) => e.toString()).toList();
      } else {
        log("❌ Failed to fetch menus: ${response.statusCode}");
        log("Body: ${response.body}");
        return [];
      }
    } catch (e) {
      log("🔥 Error fetch menus: $e");
      return [];
    }
  }

}
