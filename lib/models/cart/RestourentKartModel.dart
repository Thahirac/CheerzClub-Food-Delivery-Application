// ignore_for_file: file_names

class RestourentKart {
  RestourentKart({
    this.cart,
    this.subtotal,
    this.transactionFee,
    this.vat,
    this.total,
  });

  List<Cart>? cart;
  dynamic subtotal;
  dynamic transactionFee;
  dynamic vat;
  dynamic total;


  RestourentKart.fromJson(Map<String, dynamic> json) {
    if (json['cart'] != null) {
      cart = [];
      json['cart'].forEach((v) {
        cart!.add(new Cart.fromJson(v));
      });
    }
    subtotal = json['subtotal'];
    transactionFee=json['transaction_fee'];
    vat = json['vat'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cart != null) {
      data['cart'] = this.cart!.map((v) => v.toJson()).toList();
    }
    data['subtotal'] = this.subtotal;
    data['transaction_fee']=this.transactionFee;
    data['vat'] = this.vat;
    data['total'] = this.total;
    return data;
  }
}


//   factory RestourentKart.fromJson(Map<String, dynamic> json) => RestourentKart(
//         cart: List<Cart>.from(json["cart"].map((x) => Cart.fromJson(x))),
//         subtotal: json["subtotal"],
//         transactionFee: json["transaction_fee"],
//         vat: Map.from(json["vat"])
//             .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
//         total: json["total"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "cart": List<dynamic>.from(cart!.map((x) => x.toJson())),
//         "subtotal": subtotal,
//         "transaction_fee": transactionFee,
//         "vat": Map.from(vat!).map((k, v) => MapEntry<String, dynamic>(k, v)),
//         "total": total,
//       };
// }

// class Cart {
//   Cart({
//     this.id,
//     this.productId,
//     this.orderType,
//     this.quantity,
//     this.name,
//     this.quantityText,
//     this.itemPrice,
//     this.price,
//   });
//
//   int? id;
//   int? productId;
//   String? orderType;
//   int? quantity;
//   String? name;
//   String? quantityText;
//   double? itemPrice;
//   double? price;
//
//   factory Cart.fromJson(Map<String, dynamic> json) => Cart(
//     id: json["id"],
//     productId: json["product_id"],
//     orderType: json["order_type"] == null ? null : json["order_type"],
//     quantity: json["quantity"],
//     name: json["name"],
//     quantityText: json["quantity_text"],
//     itemPrice: json["item_price"],
//     price: json["price"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "product_id": productId,
//     "order_type": orderType == null ? null : orderType,
//     "quantity": quantity,
//     "name": name,
//     "quantity_text": quantityText,
//     "item_price": itemPrice,
//     "price": price,
//   };
// }

class Cart {
  Cart(
      {this.id,
        this.productId,
        this.orderType,
        this.quantity,
        this.name,
        this.quantityText,
        this.itemPrice,
        this.price,});


  int? id;
  int? productId;
  String? orderType;
  int? quantity;
  String? name;
  String? quantityText;
  dynamic itemPrice;
  dynamic price;



  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    orderType = json['order_type'];
    quantity = json['quantity'];
    name = json['name'];
    quantityText=json['quantity_text'];
    itemPrice = json['item_price'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['order_type'] = this.orderType;
    data['quantity'] = this.quantity;
    data['name'] = this.name;
    data['quantity_text']= this.quantityText;
    data['item_price'] = this.itemPrice;
    data['price'] = this.price;
    return data;
  }
}
