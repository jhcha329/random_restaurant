import 'package:flutter/material.dart';
import '../food_data.dart';

class FoodActionCard extends StatelessWidget {
  final Food food;
  final Color accent;
  final VoidCallback onSearchNearby;

  const FoodActionCard({
    super.key,
    required this.food,
    required this.accent,
    required this.onSearchNearby,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 520),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: accent.withOpacity(0.12),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 라벨
          Row(
            children: [
              _Pill(
                text: '추천',
                bg: accent.withOpacity(0.12),
                fg: accent,
              ),
              const SizedBox(width: 8),
              _Pill(
                text: '오늘의 메뉴',
                bg: Colors.black.withOpacity(0.05),
                fg: Colors.black.withOpacity(0.55),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 음식 이름
          Text(
            food.name,
            style: const TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),

          const SizedBox(height: 10),

          // 한 줄 소개
          Text(
            food.description,
            style: TextStyle(
              fontSize: 15,
              height: 1.35,
              color: Colors.black.withOpacity(0.65),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 14),

          // 브랜드(칩)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: food.brands.take(5).map((b) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.045),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  b,
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.65),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 18),

          // ✅ 카드 안 Secondary CTA: 주변 음식점 찾기
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: onSearchNearby,
              style: OutlinedButton.styleFrom(
                foregroundColor: accent,
                side: BorderSide(color: accent.withOpacity(0.35), width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: const Icon(Icons.map_outlined),
              label: const Text(
                '주변 음식점 찾기',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;

  const _Pill({required this.text, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: fg,
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}