import 'package:flutter/material.dart';

class BottomActions extends StatelessWidget {
  final Color accent;
  final VoidCallback onPickAgain;
  final VoidCallback onSearchNearby;

  const BottomActions({
    super.key,
    required this.accent,
    required this.onPickAgain,
    required this.onSearchNearby,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onPickAgain,
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                '다시 뽑기',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: onSearchNearby,
            child: const Text('주변 음식점 찾기'),
          ),
        ],
      ),
    );
  }
}