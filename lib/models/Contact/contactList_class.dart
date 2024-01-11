// ignore_for_file: file_names

// class Data {
//   Data({
//     this.available,
//     this.unavailable,
//   });
//
//   List<Available>? available;
//   List<Unavailable>? unavailable;
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     available: json["available"] == null ? null : List<Available>.from(json["available"].map((x) => Available.fromJson(x))),
//     unavailable: json["unavailable"] == null ? null : List<Unavailable>.from(json["unavailable"].map((x) => Unavailable.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "available": available == null ? null : List<dynamic>.from(available!.map((x) => x)),
//     "unavailable": unavailable == null ? null : List<dynamic>.from(unavailable!.map((x) => x.toJson())),
//   };
// }
//
// class Available {
//   Available({
//     this.name,
//     this.phone,
//   });
//
//   String? name;
//   String? phone;
//
//   factory Available.fromJson(Map<String, dynamic> json) => Available(
//     name: json["name"] == null ? null : json["name"],
//     phone: json["phone"] == null ? null : json["phone"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name == null ? null : name,
//     "phone": phone == null ? null : phone,
//   };
// }
//
// class Unavailable {
//   Unavailable({
//     this.name,
//     this.phone,
//   });
//
//   String? name;
//   String? phone;
//
//   factory Unavailable.fromJson(Map<String, dynamic> json) => Unavailable(
//     name: json["name"] == null ? null : json["name"],
//     phone: json["phone"] == null ? null : json["phone"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name == null ? null : name,
//     "phone": phone == null ? null : phone,
//   };
// }

// To parse this JSON data, do
//
//     final contact = contactFromJson(jsonString);

import 'dart:convert';

ContactModel contactFromJson(String str) => ContactModel.fromJson(json.decode(str));

String contactToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel {
  ContactModel({
    this.status,
    this.message,
    this.data,
  });

  int? status;
  String? message;
  Data? data;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
    "data": data == null ? null : data!.toJson(),
  };
}

class Data {
  Data({
    this.available,
    this.unavailable,
  });

  List<Available>? available;
  List<Available>? unavailable;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    available: json["available"] == null ? null : List<Available>.from(json["available"].map((x) => Available.fromJson(x))),
    unavailable: json["unavailable"] == null ? null : List<Available>.from(json["unavailable"].map((x) => Available.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "available": available == null ? null : List<dynamic>.from(available!.map((x) => x.toJson())),
    "unavailable": unavailable == null ? null : List<dynamic>.from(unavailable!.map((x) => x.toJson())),
  };
}

class Available {
  Available({
    this.name,
    this.phone,
  });

  String? name;
  String? phone;

  factory Available.fromJson(Map<String, dynamic> json) => Available(
    name: json["name"] == null ? null : json["name"],
    phone: json["phone"] == null ? null : json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "phone": phone == null ? null : phone,
  };
}
