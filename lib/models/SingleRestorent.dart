// ignore_for_file: file_names, unnecessary_this

// ignore_for_file: file_names

// class SingleRestorent {
//   int? _id;
//   String? _name;
//   String? _email;
//   String? _address;
//   String? _city;
//   String? _country;
//   String? _userType;
//   String? _longitude;
//       String? _latitude;
//   String? _profilePhotoUrl;
//   int? _followers;
//   int? _followings;
//
//   SingleRestorent(
//       {int? id,
//       String? name,
//       String? email,
//       String? address,
//       String? city,
//       String? country,
//       String? userType,
//         String? longitude,
//         String? latitude,
//       String? profilePhotoUrl,
//       int? followers,
//       int? followings}) {
//     this._id = id;
//     this._name = name;
//     this._email = email;
//     this._address = address;
//     this._city = city;
//     this._country = country;
//     this._userType = userType;
//     this._latitude = latitude;
//     this._longitude = longitude;
//     this._profilePhotoUrl = profilePhotoUrl;
//     this._followers = followers;
//     this._followings = followings;
//   }
//
//   int get id => _id!;
//   set id(int id) => _id = id;
//   String get name => _name!;
//   set name(String name) => _name = name;
//   String get email => _email!;
//   set email(String email) => _email = email;
//   String get address => _address!;
//   set address(String address) => _address = address;
//   String get city => _city!;
//   set city(String city) => _city = city;
//   String get country => _country!;
//   set country(String country) => _country = country;
//   String get userType => _userType!;
//   set userType(String userType) => _userType = userType;
//
//   String get longitude => _longitude!;
//   set longitude(String longitude) => _longitude = longitude;
//
//   String get latitude => _longitude!;
//   set latitude(String latitude) => _latitude = latitude;
//
//
//   String get profilePhotoUrl => _profilePhotoUrl!;
//   set profilePhotoUrl(String profilePhotoUrl) => _profilePhotoUrl = profilePhotoUrl;
//
//   int get followers => _followers!;
//   set followers(int followers) => _followers = followers;
//
//   int get followings => _followings!;
//   set followings(int followings) => _followings = followings;
//
//   SingleRestorent.fromJson(Map<String, dynamic> json) {
//     _id = json['id'];
//     _name = json['name'];
//     _email = json['email'];
//     _address = json['address'];
//     _city = json['city'];
//     _country = json['country'];
//     _userType = json['user_type'];
//     _longitude = json["longitude"];
//     _latitude = json["latitude"];
//     _profilePhotoUrl = json['profile_photo_url'];
//     _followers = json['followers'];
//     _followings = json['followings'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this._id;
//     data['name'] = this._name;
//     data['email'] = this._email;
//     data['address'] = this._address;
//     data['city'] = this._city;
//     data['country'] = this._country;
//     data['user_type'] = this._userType;
//     data['latitude'] = this._latitude;
//     data['longitude'] = this._longitude;
//     data['profile_photo_url'] = this._profilePhotoUrl;
//     data['followers'] = this._followers;
//     data['followings'] = this._followings;
//     return data;
//   }
// }


class SingleRestorent {
  SingleRestorent({
    this.id,
    this.name,
    this.email,
    this.address,
    this.city,
    this.country,
    this.userType,
    this.longitude,
    this.latitude,
    //this.distance,
    this.profilePhotoUrl,
    this.followers,
    this.followings,
    this.zip,
    this.website
  });

  int? id;
  String? name;
  String? email;
  String? address;
  String? city;
  String? country;
  String? userType;
  String? longitude;
  String? latitude;
  //String? distance;
  String? profilePhotoUrl;
  int? followers;
  int? followings;
  String? zip;
  String? website;

  factory SingleRestorent.fromJson(Map<String, dynamic> json) => SingleRestorent(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    address: json["address"] == null ? null : json["address"],
    city: json["city"] == null ? null : json["city"],
    country: json["country"] == null ? null : json["country"],
    userType: json["user_type"],
    longitude: json["longitude"] == null ? null : json["longitude"],
    latitude: json["latitude"] == null ? null : json["latitude"],
    // distance: json["distance"] == null ? null : json["distance"].toDouble(),
    profilePhotoUrl: json["profile_photo_url"],
    followers: json["followers"],
    followings: json["followings"],
    zip: json["zip"],
    website: json["website"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "address": address == null ? null : address,
    "city": city == null ? null : city,
    "country": country == null ? null : country,
    "user_type": userType,
    "longitude": longitude == null ? null : longitude,
    "latitude": latitude == null ? null : latitude,
    // "distance": distance == null ? null : distance,
    "profile_photo_url": profilePhotoUrl,
    "followers": followers,
    "followings": followings,
    "zip": zip==null? null : zip,
    "website": website==null? null: website,
  };
}


