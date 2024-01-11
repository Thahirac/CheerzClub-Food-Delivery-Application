// ignore_for_file: file_names

class Data {
  Data({
    this.restaurant,
    this.order,
    this.orderData,
    this.orderedUser,
  });

  Restaurant? restaurant;
  Order? order;
  OrderData? orderData;
  OrderedUser? orderedUser;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    restaurant: Restaurant.fromJson(json["restaurant"]),
    order: Order.fromJson(json["order"]),
    orderData: OrderData.fromJson(json["order_data"]),
    orderedUser: OrderedUser.fromJson(json["ordered_user"]),
  );

  Map<String, dynamic> toJson() => {
    "restaurant": restaurant?.toJson(),
    "order": order?.toJson(),
    "order_data": orderData?.toJson(),
    "ordered_user": orderedUser?.toJson(),
  };
}

class Restaurant {
  Restaurant({
    this.id,
    this.name,
    this.email,
    this.address,
    this.city,
    this.zip,
    this.profilePhotoUrl,
    this.followers,
    this.followings,
  });

  int? id;
  String? name;
  String? email;
  String? address;
  String? city;
  dynamic zip;
  String? profilePhotoUrl;
  int? followers;
  int? followings;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    address: json["address"],
    city: json["city"],
    zip: json["zip"],
    profilePhotoUrl: json["profile_photo_url"],
    followers: json["followers"],
    followings: json["followings"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "address": address,
    "city": city,
    "zip": zip,
    "profile_photo_url": profilePhotoUrl,
    "followers": followers,
    "followings": followings,
  };
}

class Order {
  Order({
    this.id,
    this.price,
    this.userSecret,
    this.deliveryDate,
    this.deliveryType,
    this.name,
    this.dialcode,
    this.phone,
    this.message,
    this.note,
    this.createdAt,
    this.restaurantId,
    this.qr,
  });

  int? id;
  double? price;
  String? userSecret;
  DateTime? deliveryDate;
  int? deliveryType;
  String? name;
  String? dialcode;
  String? phone;
  String? message;
  dynamic note;
  DateTime? createdAt;
  int? restaurantId;
  String? qr;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    price: json["price"].toDouble(),
    userSecret: json["user_secret"],
    deliveryDate: DateTime.parse(json["delivery_date"]),
    deliveryType: json["delivery_type"],
    name: json["name"],
    dialcode: json["dialcode"],
    phone: json["phone"],
    message: json["message"],
    note: json["note"],
    createdAt: DateTime.parse(json["created_at"]),
    restaurantId: json["restaurant_id"],
    qr: json["qr"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "price": price,
    "user_secret": userSecret,
    "delivery_date": deliveryDate,
    "delivery_type": deliveryType,
    "name": name,
    "dialcode": dialcode,
    "phone": phone,
    "message": message,
    "note": note,
    "created_at": createdAt,
    "restaurant_id": restaurantId,
    "qr": qr,
  };
}

class OrderData {
  OrderData({
    this.orderitems,
    this.subtotal,
    this.transactionFee,
    this.vat,
    this.total,
  });

  List<Orderitem>? orderitems;
  double? subtotal;
  double? transactionFee;
  Vat? vat;
  double? total;

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
    orderitems: List<Orderitem>.from(json["orderitems"].map((x) => Orderitem.fromJson(x))),
    subtotal: json["subtotal"].toDouble(),
    transactionFee: json["transaction_fee"].toDouble(),
    vat: Vat.fromJson(json["vat"]),
    total: json["total"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "orderitems": List<dynamic>.from(orderitems!.map((x) => x.toJson())),
    "subtotal": subtotal,
    "transaction_fee": transactionFee,
    "vat": vat!.toJson(),
    "total": total,
  };
}

class Orderitem {
  Orderitem({
    this.id,
    this.productName,
    this.productId,
    this.orderId,
    this.vat,
    this.price,
    this.quantity,
    this.orderType,
    this.createdAt,
    this.updatedAt,
    this.quantityText,
    this.itemPrice,
  });

  int? id;
  String? productName;
  int? productId;
  int? orderId;
  int? vat;
  dynamic price;
  int? quantity;
  String? orderType;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? quantityText;
  dynamic itemPrice;

  factory Orderitem.fromJson(Map<String, dynamic> json) => Orderitem(
    id: json["id"],
    productName: json["product_name"],
    productId: json["product_id"],
    orderId: json["order_id"],
    vat: json["vat"],
    price: json["price"],
    quantity: json["quantity"],
    orderType: json["order_type"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    quantityText: json["quantity_text"],
    itemPrice: json["item_price"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_name": productName,
    "product_id": productId,
    "order_id": orderId,
    "vat": vat,
    "price": price,
    "quantity": quantity,
    "order_type": orderType,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "quantity_text": quantityText,
    "item_price": itemPrice,
  };
}

class Vat {
  Vat({
    this.the21,
  });

  double? the21;

  factory Vat.fromJson(Map<String, dynamic> json) => Vat(
    the21: json["21"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "21": the21,
  };
}

class OrderedUser {
  OrderedUser({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.profilePhotoUrl,
    this.followers,
    this.followings,
    this.city,
    this.zip,
  });

  int? id;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? profilePhotoUrl;
  int? followers;
  int? followings;
  String? city;
  String? zip;

  factory OrderedUser.fromJson(Map<String, dynamic> json) => OrderedUser(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"] == null ? null : json["phone"],
    address: json["address"],
    profilePhotoUrl: json["profile_photo_url"],
    followers: json["followers"],
    followings: json["followings"],
    city: json["city"] == null ? null : json["city"],
    zip: json["zip"] == null ? null : json["zip"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone == null ? null : phone,
    "address": address,
    "profile_photo_url": profilePhotoUrl,
    "followers": followers,
    "followings": followings,
    "city": city == null ? null : city,
    "zip": zip == null ? null : zip,
  };
}
