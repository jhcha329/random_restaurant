import 'dart:math';
import 'package:flutter/material.dart';

import 'package:random_restaurant/food_data.dart';
import 'widgets/random_header.dart';
import 'widgets/random_sequence.dart';

class RandomScreen extends StatefulWidget {
  const RandomScreen({super.key});

  @override
  State<RandomScreen> createState() => _RandomScreenState();
}

class _RandomScreenState extends State<RandomScreen> {
  static const accent = Color(0xFFFF6B2C);

  Food food = foodList.first;
  final random = Random();

  // 0: 오늘의 음식은
  // 1: 메인 타이틀
  // 2: 설명
  // 3: 브랜드+버튼
  int step = 0;

  @override
  void initState() {
    super.initState();
    _pickAndPlay();
  }

  void _pickAndPlay() {
    setState(() {
      food = foodList[random.nextInt(foodList.length)];
      step = 0;
    });
    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => step = 1);

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => step = 2);

    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => step = 3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF8),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const RandomHeader(accent: accent),
              const SizedBox(height: 12),
              Expanded(
                child: Center(
                  child: RandomSequence(
                    food: food,
                    step: step,
                    accent: accent,
                    onReplay: _pickAndPlay,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}