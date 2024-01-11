// ignore_for_file: file_names

class RestourentView {
  Restaurant? restaurant;
  List<MainCategories>? mainCategories;
  int? cartCount;

  RestourentView({this.restaurant, this.mainCategories, this.cartCount});

  RestourentView.fromJson(Map<String, dynamic> json) {
    restaurant = json['restaurant'] != null
        ? new Restaurant.fromJson(json['restaurant'])
        : null;
    if (json['main_categories'] != null) {
      mainCategories = [];
      json['main_categories'].forEach((v) {
        mainCategories!.add(new MainCategories.fromJson(v));
      });
    }
    cartCount = json['cart_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.restaurant != null) {
      data['restaurant'] = this.restaurant!.toJson();
    }
    if (this.mainCategories != null) {
      data['main_categories'] =
          this.mainCategories!.map((v) => v.toJson()).toList();
    }
    data['cart_count'] = this.cartCount;
    return data;
  }
}

class Restaurant {
  int? id;
  String? name;
  String? email;
  String? address;
  String? city;
  String? country;
  String? userType;
  String? profilePhotoUrl;
  int? followers;
  int? followings;

  Restaurant(
      {this.id,
      this.name,
      this.email,
      this.address,
      this.city,
      this.country,
      this.userType,
      this.profilePhotoUrl,
      this.followers,
      this.followings});

  Restaurant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
    userType = json['user_type'];
    profilePhotoUrl = json['profile_photo_url'];
    followers = json['followers'];
    followings = json['followings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['address'] = this.address;
    data['city'] = this.city;
    data['country'] = this.country;
    data['user_type'] = this.userType;
    data['profile_photo_url'] = this.profilePhotoUrl;
    data['followers'] = this.followers;
    data['followings'] = this.followings;
    return data;
  }
}

class MainCategories {
  int? id;
  String? name;
  List<dynamic>? subCategories;

  MainCategories({this.id, this.name, this.subCategories});

  MainCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['sub_categories'] != null) {
      subCategories = [];
      json['sub_categories'].forEach((v) {
        subCategories!.add(new SubCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.subCategories != null) {
      data['sub_categories'] =
          this.subCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategories {
  int? id;
  String? name;
  int? mainCategoryId;

  SubCategories({this.id, this.name, this.mainCategoryId});

  SubCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    mainCategoryId = json['main_category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['main_category_id'] = this.mainCategoryId;
    return data;
  }
}
