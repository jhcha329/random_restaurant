import 'package:dio/dio.dart';
import '../models/place.dart';

class PlaceSearchService {
  final Dio _dio;
  PlaceSearchService(this._dio);

  Future<List<Place>> search(String keyword) async {
    final res = await _dio.get(
      '/search',
      queryParameters: {'query': keyword, 'display': 8},
    );

    final items = (res.data['items'] as List)
        .cast<Map<String, dynamic>>()
        .map(Place.fromNaver)
        .toList();

    return items;
  }
}