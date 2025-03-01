import 'package:online_shop/model/city.dart';

class StoresModel {
  final int id;
  final String title;
  final String address;
  final String? postalCode;
  final double latitude;
  final double longitude;
  final String mobile;
  final String phone;
  final String owner;
  final String? status;
  final Map<String, dynamic>? logo;
  final Map<String, dynamic>? banner;
  final City city;
  final List<dynamic> storeTypes;

  StoresModel({
    required this.id,
    required this.title,
    required this.address,
    this.postalCode,
    required this.latitude,
    required this.longitude,
    required this.mobile,
    required this.phone,
    required this.owner,
    this.status,
    this.logo,
    this.banner,
    required this.city,
    required this.storeTypes,
  });

  factory StoresModel.fromJson(Map<String, dynamic> json) {
    return StoresModel(
      id: json['id'],
      title: json['title'],
      address: json['address'],
      postalCode: json['postal_code'],
      latitude: (json['latitude'] != null)
          ? double.parse(json['latitude'].toString())
          : 0.0,
      longitude: (json['longitude'] != null)
          ? double.parse(json['longitude'].toString())
          : 0.0,
      mobile: json['mobile'],
      phone: json['phone'],
      owner: json['owner'],
      status: json['status'],
      logo: json['logo'],
      banner: json['banner'],
      city: City.fromJson(json['city']),
      storeTypes: json['storeTypes'] != null
          ? List<dynamic>.from(json['storeTypes'])
          : [],
    );
  }
}
