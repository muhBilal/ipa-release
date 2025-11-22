class ArticleModel {
  final int id;
  final AttributesModel attributes;

  ArticleModel({
    required this.id,
    required this.attributes,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      attributes: AttributesModel.fromJson(json['attributes'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': attributes.toJson(),
    };
  }
}

class AttributesModel {
  final String title;
  final DateTime publishDate;
  final List<ContentBlockModel> content;
  final String slug;
  final String shortDescription;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;
  final ThumbnailModel? thumbnail;

  AttributesModel({
    required this.title,
    required this.publishDate,
    required this.content,
    required this.slug,
    required this.shortDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    this.thumbnail,
  });

  factory AttributesModel.fromJson(Map<String, dynamic> json) {
    return AttributesModel(
      title: json['Title']?.toString() ?? '',
      publishDate:
          DateTime.tryParse(json['PublishDate'] ?? '') ?? DateTime(1970),
      content: (json['Content'] as List<dynamic>?)
              ?.map((e) => ContentBlockModel.fromJson(e))
              .toList() ??
          [],
      slug: json['Slug']?.toString() ?? '',
      shortDescription: json['ShortDescription']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime(1970),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime(1970),
      publishedAt:
          DateTime.tryParse(json['publishedAt'] ?? '') ?? DateTime(1970),
      thumbnail: json['Thumbnail'] != null
          ? ThumbnailModel.fromJson(json['Thumbnail'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'PublishDate': publishDate.toIso8601String(),
      'Content': content.map((e) => e.toJson()).toList(),
      'Slug': slug,
      'ShortDescription': shortDescription,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'publishedAt': publishedAt.toIso8601String(),
      'Thumbnail': thumbnail?.toJson(),
    };
  }
}

class ContentBlockModel {
  final String type;
  final List<ContentChildModel> children;

  ContentBlockModel({
    required this.type,
    required this.children,
  });

  factory ContentBlockModel.fromJson(Map<String, dynamic> json) {
    return ContentBlockModel(
      type: json['type']?.toString() ?? '',
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => ContentChildModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'children': children.map((e) => e.toJson()).toList(),
    };
  }
}

class ContentChildModel {
  final String text;
  final String type;

  ContentChildModel({
    required this.text,
    required this.type,
  });

  factory ContentChildModel.fromJson(Map<String, dynamic> json) {
    return ContentChildModel(
      text: json['text']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': type,
    };
  }
}

/// Thumbnail models
class ThumbnailModel {
  final ThumbnailDataModel? data;

  ThumbnailModel({this.data});

  factory ThumbnailModel.fromJson(Map<String, dynamic> json) {
    return ThumbnailModel(
      data: json['data'] != null
          ? ThumbnailDataModel.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class ThumbnailDataModel {
  final int id;
  final ThumbnailAttributesModel? attributes;

  ThumbnailDataModel({
    required this.id,
    this.attributes,
  });

  factory ThumbnailDataModel.fromJson(Map<String, dynamic> json) {
    return ThumbnailDataModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      attributes: json['attributes'] != null
          ? ThumbnailAttributesModel.fromJson(json['attributes'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': attributes?.toJson(),
    };
  }
}

class ThumbnailAttributesModel {
  final String? name;
  final String? url;
  final int? width;
  final int? height;
  final ThumbnailFormatsModel? formats;

  ThumbnailAttributesModel({
    this.name,
    this.url,
    this.width,
    this.height,
    this.formats,
  });

  factory ThumbnailAttributesModel.fromJson(Map<String, dynamic> json) {
    return ThumbnailAttributesModel(
      name: json['name']?.toString(),
      url: json['url']?.toString(),
      width: json['width'] is int ? json['width'] as int : null,
      height: json['height'] is int ? json['height'] as int : null,
      formats: json['formats'] != null
          ? ThumbnailFormatsModel.fromJson(json['formats'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'width': width,
      'height': height,
      'formats': formats?.toJson(),
    };
  }
}

class ThumbnailFormatsModel {
  final FormatDetailModel? small;
  final FormatDetailModel? medium;
  final FormatDetailModel? thumbnail;

  ThumbnailFormatsModel({this.small, this.medium, this.thumbnail});

  factory ThumbnailFormatsModel.fromJson(Map<String, dynamic> json) {
    return ThumbnailFormatsModel(
      small: json['small'] != null
          ? FormatDetailModel.fromJson(json['small'])
          : null,
      medium: json['medium'] != null
          ? FormatDetailModel.fromJson(json['medium'])
          : null,
      thumbnail: json['thumbnail'] != null
          ? FormatDetailModel.fromJson(json['thumbnail'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'small': small?.toJson(),
      'medium': medium?.toJson(),
      'thumbnail': thumbnail?.toJson(),
    };
  }
}

class FormatDetailModel {
  final String? ext;
  final String? url;
  final String? mime;
  final String? name;
  final int? width;
  final int? height;
  final double? size; // dalam KB

  FormatDetailModel({
    this.ext,
    this.url,
    this.mime,
    this.name,
    this.width,
    this.height,
    this.size,
  });

  factory FormatDetailModel.fromJson(Map<String, dynamic> json) {
    return FormatDetailModel(
      ext: json['ext']?.toString(),
      url: json['url']?.toString(),
      mime: json['mime']?.toString(),
      name: json['name']?.toString(),
      width: json['width'] is int ? json['width'] as int : null,
      height: json['height'] is int ? json['height'] as int : null,
      size: json['size'] is num ? (json['size'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ext': ext,
      'url': url,
      'mime': mime,
      'name': name,
      'width': width,
      'height': height,
      'size': size,
    };
  }
}
