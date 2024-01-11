class Response {
  int? status;
  dynamic data;
  int? count;
  String? message;

  Response({this.status, this.data, this.count, this.message});

  Response.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'];
    count = json['count'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['count'] = this.count;
    data['message'] = this.message;
    return data;
  }
}
