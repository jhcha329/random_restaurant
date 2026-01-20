import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:random_restaurant/food_data.dart';
import 'package:random_restaurant/search_screen.dart';
import 'brand_chip.dart';

class RandomSequence extends StatelessWidget {
  final Food food;
  final int step;
  final Color accent;
  final VoidCallback onReplay;

  const RandomSequence({
    super.key,
    required this.food,
    required this.step,
    required this.accent,
    required this.onReplay,
  });

  @override
  Widget build(BuildContext context) {
    final brands = food.brands.take(6).toList();

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.only(top: step == 0 ? 0 : 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 650),
              curve: Curves.easeOutCubic,
              alignment: step == 0 ? Alignment.center : Alignment.topCenter,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 650),
                curve: Curves.easeOutCubic,
                style: GoogleFonts.notoSansKr(
                  fontSize: step == 0 ? 20 : 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black.withOpacity(step == 0 ? 0.55 : 0.45),
                ),
                child: const Text('오늘의 음식은…', textAlign: TextAlign.center),
              ),
            ),
            const SizedBox(height: 12),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.06),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: step >= 1
                  ? RichText(
                key: ValueKey('title_${food.name}'),
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.jua(
                    fontSize: 40,
                    height: 1.05,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: food.name,
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const TextSpan(text: ' 어떠세요?'),
                  ],
                ),
              )
                  : const SizedBox.shrink(key: ValueKey('title_empty')),
            ),

            const SizedBox(height: 14),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 560),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.04),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: step >= 2
                  ? Text(
                food.description,
                key: ValueKey('desc_${food.name}'),
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSansKr(
                  fontSize: 16,
                  height: 1.45,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.65),
                ),
              )
                  : const SizedBox.shrink(key: ValueKey('desc_empty')),
            ),

            const SizedBox(height: 14),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.05),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: step >= 3
                  ? Column(
                key: ValueKey('brand_btn_${food.name}'),
                children: [
                  if (brands.isNotEmpty) ...[
                    Text(
                      '${food.name} 브랜드 추천',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.notoSansKr(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.black.withOpacity(0.55),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final b in brands)
                          BrandChip(text: b, accent: accent),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SearchScreen(keyword: food.name),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent.withOpacity(0.12),
                        foregroundColor: accent,
                        elevation: 0,
                        iconColor: accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                          side: BorderSide(color: accent.withOpacity(0.25)),
                        ),
                      ),
                      icon: const Icon(Icons.map_outlined, size: 20),
                      label: Text(
                        '주변 맛집 찾아보기',
                        style: GoogleFonts.notoSansKr(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: onReplay,
                    child: Text(
                      '다시 추천해줘',
                      style: GoogleFonts.notoSansKr(
                        fontWeight: FontWeight.w800,
                        color: Colors.black.withOpacity(0.55),
                      ),
                    ),
                  ),
                ],
              )
                  : const SizedBox.shrink(key: ValueKey('brand_btn_empty')),
            ),
          ],
        ),
      ),
    );
  }
}