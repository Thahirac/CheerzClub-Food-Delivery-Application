
// ignore_for_file: file_names
class Payment {
  Payment({
    this.url,
  });

  String? url;

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
  };
}
