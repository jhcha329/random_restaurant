import 'package:flutter/material.dart';
import 'package:random_restaurant/random_screen.dart';
import 'widgets/primary_action_button.dart';
import 'widgets/secondary_action_button.dart';
import 'random_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seoul, Korea (임시)'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 40),
            const Text(
              '밥묵자!',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            PrimaryActionButton(
              label: '랜덤 음식 고르기',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const RandomScreen())
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
      ),
    );
  }
}