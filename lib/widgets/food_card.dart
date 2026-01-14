import 'package:flutter/material.dart';
import 'package:random_restaurant/food_data.dart';
import 'map_preview.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class FoodCard extends StatelessWidget {
  final Food food;
  final Color accent;


  const FoodCard({
    super.key,
    required this.food,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 음식 이름
          Text(
            food.name,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 12),

          // 설명
          Text(
            food.description,
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 18),

          Text(
            '주변 ${food.name}집',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          // 🔥 지도 미리보기
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 300,
              child: NaverMap(
                options: NaverMapViewOptions(
                  initialCameraPosition: const NCameraPosition(
                    target: NLatLng(37.5666, 126.979),
                    zoom: 14,
                  ),
                ),
                onMapReady: (controller) {
                  final marker = NMarker(
                    id: 'preview',
                    position: NLatLng(37.5666, 126.979),
                    caption: NOverlayCaption(text: '서울시청'),
                  );
                  controller.addOverlay(marker);
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 브랜드 Chip
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: food.brands.map((b) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4EE),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  b,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}