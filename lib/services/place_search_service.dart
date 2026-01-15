import 'package:dio/dio.dart';
import '../models/place.dart';

class PlaceSearchService {
  final Dio _dio;

  PlaceSearchService(this._dio);

  Future<List<Place>> search(String keyword) async {
    final res = await _dio.get(
      '/search',
      queryParameters: {'query': keyword},
    );

    final items = res.data['items'] as List;
    return items
        .map((e) => Place.fromNaver(e as Map<String, dynamic>))
        .toList();
  }
}