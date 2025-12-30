import 'dart:convert';
import 'dart:developer';

import 'package:ngoerahsun/model/mcu_model.dart';
import 'package:ngoerahsun/utils/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:ngoerahsun/utils/repository.dart';
import 'package:ngoerahsun/model/wellnessModel.dart';

class PackageService {
  final ResourceRepository repo = ResourceRepository();

  Future<List<WellnessPackage>> fetchWellnessPackage({
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final String url = "${repo.getPackageUrl}/69";
    final uri = Uri.parse(url);
    log("🔗 PackageService: Requesting URL -> $url");
    const headers = <String, String>{
      'Accept': 'application/json',
    };

    try {
      final resp = await http.get(uri, headers: headers).timeout(timeout);

      if (resp.statusCode < 200 || resp.statusCode >= 300) {
        log('[PackageService] HTTP ${resp.statusCode} body: ${resp.body}');
        return <WellnessPackage>[];
      }

      Map<String, dynamic> jsonMap;
      try {
        final decoded = await compute(jsonDecode, resp.body);
        jsonMap =
            decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
      } catch (e) {
        log('[PackageService] JSON decode error: $e');
        return <WellnessPackage>[];
      }

      final raw = jsonMap['response'];
      final List list = (raw is List) ? raw : const [];

      final packages = list
          .whereType<Map<String, dynamic>>()
          .map(_mapToWellnessPackage)
          .toList();

      return packages;
    } catch (e, st) {
      log('[PackageService] fetchWellnessPackage error: $e\n$st');
      return <WellnessPackage>[];
    }
  }

  Future<List<MCUModel>> fetchMCUPackage({
    Duration timeout = const Duration(seconds: 20),
  }) async {
    final String url = "${repo.getPackageUrl}/45";
    final uri = Uri.parse(url);
    log("🔗 PackageService: Requesting MCU URL -> $url");

    const headers = <String, String>{
      'Accept': 'application/json',
    };

    try {
      final resp = await http.get(uri, headers: headers).timeout(timeout);
      log('[PackageService] resp.statusCode: ${resp.statusCode}');
      log("debug body: ${resp.body}");

      if (resp.statusCode < 200 || resp.statusCode >= 300) {
        log('[PackageService] HTTP ${resp.statusCode} body: ${resp.body}');
        return <MCUModel>[];
      }

      Map<String, dynamic> jsonMap;
      try {
        final decoded = await compute(jsonDecode, resp.body);
        jsonMap =
            decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
        log('[PackageService] decoded jsonMap keys: ${jsonMap.keys.toList()}');
      } catch (e) {
        log('[PackageService] JSON decode error: $e');
        return <MCUModel>[];
      }

      final raw = jsonMap['response'];
      final List list = (raw is List) ? raw : const [];
      log('[PackageService] response length: ${list.length}');

      final categories = list
          .whereType<Map<String, dynamic>>()
          .where((m) => (m['disable_online'] ?? 0) == 0)
          .map(_mapToMCU)
          .where((m) => m.packages.isNotEmpty)
          .toList();

      log('[PackageService] MCU categories fetched: ${categories.length}');
      return categories;
    } catch (e, st) {
      log('[PackageService] fetchMCUPackage error: $e\n$st');
      return <MCUModel>[];
    }
  }

  MCUModel _mapToMCU(Map<String, dynamic> m) {
    final packagesRaw = (m['packages'] as List?) ?? const [];
    final packages = packagesRaw
        .whereType<Map<String, dynamic>>()
        .where((p) => (p['disable_online'] ?? 0) == 1)
        .map(_mapToMCUPackage)
        .toList();

    return MCUModel(
      id: _asInt(m['id']) ?? 0,
      categoryName: _asString(m['category_name']),
      parentId: _asInt(m['parent_id']) ?? 0,
      status: _asInt(m['status']) ?? 0,
      unitId: _asInt(m['unit_id']) ?? 0,
      disableOnline: (_asInt(m['disable_online']) ?? 0) == 1,
      packages: packages,
    );
  }

  MCUPackage _mapToMCUPackage(Map<String, dynamic> p) {
    return MCUPackage(
      id: _asInt(p['id']) ?? 0,
      packageName: _asString(p['package_name']),
      packageDesc: _asString(p['package_desc']),
      disableOnline: (_asInt(p['disable_online']) ?? 0) == 1,
      price: _asString(p['price']),
    );
  }

  WellnessPackage _mapToWellnessPackage(Map<String, dynamic> m) {
    final baseUrl = repo.baseUrl;
    final id = _asInt(m['id']);

    final name = _asString(m['name']) ??
        _asString(m['nama']) ??
        _asString(m['title']) ??
        'Paket';

    final description = _asString(m['short_description']) ??
        _asString(m['description']) ??
        _asString(m['deskripsi_singkat']) ??
        '';

    final fullDescription = _asString(m['full_description']) ??
        _asString(m['deskripsi']) ??
        _asString(m['content']) ??
        description;

    final price = _asString(m['price']) ??
        _asString(m['harga']) ??
        _asString(m['amount']) ??
        '';

    final duration = _asString(m['duration']) ?? _asString(m['durasi']) ?? '';

    final iconName = _asString(m['icon']) ??
        _asString(m['image']) ??
        _asString(m['gambar']) ??
        '';

    final icon = iconName.isNotEmpty ? '$baseUrl/uploads/$iconName' : '';

    return WellnessPackage(
      id: id as int,
      name: name,
      description: description,
      fullDescription: fullDescription,
      price: price,
      duration: duration,
      icon: icon,
    );
  }

  IconData _pickIcon({String? code, String? type, required String name}) {
    // final key =
    //     '${(type ?? '').toLowerCase()}|${(code ?? '').toLowerCase()}|${name.toLowerCase()}';

    // if (key.contains('wellness')) return Icons.self_improvement;
    // if (key.contains('anest') || key.contains('anes'))
    //   return Icons.airline_seat_flat;
    // if (key.contains('cardio') || key.contains('jantung'))
    //   return Icons.favorite;
    // if (key.contains('dental') || key.contains('gigi'))
    //   return Icons.medical_services;
    // if (key.contains('skin') || key.contains('derma')) return Icons.spa;

    return Icons.local_hospital;
  }

  String? _asString(dynamic v) {
    if (v == null) return null;
    if (v is String) return v.trim();
    return v.toString();
  }

  int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  bool _asBool01(dynamic v) {
    if (v is bool) return v;
    if (v is num) return v == 0;
    if (v is String) return v == '0' || v.toLowerCase() == 'true';
    return false;
  }
}
