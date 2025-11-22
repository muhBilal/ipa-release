class MCUModel {
  final int id;
  final String? categoryName;
  final int parentId;
  final int status;
  final int unitId;
  final bool disableOnline;
  final List<MCUPackage> packages;

  MCUModel({
    required this.id,
    required this.categoryName,
    required this.parentId,
    required this.status,
    required this.unitId,
    required this.disableOnline,
    required this.packages,
  });

  factory MCUModel.fromJson(Map<String, dynamic> json) {
    final packagesRaw = (json['packages'] as List<dynamic>? ?? []);
    final packages = packagesRaw
        .whereType<Map<String, dynamic>>()
        .where((p) => (p['disable_online'] ?? 0) == 1)
        .map((e) => MCUPackage.fromJson(e))
        .toList();

    return MCUModel(
      id: json['id'] ?? 0,
      categoryName: json['category_name'],
      parentId: json['parent_id'] ?? 0,
      status: json['status'] ?? 0,
      unitId: json['unit_id'] ?? 0,
      disableOnline: (json['disable_online'] ?? 0) == 1,
      packages: packages,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category_name': categoryName,
        'parent_id': parentId,
        'status': status,
        'unit_id': unitId,
        'disable_online': disableOnline ? 1 : 0,
        'packages': packages.map((e) => e.toJson()).toList(),
      };

  MCUModel copyWith({
    int? id,
    String? categoryName,
    int? parentId,
    int? status,
    int? unitId,
    bool? disableOnline,
    List<MCUPackage>? packages,
  }) {
    return MCUModel(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
      parentId: parentId ?? this.parentId,
      status: status ?? this.status,
      unitId: unitId ?? this.unitId,
      disableOnline: disableOnline ?? this.disableOnline,
      packages: packages ?? this.packages,
    );
  }

  @override
  String toString() {
    return 'MCUModel(id: $id, categoryName: $categoryName, packages: ${packages.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MCUModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class MCUPackage {
  final int id;
  final String? packageName;
  final String? price;
  final String? packageDesc;
  final bool disableOnline;

  MCUPackage({
    required this.id,
    this.packageName,
    this.price,
    this.packageDesc,
    required this.disableOnline,
  });

  factory MCUPackage.fromJson(Map<String, dynamic> json) {
    return MCUPackage(
      id: json['id'] ?? 0,
      packageName: json['package_name'],
      price: json['price']?.toString(),
      packageDesc: json['package_desc'],
      disableOnline: (json['disable_online'] ?? 0) == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'package_name': packageName,
        'price': price,
        'package_desc': packageDesc,
        'disable_online': disableOnline ? 1 : 0,
      };

  MCUPackage copyWith({
    int? id,
    String? packageName,
    String? price,
    String? packageDesc,
    bool? disableOnline,
  }) {
    return MCUPackage(
      id: id ?? this.id,
      packageName: packageName ?? this.packageName,
      price: price ?? this.price,
      packageDesc: packageDesc ?? this.packageDesc,
      disableOnline: disableOnline ?? this.disableOnline,
    );
  }

  @override
  String toString() {
    return 'MCUPackage(id: $id, packageName: $packageName, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MCUPackage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
