class UpdateProfileModel {
  UpdateProfileModel({
    this.success,
    this.message,
    this.data,
  });

  UpdateProfileModel.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }
  bool? success;
  String? message;
  UserData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }
}

class UserData {
  UserData({
    this.firstName,
    this.lastName,
    this.username,
    this.email,
    this.phone,
    this.streetAddress,
    this.city,
    this.state,
    this.zipcode,
    this.bio,
    this.profileImage,
  });

  UserData.fromJson(dynamic json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    streetAddress = json['street_address'];
    city = json['city'];
    state = json['state'];
    zipcode = json['zipcode'];
    bio = json['bio'];
    //profileImage = json['profile_image'] as String?;
    if (json['profile_image'] is String) {
      profileImage = json['profile_image'];
    } else if (json['profile_image'] is List && json['profile_image'].isNotEmpty) {
      profileImage = json['profile_image'][0];
    } else {
      profileImage = null;
    }

  }
  String? firstName;
  String? lastName;
  String? email;
  String? username;
  String? phone;
  String? streetAddress;
  String? city;
  String? state;
  String? zipcode;
  String? bio;
  String? profileImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['username'] = username;
    map['email'] = email;
    map['phone'] = phone;
    map['street_address'] = streetAddress;
    map['city'] = city;
    map['state'] = state;
    map['zipcode'] = zipcode;
    map['bio'] = bio;
    map['profile_image'] = profileImage ?? '';
    return map;
  }
}
