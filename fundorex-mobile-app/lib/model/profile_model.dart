// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.userDetails,
  });

  UserDetails userDetails;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        userDetails: UserDetails.fromJson(json["user_details"]),
      );

  Map<String, dynamic> toJson() => {
        "user_details": userDetails.toJson(),
      };
}

class UserDetails {
  UserDetails({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image,
    this.zipcode,
    this.city,
    this.state,
    this.countryId,
    this.address,
    this.country,
  });

  dynamic id;
  String? name;
  String? email;
  String? phone;
  dynamic image;
  dynamic zipcode;
  String? city;
  String? state;
  String? countryId;
  String? address;
  Country? country;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        image: json["image"],
        zipcode: json["zipcode"],
        city: json["city"],
        state: json["state"],
        countryId: json["country_id"],
        address: json["address"],
        country: Country?.fromJson(json["country"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "image": image,
        "zipcode": zipcode,
        "city": city,
        "state": state,
        "country_id": countryId,
        "address": address,
        "country": country?.toJson(),
      };
}

class Country {
  Country({
    this.id,
    this.name,
  });

  dynamic id;
  String? name;

  factory Country.fromJson(Map<String, dynamic>? json) => Country(
        id: json?["id"],
        name: json?["name"],
      );

  Map<String?, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
