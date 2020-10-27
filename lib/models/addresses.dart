import 'package:flutter/foundation.dart';

class Addresses {
  final Map<String, dynamic> district;
  final Map<String, dynamic> street;
  final Map<String, dynamic> community;
  final Map<String, dynamic> house;
  final String address;

  Addresses({
    this.district,
    this.street,
    this.community,
    this.house,
    this.address,
  });

  factory Addresses.fromJson(Map<String, dynamic> json) {
    return Addresses(
      district: json["district"] as Map<String, dynamic>,
      street: json["street"] as Map<String, dynamic>,
      community: json["community"] as Map<String, dynamic>,
      house: json["house"] as Map<String, dynamic>,
      address: json["address"] as String,
    );
  }
}
