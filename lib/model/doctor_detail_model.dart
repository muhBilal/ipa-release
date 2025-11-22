import 'dart:convert';

DoctorResponse doctorResponseFromJson(String str) =>
    DoctorResponse.fromJson(json.decode(str));

String doctorResponseToJson(DoctorResponse data) => json.encode(data.toJson());

class DoctorResponse {
  Doctor? data;
  Map<String, dynamic>? meta;

  DoctorResponse({
    this.data,
    this.meta,
  });

  factory DoctorResponse.fromJson(Map<String, dynamic> json) => DoctorResponse(
        data: json["data"] != null ? Doctor.fromJson(json["data"]) : null,
        meta: json["meta"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "meta": meta,
      };
}

class Doctor {
  int? id;
  DoctorAttributes? attributes;

  Doctor({this.id, this.attributes});

  factory Doctor.fromJson(Map<String, dynamic> json) => Doctor(
        id: json["id"],
        attributes: json["attributes"] != null
            ? DoctorAttributes.fromJson(json["attributes"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class DoctorAttributes {
  String? name;
  String? imageUrl;
  String? specialization;
  String? createdAt;
  String? updatedAt;
  String? publishedAt;
  String? idDoctor;
  String? slug;
  int? order;
  String? prefixTitle;
  String? suffixTitle;
  List<Education>? education;
  List<Certification>? certification;
  ImageData? image;
  List<ScheduleItem>? schedule;

  DoctorAttributes({
    this.name,
    this.imageUrl,
    this.specialization,
    this.createdAt,
    this.updatedAt,
    this.publishedAt,
    this.idDoctor,
    this.slug,
    this.order,
    this.prefixTitle,
    this.suffixTitle,
    this.education,
    this.certification,
    this.image,
    this.schedule,
  });

  factory DoctorAttributes.fromJson(Map<String, dynamic> json) =>
      DoctorAttributes(
        name: json["Name"],
        imageUrl: json["Imageurl"],
        specialization: json["Specialization"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        publishedAt: json["publishedAt"],
        idDoctor: json["idDoctor"],
        slug: json["slug"],
        order: json["order"],
        prefixTitle: json["Prefix_Title"],
        suffixTitle: json["Suffix_Title"],
        education: json["Education"] != null
            ? List<Education>.from(
                json["Education"].map((x) => Education.fromJson(x)))
            : [],
        certification: json["Certification"] != null
            ? List<Certification>.from(
                json["Certification"].map((x) => Certification.fromJson(x)))
            : [],
        image: json["Image"] != null
            ? ImageData.fromJson(json["Image"]["data"])
            : null,
        schedule: json["Schedule"] != null
            ? List<ScheduleItem>.from(
                json["Schedule"].map((x) => ScheduleItem.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Imageurl": imageUrl,
        "Specialization": specialization,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "publishedAt": publishedAt,
        "idDoctor": idDoctor,
        "slug": slug,
        "order": order,
        "Prefix_Title": prefixTitle,
        "Suffix_Title": suffixTitle,
        "Education": education != null
            ? List<dynamic>.from(education!.map((x) => x.toJson()))
            : [],
        "Certification": certification != null
            ? List<dynamic>.from(certification!.map((x) => x.toJson()))
            : [],
        "Image": image?.toJson(),
        "Schedule": schedule != null
            ? List<dynamic>.from(schedule!.map((x) => x.toJson()))
            : [],
      };
}

class ScheduleItem {
  int? id;
  String? day;
  String? from;
  String? to;

  ScheduleItem({this.id, this.day, this.from, this.to});

  factory ScheduleItem.fromJson(Map<String, dynamic> json) => ScheduleItem(
        id: json['id'],
        day: json['day'],
        from: json['from'],
        to: json['to'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'day': day,
        'from': from,
        'to': to,
      };
}

class Education {
  int? id;
  String? title;
  String? year;
  String? description;

  Education({
    this.id,
    this.title,
    this.year,
    this.description,
  });

  factory Education.fromJson(Map<String, dynamic> json) => Education(
        id: json["id"],
        title: json["Title"],
        year: json["Year"]?.toString(),
        description: json["Description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Title": title,
        "Year": year,
        "Description": description,
      };
}

class Certification {
  int? id;
  String? title;

  Certification({
    this.id,
    this.title,
  });

  factory Certification.fromJson(Map<String, dynamic> json) => Certification(
        id: json["id"],
        title: json["Title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Title": title,
      };
}

class ImageData {
  int? id;
  ImageAttributes? attributes;

  ImageData({this.id, this.attributes});

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
        id: json["id"],
        attributes: json["attributes"] != null
            ? ImageAttributes.fromJson(json["attributes"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attributes": attributes?.toJson(),
      };
}

class ImageAttributes {
  String? name;
  int? width;
  int? height;
  String? url;
  ImageFormats? formats;

  ImageAttributes({
    this.name,
    this.width,
    this.height,
    this.url,
    this.formats,
  });

  factory ImageAttributes.fromJson(Map<String, dynamic> json) =>
      ImageAttributes(
        name: json["name"],
        width: json["width"],
        height: json["height"],
        url: json["url"],
        formats: json["formats"] != null
            ? ImageFormats.fromJson(json["formats"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "width": width,
        "height": height,
        "url": url,
        "formats": formats?.toJson(),
      };
}

class ImageFormats {
  ImageFormat? small;
  ImageFormat? medium;
  ImageFormat? thumbnail;

  ImageFormats({this.small, this.medium, this.thumbnail});

  factory ImageFormats.fromJson(Map<String, dynamic> json) => ImageFormats(
        small:
            json["small"] != null ? ImageFormat.fromJson(json["small"]) : null,
        medium: json["medium"] != null
            ? ImageFormat.fromJson(json["medium"])
            : null,
        thumbnail: json["thumbnail"] != null
            ? ImageFormat.fromJson(json["thumbnail"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "small": small?.toJson(),
        "medium": medium?.toJson(),
        "thumbnail": thumbnail?.toJson(),
      };
}

class ImageFormat {
  String? url;
  int? width;
  int? height;
  double? size;

  ImageFormat({this.url, this.width, this.height, this.size});

  factory ImageFormat.fromJson(Map<String, dynamic> json) => ImageFormat(
        url: json["url"],
        width: json["width"],
        height: json["height"],
        size: json["size"] != null
            ? double.tryParse(json["size"].toString())
            : null,
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "width": width,
        "height": height,
        "size": size,
      };
}
