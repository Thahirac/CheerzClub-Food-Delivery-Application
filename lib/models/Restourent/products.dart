class productsList {
  List<Products>? products;

  productsList({this.products});

  productsList.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  String? name;
  String? description;
  String? remark;
  int? category;
  String? stock;
  int? restaurantId;
  String? imageName;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? categoryName;
  List<dynamic>? priceCategories;

  Products(
      {this.id,
        this.name,
        this.description,
        this.remark,
        this.category,
        this.stock,
        this.restaurantId,
        this.imageName,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.categoryName,
        this.priceCategories});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    remark = json['remark'];
    category = json['category'];
    stock = json['stock'];
    restaurantId = json['restaurant_id'];
    imageName = json['image_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    categoryName = json['category_name'];
    if (json['price_categories'] != null) {
      priceCategories = [];
      json['price_categories'].forEach((v) {
        priceCategories!.add(new PriceCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['remark'] = this.remark;
    data['category'] = this.category;
    data['stock'] = this.stock;
    data['restaurant_id'] = this.restaurantId;
    data['image_name'] = this.imageName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    data['category_name'] = this.categoryName;
    if (this.priceCategories != null) {
      data['price_categories'] =
          this.priceCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PriceCategories {
  int? id;
  String? name;
  int? price;
  int? productId;

  PriceCategories({this.id, this.name, this.price, this.productId});

  PriceCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['product_id'] = this.productId;
    return data;
  }
}