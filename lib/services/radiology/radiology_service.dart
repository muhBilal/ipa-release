import 'dart:convert';
import 'dart:developer';
import 'package:ngoerahsun/services/preferences/language_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:ngoerahsun/utils/repository.dart';
import 'package:ngoerahsun/model/radiology_menu.dart';

class RadiologyService {
  final ResourceRepository _repo = ResourceRepository();

  Future<List<RadiologyMenu>> fetchRadiologyMenu() async {
    final langCode = await LanguagePreferences.getLanguageCode() ?? 'id';
    final url = _repo.getRadiologyMenuUrl;
    final uri = Uri.parse('$url?lang=$langCode');
    log("debug lang code radiology : $langCode");
    final resp = await http.get(uri).timeout(const Duration(seconds: 15));
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final body = resp.body;
      if (body.isEmpty) return [];
      final decoded = json.decode(body);
      dynamic dataNode = decoded;
      if (decoded is Map<String, dynamic>) {
        if (decoded.containsKey('data') && decoded['data'] is List) {
          dataNode = decoded['data'];
        } else if (decoded.containsKey('result') && decoded['result'] is List) {
          dataNode = decoded['result'];
        }
      }
      if (dataNode is List) {
        return RadiologyMenu.listFromJson(dataNode);
      }
      return [];
    } else {
      throw Exception('Radiology menu request failed: ${resp.statusCode}');
    }
  }
}
