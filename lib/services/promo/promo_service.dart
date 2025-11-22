import 'dart:developer';
import 'dart:convert';
import 'package:Ngoerahsun/utils/repository.dart';
import 'package:http/http.dart' as http;
import 'package:Ngoerahsun/model/promo_model.dart';

class PromoService {
  ResourceRepository repo = ResourceRepository();

  Future<List<Promo>> fetchPromos() async {
    try {
      final String url = repo.getPromosUrl;
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['status'] == true && decoded['data'] != null) {
          List data = decoded['data'];
          return data.map((e) => Promo.fromJson(e)).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (e) {
      log("PromoService: Exception fetchPromos -> $e");
      return [];
    }
  }
}
