// class User {
//   int? id;
//   String? name;
//   String? email;
//   int? isCompany;
//   String? phone;
//   String? contactPerson;
//   String? companyName;
//   String? invoiceAddress;
//   String? zipandcountry;
//   String? country;
//   String? profilePhotoUrl;
//   int? followers;
//   int? followings;
//
//
//   int? id;
//   String? name;
//   String? email;
//   String? phone;
//   dynamic contactPerson;
//   int? isCompany;
//   String? address;
//   String? city;
//   String? zip;
//   String? country;
//   DateTime? dob;
//   dynamic vatNumber;
//   dynamic coc;
//   String? profilePhotoUrl;
//   int? followers;
//   int? followings;
//
//
//   User(
//       {this.id,
//       this.name,
//       this.email,
//       this.isCompany,
//       this.phone,
//       this.contactPerson,
//       this.companyName,
//       this.invoiceAddress,
//       this.zipandcountry,
//       this.country,
//       this.profilePhotoUrl,
//       this.followers,
//       this.followings
//
//
//       this.id,
//         this.name,
//         this.email,
//         this.phone,
//         this.contactPerson,
//         this.isCompany,
//         this.address,
//         this.city,
//         this.zip,
//         this.country,
//         this.dob,
//         this.vatNumber,
//         this.coc,
//         this.profilePhotoUrl,
//         this.followers,
//         this.followings,
//
//
//
//       });
//
//   User.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'];
//     email = json['email'];
//     isCompany = json['is_company'];
//     phone = json['phone'];
//     contactPerson = json['contact_person'];
//     companyName = json['address'];
//     invoiceAddress = json['city'];
//     zipandcountry = json['zip'];
//     country = json['country'];
//     profilePhotoUrl = json['profile_photo_url'];
//     followers = json['followers'];
//     followings = json['followings'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['is_company'] = this.isCompany;
//     data['phone'] = this.phone;
//     data['contact_person'] = this.contactPerson;
//     data['address'] = this.companyName;
//     data['city'] = this.invoiceAddress;
//     data['zip'] = this.zipandcountry;
//     data['country'] = this.country;
//     data['profile_photo_url'] = this.profilePhotoUrl;
//     data['followers'] = this.followers;
//     data['followings'] = this.followings;
//     return data;
//   }
// }


class User {
  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.contactPerson,
    this.isCompany,
    this.address,
    this.city,
    this.zip,
    this.country,
    this.dob,
    this.isCompleted,
    this.vatNumber,
    this.coc,
    this.profilePhotoUrl,
    this.followers,
    this.followings,
  });

  int? id;
  String? name;
  String? email;
  String? phone;
  dynamic contactPerson;
  int? isCompany;
  String? address;
  String? city;
  String? zip;
  String? country;
  dynamic dob;
  bool? isCompleted;
  dynamic vatNumber;
  dynamic coc;
  String? profilePhotoUrl;
  int? followers;
  int? followings;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    contactPerson: json["contact_person"],
    isCompany: json["is_company"],
    address: json["address"],
    city: json["city"],
    zip: json["zip"],
    country: json["country"],
    vatNumber: json["vat_number"],
    coc: json["coc"],
    profilePhotoUrl: json["profile_photo_url"],
    followers: json["followers"],
    followings: json["followings"],
    dob: DateTime.parse(json["dob"]),
    isCompleted: json["is_completed"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "contact_person": contactPerson,
    "is_company": isCompany,
    "address": address,
    "city": city,
    "zip": zip,
    "country": country,
    "vat_number": vatNumber,
    "coc": coc,
    "profile_photo_url": profilePhotoUrl,
    "followers": followers,
    "followings": followings,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "is_completed": isCompleted,
  };
}



class UserSession {
  String? lastLogin;
  String? token;
  String? userId;
  String? role;
  String? districtId;

  UserSession(
      {
        this.lastLogin,
        this.token,
        this.userId,
        this.role,
        this.districtId
      });

