import 'dart:convert';
import 'dart:developer';
import 'package:Ngoerahsun/model/cms/our_facility_model.dart';
import 'package:Ngoerahsun/utils/repository.dart';
import 'package:http/http.dart' as http;

class OurFacilityService {
  final ResourceRepository repo = ResourceRepository();

  Future<List<OurFacilityModel>> getOurFacilities(String lang) async {
    final String url = repo.getOurFacilityUrl;

    try {
      final resp = await http.get(Uri.parse('$url?lang=$lang'));

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final decoded = jsonDecode(resp.body);
        final data = decoded['data'];
        if (data is List) {
          return OurFacilityModel.listFromJson(data);
        } else {
          log('Unexpected data format: ${data.runtimeType}');
          return [];
        }
      } else {
        log('debug fetchOurFacility failed: HTTP ${resp.statusCode}');
        log('debug fetchOurFacility body: ${resp.body}');
        return [];
      }
    } catch (e) {
      log('fetchOurFacility error: $e');
      return [];
    }
  }
}
