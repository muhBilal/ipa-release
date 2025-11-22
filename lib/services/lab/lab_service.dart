import 'dart:convert';
import 'dart:developer';
import 'package:Ngoerahsun/services/preferences/language_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:Ngoerahsun/utils/repository.dart';
import 'package:Ngoerahsun/model/lab_menu.dart';

class LabService {
  final ResourceRepository _repo = ResourceRepository();

  Future<List<LabMenu>> fetchLabMenu() async {
    final url = _repo.getLabMenuUrl;
    final langCode = await LanguagePreferences.getLanguageCode() ?? 'id';
    final uri = Uri.parse('$url?lang=$langCode');
    final resp = await http.get(uri).timeout(const Duration(seconds: 15));
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      if (resp.body.isEmpty) return [];
      final decoded = json.decode(resp.body);
      dynamic node = decoded;
      if (decoded is Map<String, dynamic>) {
        dynamic candidate = decoded['data'] ?? decoded['result'];
        if (candidate != null) {
          node = candidate;
        }
      }

      if (node is List) {
        return node
            .whereType<dynamic>()
            .map((e) => e is Map<String, dynamic> ? LabMenu.fromJson(e) : null)
            .whereType<LabMenu>()
            .toList();
      }

      if (node is Map<String, dynamic>) {
        final menus = node.values
            .whereType<dynamic>()
            .where((v) => v is Map<String, dynamic>)
            .map((v) => v as Map<String, dynamic>)
            .where((m) => m.containsKey('title') || m.containsKey('kode_jasa'))
            .map((m) => LabMenu.fromJson(m))
            .toList();
        if (menus.isNotEmpty) {
          menus.sort((a, b) => (a.kodeJasa ?? 0).compareTo(b.kodeJasa ?? 0));
          return menus;
        }
      }

      if (decoded is Map<String, dynamic> &&
          (decoded.containsKey('title') || decoded.containsKey('kode_jasa'))) {
        return [LabMenu.fromJson(decoded)];
      }

      return [];
    }
    throw Exception('Lab menu request failed: ${resp.statusCode}');
  }
}