  UserSession.fromJson(Map<String, dynamic> json) {
    lastLogin = json['lastLogin'];
    token = json['token'];
    userId = json['userId'];
    role = json['role'];
    districtId = json['districtId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastLogin'] = this.lastLogin;
    data['token'] = this.token;
    data['userId'] = this.userId;
    data['role'] = this.role;
    data['districtId'] = this.districtId;
    return data;
  }
}

class UserProfile {
  String? id;
  String? name;
  String? address;
  String? email;
  String? phone;
  String? password;
  String? businessName;
  String? businessEmail;
  String? businessPhone;
  String? pincode;
  String? districtId;
  String? gstin;
  String? code;

  UserProfile(
      {this.id,
      this.name,
      this.address,
      this.email,
      this.phone,
      this.password,
      this.businessName,
      this.businessEmail,
      this.businessPhone,
      this.pincode,
      this.districtId,
      this.gstin,
      this.code});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    businessName = json['businessName'];
    businessEmail = json['businessEmail'];
    businessPhone = json['businessPhone'];
    pincode = json['pincode'];
    districtId = json['districtId'];
    gstin = json['gstin'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['address'] = this.address;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['businessName'] = this.businessName;
    data['businessEmail'] = this.businessEmail;
    data['businessPhone'] = this.businessPhone;
    data['pincode'] = this.pincode;
    data['districtId'] = this.districtId;
    data['gstin'] = this.gstin;
    data['code'] = this.code;
    return data;
  }
}



// class User {
//   User({
//     this.id,
//     this.name,
//     this.email,
//     this.phone,
//     this.contactPerson,
//     this.isCompany,
//     this.address,
//     this.city,
//     this.zip,
//     this.country,
//     this.dob,
//     this.vatNumber,
//     this.coc,
//     this.profilePhotoUrl,
//     this.followers,
//     this.followings,
//   });
//
//   int? id;
//   String? name;
//   String? email;
//   String? phone;
//   String? contactPerson;
//   int? isCompany;
//   String? address;
//   String? city;
//   String? zip;
//   String? country;
//   dynamic dob;
//   String? vatNumber;
//   String? coc;
//   String? profilePhotoUrl;
//   int? followers;
//   int? followings;
//
//   factory User.fromJson(Map<String, dynamic> json) => User(
//     id: json["id"] == null ? null : json["id"],
//     name: json["name"] == null ? null : json["name"],
//     email: json["email"] == null ? null : json["email"],
//     phone: json["phone"] == null ? null : json["phone"],
//     contactPerson: json["contact_person"] == null ? null : json["contact_person"],
//     isCompany: json["is_company"] == null ? null : json["is_company"],
//     address: json["address"] == null ? null : json["address"],
//     city: json["city"] == null ? null : json["city"],
//     zip: json["zip"] == null ? null : json["zip"],
//     country: json["country"] == null ? null : json["country"],
//     dob: json["dob"],
//     vatNumber: json["vat_number"] == null ? null : json["vat_number"],
//     coc: json["coc"] == null ? null : json["coc"],
//     profilePhotoUrl: json["profile_photo_url"] == null ? null : json["profile_photo_url"],
//     followers: json["followers"] == null ? null : json["followers"],
//     followings: json["followings"] == null ? null : json["followings"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id == null ? null : id,
//     "name": name == null ? null : name,
//     "email": email == null ? null : email,
//     "phone": phone == null ? null : phone,
//     "contact_person": contactPerson == null ? null : contactPerson,
//     "is_company": isCompany == null ? null : isCompany,
//     "address": address == null ? null : address,
//     "city": city == null ? null : city,
//     "zip": zip == null ? null : zip,
//     "country": country == null ? null : country,
//     "dob": dob,
//     "vat_number": vatNumber == null ? null : vatNumber,
//     "coc": coc == null ? null : coc,
//     "profile_photo_url": profilePhotoUrl == null ? null : profilePhotoUrl,
//     "followers": followers == null ? null : followers,
//     "followings": followings == null ? null : followings,
//   };
// }
