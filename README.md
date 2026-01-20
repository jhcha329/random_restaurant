# Random Restaurant 🍽️

랜덤으로 음식을 추천하고,
선택된 음식 키워드로 주변 음식점을 검색하는 Flutter 앱입니다

## Features
- 랜덤 음식 추천
- 네이버 지역 검색 API 연동 (프록시 서버 사용)
- 검색 결과 리스트 표시

## Environment Variables
Create a `.env` file in the project root:

NAVER_MAP_CLIENT_ID=your_naver_map_client_id

## Tech Stack
- Flutter
- flutter_naver_map
- Dio
- Cloudflare Workers
- Naver Local Search API