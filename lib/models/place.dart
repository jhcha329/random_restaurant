import 'package:flutter/material.dart';

class Place {
  final String name;
  final String address;

  const Place({
    required this.name,
    required this.address,
  });

  factory Place.fromNaver(Map<String, dynamic> json) {
    return Place(
      name: _stripHtml(json['title'] as String),
      address: json['roadAddress'] as String,
    );
  }
}

String _stripHtml(String text) {
  return text.replaceAll(RegExp(r'<[^>]*>'), '');
}