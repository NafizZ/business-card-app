import 'package:business_card_app/features/business_discovery/data/models/card_view_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Business extends Equatable implements CardViewModel {
  final String name;
  final String location;
  final String contactNumber;

  const Business({
    required this.name,
    required this.location,
    required this.contactNumber,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    final String name = json['biz_name'] ?? '';
    final String location = json['bss_location'] ?? '';
    final String contactNumber = json['contct_no'] ?? '';

    if (name.isEmpty || location.isEmpty || contactNumber.isEmpty) {
      throw FormatException('missing fields in JSON data');
    }
    return Business(
      name: name,
      location: location,
      contactNumber: contactNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'biz_name': name,
      'bss_location': location,
      'contct_no': contactNumber,
    };
  }

  @override
  List<Object?> get props => [name, location, contactNumber];

  @override
  String get title => name;

  @override
  String get subtitle => location;

  @override
  IconData get icon => Icons.business;
}
