import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'models/place.dart';
import 'services/geocoding_service.dart';

class PlaceMapScreen extends StatefulWidget {
  final String keyword;
  final List<Place> places;

  const PlaceMapScreen({
    super.key,
    required this.keyword,
    required this.places,
  });

  @override
  State<PlaceMapScreen> createState() => _PlaceMapScreenState();
}

class _PlaceMapScreenState extends State<PlaceMapScreen> {
  NaverMapController? _mapController;

  late final Dio _dio;
  late final GeocodingService _geocoding;

  // 선택된 장소(리스트 탭 시)
  Place? _selected;

  // 이미 마커 찍은 place의 id 관리 (중복 방지)
  final Set<String> _markedIds = <String>{};

  // 너무 많은 지오코딩 호출 방지 (일단 8개만 찍기)
  static const int _maxInitialMarkers = 8;

  @override
  void initState() {
    super.initState();

    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://heybob-proxy.jaehyeokcha01.workers.dev',
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
      ),
    );
    _geocoding = GeocodingService(_dio);
  }

  String _placeKey(Place p) {
    // name+address 정도면 충분히 유니크
    final addr = p.roadAddress.isNotEmpty ? p.roadAddress : p.address;
    return '${p.name}::$addr';
  }

  String _safeAddress(Place p) {
    return p.roadAddress.isNotEmpty ? p.roadAddress : p.address;
  }

  Future<void> _addInitialMarkers() async {
    final controller = _mapController;
    if (controller == null) return;

    final targets = widget.places.take(_maxInitialMarkers);

    for (final p in targets) {
      final id = _placeKey(p);
      if (_markedIds.contains(id)) continue;

      final ll = await _geocoding.geocodeByAddress(_safeAddress(p));
      if (!mounted || ll == null) continue;

      _markedIds.add(id);

      final pos = NLatLng(ll.lat, ll.lng);
      final marker = NMarker(
        id: id,
        position: pos,
        caption: NOverlayCaption(text: p.name),
      );

      controller.addOverlay(marker);
    }
  }

  Future<void> _focusPlace(Place p) async {
    setState(() => _selected = p);

    final controller = _mapController;
    if (controller == null) return;

    final id = _placeKey(p);

    // 선택한 장소는 마커가 없으면 새로 찍는다.
    if (!_markedIds.contains(id)) {
      final ll = await _geocoding.geocodeByAddress(_safeAddress(p));
      if (!mounted || ll == null) return;

      _markedIds.add(id);

      final pos = NLatLng(ll.lat, ll.lng);
      final marker = NMarker(
        id: id,
        position: pos,
        caption: NOverlayCaption(text: p.name),
      );

      controller.addOverlay(marker);
      controller.updateCamera(NCameraUpdate.withParams(target: pos, zoom: 15));
      return;
    }

    // 이미 찍어둔 마커면, 다시 지오코딩 없이 카메라만 옮기고 싶지만
    // flutter_naver_map에서 overlay 위치 조회가 어렵다면
    // TODO: "좌표 캐시(Map<String, LatLng>)"를 두어 카메라 이동을 즉시 처리
    final ll = await _geocoding.geocodeByAddress(_safeAddress(p));
    if (!mounted || ll == null) return;
    final pos = NLatLng(ll.lat, ll.lng);
    controller.updateCamera(NCameraUpdate.withParams(target: pos, zoom: 15));
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('지도: ${widget.keyword}'),
      ),
      body: Stack(
        children: [
          // 1) 지도(배경)
          NaverMap(
            options: NaverMapViewOptions(
              contentPadding: safePadding,
              initialCameraPosition: const NCameraPosition(
                target: NLatLng(37.5666, 126.979), // 서울시청(임시)
                zoom: 12,
              ),
            ),
            onMapReady: (controller) async {
              _mapController = controller;
              await _addInitialMarkers();
            },
          ),

          // 2) 끌어올리는 리스트(전면)
          DraggableScrollableSheet(
            initialChildSize: 0.22, // 처음 보이는 높이
            minChildSize: 0.14,     // 최소(거의 손잡이)
            maxChildSize: 0.85,     // 최대(거의 풀)
            snap: true,
            snapSizes: const [0.22, 0.55, 0.85],
            builder: (context, scrollController) {
              return _PlaceListSheet(
                keyword: widget.keyword,
                places: widget.places,
                selected: _selected,
                scrollController: scrollController,
                onTapPlace: _focusPlace,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PlaceListSheet extends StatelessWidget {
  final String keyword;
  final List<Place> places;
  final Place? selected;
  final ScrollController scrollController;
  final ValueChanged<Place> onTapPlace;

  const _PlaceListSheet({
    required this.keyword,
    required this.places,
    required this.selected,
    required this.scrollController,
    required this.onTapPlace,
  });

  String _safeAddress(Place p) =>
      p.roadAddress.isNotEmpty ? p.roadAddress : p.address;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          // 토스 느낌: 위쪽만 둥글게 + 그림자
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // 손잡이
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 10),

            // 헤더
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '“$keyword” 검색 결과 (${places.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_up, color: Colors.black38),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),

            // 리스트
            Expanded(
              child: ListView.separated(
                controller: scrollController, // ✅ DraggableSheet와 연결
                itemCount: places.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final p = places[index];
                  final isSelected =
                      selected != null &&
                          p.name == selected!.name &&
                          _safeAddress(p) == _safeAddress(selected!);

                  return ListTile(
                    onTap: () => onTapPlace(p),
                    title: Text(
                      p.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      _safeAddress(p),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: Icon(
                      isSelected ? Icons.place : Icons.place_outlined,
                    ),
                    trailing: const Icon(Icons.chevron_right),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}