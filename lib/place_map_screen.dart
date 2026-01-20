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
  static const accent = Color(0xFFFF6B2C);

  NaverMapController? _mapController;

  late final Dio _dio;
  late final GeocodingService _geocoding;

  Place? _selected;

  final Set<String> _markedIds = <String>{};
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
    final addr = p.roadAddress.isNotEmpty ? p.roadAddress : p.address;
    return '${p.name}::$addr';
  }

  String _safeAddress(Place p) =>
      p.roadAddress.isNotEmpty ? p.roadAddress : p.address;

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

    // 마커 없으면 찍고 이동
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

    // 이미 찍혀있어도(현재는) 주소로 다시 좌표 얻어서 이동
    final ll = await _geocoding.geocodeByAddress(_safeAddress(p));
    if (!mounted || ll == null) return;
    final pos = NLatLng(ll.lat, ll.lng);
    controller.updateCamera(NCameraUpdate.withParams(target: pos, zoom: 15));
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);

    return Scaffold(
      // ✅ AppBar 제거: 지도는 풀블리드가 더 예쁨
      body: Stack(
        children: [
          // 1) 지도
          NaverMap(
            options: NaverMapViewOptions(
              contentPadding: safePadding,
              initialCameraPosition: const NCameraPosition(
                target: NLatLng(37.5666, 126.979),
                zoom: 12,
              ),
            ),
            onMapReady: (controller) async {
              _mapController = controller;
              await _addInitialMarkers();
            },
          ),

          // 2) 상단 오버레이 바 (토스 느낌)
          Positioned(
            left: 16,
            right: 16,
            top: 10,
            child: _TopOverlayBar(
              accent: accent,
              title: '“${widget.keyword}” 맛집',
              subtitle: '${widget.places.length}개 결과',
              onBack: () => Navigator.of(context).maybePop(),
            ),
          ),

          // 3) 끌어올리는 리스트
          DraggableScrollableSheet(
            initialChildSize: 0.24,
            minChildSize: 0.16,
            maxChildSize: 0.88,
            snap: true,
            snapSizes: const [0.24, 0.58, 0.88],
            builder: (context, scrollController) {
              return _PlaceListSheet(
                accent: accent,
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

class _TopOverlayBar extends StatelessWidget {
  final Color accent;
  final String title;
  final String subtitle;
  final VoidCallback onBack;

  const _TopOverlayBar({
    required this.accent,
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 20,
              color: Colors.black.withOpacity(0.70),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black.withOpacity(0.45),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: accent.withOpacity(0.10),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: accent.withOpacity(0.20)),
              ),
              child: Text(
                'HEYBOB',
                style: TextStyle(
                  color: accent,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceListSheet extends StatelessWidget {
  final Color accent;
  final String keyword;
  final List<Place> places;
  final Place? selected;
  final ScrollController scrollController;
  final ValueChanged<Place> onTapPlace;

  const _PlaceListSheet({
    required this.accent,
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
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              blurRadius: 22,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(height: 12),

            // ✅ 시트 헤더: 키워드 칩 + 안내
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: accent.withOpacity(0.18)),
                    ),
                    child: Text(
                      keyword,
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${places.length}개 중에서 하나를 선택하면 지도가 이동합니다',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.55),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),

            Expanded(
              child: ListView.separated(
                controller: scrollController,
                itemCount: places.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  color: Colors.black.withOpacity(0.06),
                ),
                itemBuilder: (context, index) {
                  final p = places[index];
                  final addr = _safeAddress(p);

                  final isSelected = selected != null &&
                      p.name == selected!.name &&
                      addr == _safeAddress(selected!);

                  return InkWell(
                    onTap: () => onTapPlace(p),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? accent.withOpacity(0.12)
                                  : Colors.black.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isSelected
                                    ? accent.withOpacity(0.35)
                                    : Colors.black.withOpacity(0.06),
                              ),
                            ),
                            child: Icon(
                              Icons.place_rounded,
                              color: isSelected
                                  ? accent
                                  : Colors.black.withOpacity(0.50),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.w900
                                        : FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  addr,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.55),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            isSelected
                                ? Icons.check_circle_rounded
                                : Icons.chevron_right_rounded,
                            color: isSelected ? accent : Colors.black26,
                          ),
                        ],
                      ),
                    ),
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