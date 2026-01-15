import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'models/place.dart';
import 'services/place_search_service.dart';

class SearchScreen extends StatefulWidget {
  final String keyword;

  const SearchScreen({
    super.key,
    required this.keyword,
  });

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  late final PlaceSearchService _service;
  late final Future<List<Place>> _future;

  @override
  void initState() {
    super.initState();

    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://heybob-proxy.jaehyeokcha01.workers.dev', // 🔴 Cloudflare Worker URL
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
      ),
    );

    _service = PlaceSearchService(dio);
    _future = _service.search(widget.keyword);


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('“${widget.keyword}” 주변 음식점'),
      ),
      body: FutureBuilder<List<Place>>(
        future: _future,
        builder: (context, snapshot) {
          // 1️⃣ 로딩
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 2️⃣ 에러
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '검색 중 오류가 발생했습니다.\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final places = snapshot.data!;

          // 3️⃣ 빈 결과
          if (places.isEmpty) {
            return const Center(
              child: Text('검색 결과가 없습니다.'),
            );
          }

          // 4️⃣ 성공 → 리스트
          return ListView.separated(
            itemCount: places.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final place = places[index];

              return ListTile(
                title: Text(place.name),
                subtitle: Text(place.address),
                leading: const Icon(Icons.place_outlined),
              );
            },
          );
        },
      ),
    );
  }
}