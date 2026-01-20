import 'package:flutter/material.dart';

class Place {
  final String name;
  final String roadAddress;
  final String address;
  final String mapx; // TM128 문자열 그대로 보관
  final String mapy;

  const Place({
    required this.name,
    required this.roadAddress,
    required this.address,
    required this.mapx,
    required this.mapy,
  });

  factory Place.fromNaver(Map<String, dynamic> json) {
    return Place(
      name: _stripHtml(json['title'] as String? ?? ''),
      roadAddress: json['roadAddress'] as String? ?? '',
      address: json['address'] as String? ?? '',
      mapx: json['mapx'] as String? ?? '',
      mapy: json['mapy'] as String? ?? '',
    );
  }
}

String _stripHtml(String text) {
  return text.replaceAll(RegExp(r'<[^>]*>'), '');
}