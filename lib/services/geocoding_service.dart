import 'package:dio/dio.dart';

class GeocodingService {
  final Dio _dio;

  GeocodingService(this._dio);

  Future<LatLng?> geocodeByAddress(String address) async {
    final res = await _dio.get(
      '/geocode',
      queryParameters: {'address': address},
    );

    final data = res.data as Map<String, dynamic>;
    final lat = data['lat'];
    final lng = data['lng'];

    if (lat == null || lng == null) return null;

    return LatLng(
      (lat as num).toDouble(),
      (lng as num).toDouble(),
    );
  }
}

class LatLng {
  final double lat;
  final double lng;

  const LatLng(this.lat, this.lng);
}