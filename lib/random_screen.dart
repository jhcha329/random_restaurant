import 'dart:math';
import 'food_data.dart';
import 'package:flutter/material.dart';
import 'widgets/food_card.dart';
import 'package:google_fonts/google_fonts.dart';

class RandomScreen extends StatefulWidget {
  const RandomScreen({super.key});

  @override
  State<RandomScreen> createState() => _RandomScreenState();
}

class _RandomScreenState extends State<RandomScreen> {
  Food food = foodList.first;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    pickFood();
  }

  void pickFood() {
    setState(() {
      food = foodList[random.nextInt(foodList.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFFF6B2C);
    const bgTop = Color(0xFFFFF3EC);
    const bgBottom = Color(0xFFFFE2D2);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgTop, bgBottom],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // 헤더
                Text(
                  'HeyBob',
                  style: GoogleFonts.jua(
                    fontSize: 35,
                    color: const Color(0xFFFF6B2C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // 🔥 애니메이션 카드 영역
                Expanded(
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 450),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: Tween<double>(
                              begin: 0.92,
                              end: 1.0,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: FoodCard(
                        key: ValueKey(food.name), // ⭐ 핵심
                        food: food,
                        accent: accent,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // CTA 버튼
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: pickFood,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      elevation: 10,
                      shadowColor: accent.withOpacity(0.35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      '다시 뽑기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}