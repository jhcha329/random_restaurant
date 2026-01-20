// 로더 UI

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'models/place.dart';
import 'services/place_search_service.dart';
import 'place_map_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class SearchScreen extends StatefulWidget {
  final String keyword;

  const SearchScreen({
    super.key,
    required this.keyword,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final PlaceSearchService _service;

  @override
  void initState() {
    super.initState();

    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://heybob-proxy.jaehyeokcha01.workers.dev',
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
      ),
    );

    _service = PlaceSearchService(dio);

    // ✅ 화면 들어오자마자 검색 → 결과 받으면 지도 화면으로 이동
    _loadAndGo();
  }

  Future<void> _loadAndGo() async {
    try {
      final places = await _service.search(widget.keyword);

      if (!mounted) return;

      // ✅ 결과가 없으면 이 화면에서 안내
      if (places.isEmpty) {
        setState(() {
          // 아래 build에서 처리하도록
          _empty = true;
        });
        return;
      }

      // ✅ “리스트 화면”을 보여주지 않고, 바로 지도+리스트 화면으로 이동
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PlaceMapScreen(
            keyword: widget.keyword,
            places: places,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    }
  }

  bool _empty = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF8),
      body: Center(
        child: _error != null
            ? Text(
          '검색 중 오류가 발생했습니다.\n$_error',
          textAlign: TextAlign.center,
        )
            : _empty
            ? const Text('검색 결과가 없습니다.')
            : const _HeyBobLoading(),
      ),
    );
  }
}

class _HeyBobLoading extends StatefulWidget {
  const _HeyBobLoading();

  @override
  State<_HeyBobLoading> createState() => _HeyBobLoadingState();
}

class _HeyBobLoadingState extends State<_HeyBobLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFFF6B2C);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'HEYBOB',
          style: GoogleFonts.jua(
            fontSize: 28,
            color: accent,
          ),
        ),
        const SizedBox(height: 24),

        // 둥둥 뜨는 점 3개
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) {
                final offset =
                    sin((_controller.value * 2 * pi) + i) * 6;
                return Transform.translate(
                  offset: Offset(0, offset),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: accent.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            );
          },
        ),

        const SizedBox(height: 24),

        Text(
          'Bob이 주변 맛집을 찾고 있어요',
          style: GoogleFonts.notoSansKr(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}