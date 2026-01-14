import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1️⃣ env 로드
  await dotenv.load(fileName: ".env");

  // 2️⃣ env에서 값 꺼내기
  final naverMapClientId = dotenv.env['NAVER_MAP_CLIENT_ID'];

  if (naverMapClientId == null || naverMapClientId.isEmpty) {
    throw Exception('NAVER_MAP_CLIENT_ID is not set in .env');
  }

  // 3️⃣ 하드코딩 ❌ → env 값 ⭕
  await FlutterNaverMap().init(
    clientId: naverMapClientId,
    onAuthFailed: (ex) {
      switch (ex) {
        case NQuotaExceededException(:final message):
          debugPrint("사용량 초과 (message: $message)");
          break;
        case NUnauthorizedClientException() ||
        NClientUnspecifiedException() ||
        NAnotherAuthFailedException():
          debugPrint("인증 실패: $ex");
          break;
      }
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Random Restaurant',
      home: HomeScreen(),
    );
  }
}