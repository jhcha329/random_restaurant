import 'package:flutter/material.dart';

class FloatingImage extends StatefulWidget {
  const FloatingImage({super.key});

  @override
  State<FloatingImage> createState() => _FloatingImageState();
}

class _FloatingImageState extends State<FloatingImage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  // 왕복 1회(forward+reverse) = 1사이클
  static const int _initialCycles = 2; // 홈 진입 시 2번
  static const int _tapCycles = 1; // 터치 시 1번

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _animation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    // ✅ 홈 화면 진입 시 2회만 재생
    _playCycles(_initialCycles);
  }

  Future<void> _playCycles(int cycles) async {
    // 이미 실행 중이면 '처음부터' 다시 실행하도록 리셋
    _controller.stop();
    _controller.value = 0;

    // mounted 체크: 화면이 이미 dispose된 상태에서 await 후 실행되는 것 방지
    if (!mounted) return;

    for (int i = 0; i < cycles; i++) {
      await _controller.forward();
      if (!mounted) return;
      await _controller.reverse();
      if (!mounted) return;
    }
  }

  void _onTap() {
    // ✅ 터치하면 1회만 재생
    _playCycles(_tapCycles);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _onTap,
        child: AnimatedBuilder(
          animation: _animation,
          child: Image.asset(
            'assets/images/heybob.png',
            width: 330,
            filterQuality: FilterQuality.medium, // 과한 고퀄은 비용 증가
          ),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animation.value),
              child: child,
            );
          },
        ),
      ),
    );
  }
}