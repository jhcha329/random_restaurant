import 'package:flutter/material.dart';
import 'random/presentation/random_screen.dart';
import 'widgets/primary_action_button.dart';
import 'widgets/secondary_action_button.dart';
import 'widgets/floating_image.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFFF6B2C);

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF3EC),
              Color(0xFFFFE2D2),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),

                /// 상단 위치 표시 (임시)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    '📍 Seoul, Korea',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// 메인 타이틀 영역
                Text(
                  'HEYBOB',
                  style: GoogleFonts.jua(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    height: 1.1,
                    color: const Color(0xFFFF6B2C),
                  ),
                ),

                const SizedBox(height: 80),

                // 🔥 여기 이미지 추가
                const FloatingImage(),

                const SizedBox(height: 30),

                Center(
                  child: const Text(
                    '메뉴고민 해결해줄게!',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const Spacer(),

                /// CTA 영역
                Column(
                  children: [
                    PrimaryActionButton(
                      label: '랜덤 음식 고르기',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RandomScreen(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 14),

                    SecondaryActionButton(
                      label: '주변 음식점 찾기',
                      onPressed: () {
                        // TODO: 네이버 지도 화면 이동
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                /// 하단 힌트 텍스트
                Center(
                  child: Text(
                    '🍽️ 오늘의 선택을 빠르게',
                    style: TextStyle(
                      fontSize: 13,
                      color: accent.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
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