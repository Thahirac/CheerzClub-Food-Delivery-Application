// ignore_for_file: file_names

// class Orders {
//   Orders({
//     this.orders,
//   });
//
//   List<MyGreetings>? orders;
//
//
//   Orders.fromJson(Map<String, dynamic> json) {
//     if (json['orders'] != null) {
//       orders = [];
//       json['orders'].forEach((v) {
//         orders!.add(MyGreetings.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.orders != null) {
//       data['orders'] = this.orders!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }


  // factory Orders.fromJson(Map<String, dynamic> json) => Orders(
  //   orders: List<MyGreetings>.from(json["orders"].map((x) => MyGreetings.fromJson(x))),
  // );
  //
  // Map<String, dynamic> toJson() => {
  //   "orders": List<dynamic>.from(orders!.map((x) => x.toJson())),
  // };


//}



class MyGreetings {
  int? id;
  int? userId;
  int? restaurantId;
  int? paymentId;
  double? price;
  String? userSecret;
  String? restaurantSecret;
  String? deliveryDate;
  int? deliveryType;
  String? name;
  String? dialcode;
  String? phone;
  dynamic dialcode2;
  dynamic phone2;
  dynamic dialcode3;
  dynamic phone3;
  String? message;
  dynamic note;
  dynamic fileName;
  dynamic greetingKey;
  int? status;
  int? paymentStatus;
  String? createdAt;
  String? updatedAt;



  MyGreetings(
      {this.id,
      this.userId,
      this.restaurantId,
      this.paymentId,
      this.price,
      this.userSecret,
      this.restaurantSecret,
      this.deliveryDate,
      this.deliveryType,
      this.name,
      this.dialcode,
      this.phone,
      this.dialcode2,
      this.phone2,
      this.dialcode3,
      this.phone3,
      this.message,
      this.note,
      this.fileName,
      this.greetingKey,
      this.status,
      this.paymentStatus,
      this.createdAt,
      this.updatedAt});

  MyGreetings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    restaurantId = json['restaurant_id'];
    paymentId = json['payment_id'];
    price = json['price'];
    userSecret = json['user_secret'];
    restaurantSecret = json['restaurant_secret'];
    deliveryDate = json['delivery_date'];
    deliveryType = json['delivery_type'];
    name = json['name'];
    dialcode = json['dialcode'];
    phone = json['phone'];
    dialcode2 = json['dialcode2'];
    phone2 = json['phone2'];
    dialcode3 = json['dialcode3'];
    phone3 = json['phone3'];
    message = json['message'];
    note = json['note'];
    fileName = json['file_name'];
    greetingKey = json['greeting_key'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['restaurant_id'] = this.restaurantId;
    data['payment_id'] = this.paymentId;
    data['price'] = this.price;
    data['user_secret'] = this.userSecret;
    data['restaurant_secret'] = this.restaurantSecret;
    data['delivery_date'] = this.deliveryDate;
    data['delivery_type'] = this.deliveryType;
    data['name'] = this.name;
    data['dialcode'] = this.dialcode;
    data['phone'] = this.phone;
    data['dialcode2'] = this.dialcode2;
    data['phone2'] = this.phone2;
    data['dialcode3'] = this.dialcode3;
    data['phone3'] = this.phone3;
    data['message'] = this.message;
    data['note'] = this.note;
    data['file_name'] = this.fileName;
    data['greeting_key'] = this.greetingKey;
    data['status'] = this.status;
    data['payment_status'] = this.paymentStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}











/*


class Orders {
  Orders({
    this.orders,
  });

  List<MyGreetings>? orders;

  factory Orders.fromJson(Map<String, dynamic> json) => Orders(
    orders: List<MyGreetings>.from(json["orders"].map((x) => MyGreetings.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "orders": List<dynamic>.from(orders!.map((x) => x.toJson())),
  };
}

class MyGreetings {
  MyGreetings({
    this.id,
    this.userId,
    this.restaurantId,
    this.paymentId,
    this.price,
    this.userSecret,
    this.restaurantSecret,
    this.deliveryDate,
    this.deliveryType,
    this.name,
    this.dialcode,
    this.phone,
    this.dialcode2,
    this.phone2,
    this.dialcode3,
    this.phone3,
    this.message,
    this.note,
    this.fileName,
    this.greetingKey,
    this.status,
    this.paymentStatus,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  int? restaurantId;
  int? paymentId;
  double? price;
  String? userSecret;
  String? restaurantSecret;
  DateTime? deliveryDate;
  int? deliveryType;
  String? name;
  String? dialcode;
  String? phone;
  dynamic dialcode2;
  dynamic phone2;
  dynamic dialcode3;
  dynamic phone3;
  String? message;
  dynamic note;
  dynamic fileName;
  dynamic greetingKey;
  int? status;
  int? paymentStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory MyGreetings.fromJson(Map<String, dynamic> json) => MyGreetings(
    id: json["id"],
    userId: json["user_id"],
    restaurantId: json["restaurant_id"],
    paymentId: json["payment_id"],
    price: json["price"].toDouble(),
    userSecret: json["user_secret"],
    restaurantSecret: json["restaurant_secret"],
    deliveryDate: DateTime.parse(json["delivery_date"]),
    deliveryType: json["delivery_type"],
    name: json["name"],
    dialcode: json["dialcode"],
    phone: json["phone"],
    dialcode2: json["dialcode2"],
    phone2: json["phone2"],
    dialcode3: json["dialcode3"],
    phone3: json["phone3"],
    message: json["message"],
    note: json["note"],
    fileName: json["file_name"],
    greetingKey: json["greeting_key"],
    status: json["status"],
    paymentStatus: json["payment_status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "restaurant_id": restaurantId,
    "payment_id": paymentId,
    "price": price,
    "user_secret": userSecret,
    "restaurant_secret": restaurantSecret,
    "delivery_date": deliveryDate,
    "delivery_type": deliveryType,
    "name": name,
    "dialcode": dialcode,
    "phone": phone,
    "dialcode2": dialcode2,
    "phone2": phone2,
    "dialcode3": dialcode3,
    "phone3": phone3,
    "message": message,
    "note": note,
    "file_name": fileName,
    "greeting_key": greetingKey,
    "status": status,
    "payment_status": paymentStatus,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

*/
