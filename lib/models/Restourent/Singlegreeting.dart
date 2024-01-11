// ignore_for_file: file_names

class DataClass {
  DataClass({
    this.greetings,
  });

  SingleGreetings? greetings;

  factory DataClass.fromJson(Map<String, dynamic> json) => DataClass(
    greetings: SingleGreetings.fromJson(json["greetings"]),
  );

  Map<String, dynamic> toJson() => {
    "greetings": greetings!.toJson(),
  };
}

class SingleGreetings {
  SingleGreetings({
    this.id,
    this.message,
    this.fileName,
    this.greetingPreview,
  });

  int? id;
  String? message;
  dynamic fileName;
  dynamic greetingPreview;

  factory SingleGreetings.fromJson(Map<String, dynamic> json) => SingleGreetings(
    id: json["id"],
    message: json["message"],
    fileName: json["file_name"],
    greetingPreview: json["greeting_preview"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message,
    "file_name": fileName,
    "greeting_preview": greetingPreview,
  };
}
