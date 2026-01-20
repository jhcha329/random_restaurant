import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RandomHeader extends StatelessWidget {
  final Color accent;

  const RandomHeader({
    super.key,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.black.withOpacity(0.65),
          tooltip: '뒤로가기',
        ),
        const SizedBox(width: 4),
        const Spacer(),
        Text(
          'Bob이 골라줘요',
          style: TextStyle(
            color: Colors.black.withOpacity(0.45),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}