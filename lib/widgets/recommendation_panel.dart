import 'package:flutter/material.dart';
import '../food_data.dart';

class RecommendationPanel extends StatefulWidget {
  final Food food;
  final Color accent;
  final VoidCallback onSearchNearby;

  const RecommendationPanel({
    super.key,
    required this.food,
    required this.accent,
    required this.onSearchNearby,
  });

  @override
  State<RecommendationPanel> createState() => _RecommendationPanelState();
}

class _RecommendationPanelState extends State<RecommendationPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  late final Animation<double> _fade1;
  late final Animation<double> _fade2;
  late final Animation<double> _fade3;
  late final Animation<double> _fade4;

  late final Animation<Offset> _slide1;
  late final Animation<Offset> _slide2;
  late final Animation<Offset> _slide3;
  late final Animation<Offset> _slide4;

  @override
  void initState() {
    super.initState();

    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    Animation<double> fade(Interval interval) =>
        CurvedAnimation(parent: _c, curve: interval);

    Animation<Offset> slide(Interval interval) => Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _c, curve: interval));

    _fade1 = fade(const Interval(0.00, 0.35, curve: Curves.easeOut));
    _fade2 = fade(const Interval(0.18, 0.55, curve: Curves.easeOut));
    _fade3 = fade(const Interval(0.36, 0.75, curve: Curves.easeOut));
    _fade4 = fade(const Interval(0.52, 1.00, curve: Curves.easeOut));

    _slide1 = slide(const Interval(0.00, 0.35, curve: Curves.easeOutCubic));
    _slide2 = slide(const Interval(0.18, 0.55, curve: Curves.easeOutCubic));
    _slide3 = slide(const Interval(0.36, 0.75, curve: Curves.easeOutCubic));
    _slide4 = slide(const Interval(0.52, 1.00, curve: Curves.easeOutCubic));

    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final food = widget.food;
    final brandsText = food.brands.isEmpty
        ? null
        : '${food.brands.take(5).join(', ')} 같은 브랜드가 있어요';

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 520),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: widget.accent.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            blurRadius: 28,
            offset: const Offset(0, 16),
            color: Colors.black.withOpacity(0.08),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SlideTransition(
            position: _slide1,
            child: FadeTransition(
              opacity: _fade1,
              child: Text(
                '오늘의 음식은…',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black.withOpacity(0.55),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          SlideTransition(
            position: _slide2,
            child: FadeTransition(
              opacity: _fade2,
              child: Text(
                '${food.name} 어떠세요?',
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          SlideTransition(
            position: _slide3,
            child: FadeTransition(
              opacity: _fade3,
              child: Text(
                food.description,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                  color: Colors.black.withOpacity(0.65),
                ),
              ),
            ),
          ),

          if (brandsText != null) ...[
            const SizedBox(height: 12),
            SlideTransition(
              position: _slide3,
              child: FadeTransition(
                opacity: _fade3,
                child: Text(
                  '${food.name} 브랜드로는 $brandsText',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.35,
                    fontWeight: FontWeight.w700,
                    color: Colors.black.withOpacity(0.55),
                  ),
                ),
              ),
            ),
          ],

          const SizedBox(height: 18),

          SlideTransition(
            position: _slide4,
            child: FadeTransition(
              opacity: _fade4,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: widget.onSearchNearby,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.accent.withOpacity(0.10),
                    elevation: 0,
                    foregroundColor: widget.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(color: widget.accent.withOpacity(0.20)),
                    ),
                  ),
                  icon: const Icon(Icons.map_outlined),
                  label: const Text(
                    '주변 맛집 찾아보기',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}