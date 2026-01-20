import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandChip extends StatelessWidget {
  final String text;
  final Color accent;

  const BrandChip({
    super.key,
    required this.text,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: Colors.black.withOpacity(0.10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        text,
        style: GoogleFonts.notoSansKr(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          color: Colors.black.withOpacity(0.70),
        ),
      ),
    );
  }
}