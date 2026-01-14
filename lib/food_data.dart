// lib/data/food_data.dart

// lib/data/food_model.dart

class Food {
  final String name;
  final String description;
  final List<String> brands;

  const Food({
    required this.name,
    required this.description,
    required this.brands,
  });
}

const List<Food> foodList = [
  // 한식
  Food(
    name: '김치찌개',
    description: '매콤한 김치와 돼지고기가 어우러진 집밥의 정석',
    brands: ['놀부김치찌개', '본죽&비빔밥', '김치옥'],
  ),
  Food(
    name: '된장찌개',
    description: '구수한 된장의 깊은 맛이 살아있는 한국인의 소울푸드',
    brands: ['백년된장', '한상차림', '시골된장'],
  ),
  Food(
    name: '불고기',
    description: '달콤짭짤한 양념에 재운 부드러운 소고기 요리',
    brands: ['한촌설렁탕', '명륜진사갈비', '본가'],
  ),
  Food(
    name: '비빔밥',
    description: '신선한 나물과 고추장이 어우러진 건강한 한 그릇',
    brands: ['본비빔밥', '전주비빔밥', '곤드레밥집'],
  ),
  Food(
    name: '삼겹살',
    description: '노릇하게 구워 먹는 한국인의 대표적인 고기 메뉴',
    brands: ['명륜진사갈비', '하남돼지집', '삼겹천하'],
  ),

  // 중식
  Food(
    name: '짜장면',
    description: '달콤한 춘장 소스의 국민 중식 메뉴',
    brands: ['홍콩반점', '이비가짬뽕', '만리장성'],
  ),
  Food(
    name: '짬뽕',
    description: '매콤한 국물과 해산물이 가득한 얼큰한 면 요리',
    brands: ['홍콩반점', '이비가짬뽕', '짬뽕지존'],
  ),
  Food(
    name: '탕수육',
    description: '바삭한 튀김과 새콤달콤 소스의 완벽한 조합',
    brands: ['홍콩반점', '만리장성', '동보성'],
  ),

  // 일식
  Food(
    name: '초밥',
    description: '신선한 생선과 밥이 조화를 이루는 일본 대표 요리',
    brands: ['스시로', '쿠우쿠우', '스시하우스'],
  ),
  Food(
    name: '라멘',
    description: '진한 육수와 쫄깃한 면발의 깊은 풍미',
    brands: ['멘야산다이메', '이치란', '하카타분코'],
  ),
  Food(
    name: '돈까스',
    description: '바삭한 튀김옷 속 부드러운 고기의 조화',
    brands: ['카츠8', '미소야', '돈까스클럽'],
  ),

  // 양식
  Food(
    name: '피자',
    description: '치즈와 토핑이 가득한 모두의 최애 메뉴',
    brands: ['도미노피자', '피자헛', '미스터피자'],
  ),
  Food(
    name: '파스타',
    description: '소스와 면이 어우러진 이탈리아 감성 요리',
    brands: ['서가앤쿡', '바릴라', '매드포갈릭'],
  ),
  Food(
    name: '햄버거',
    description: '한 손에 들고 먹는 든든한 패스트푸드',
    brands: ['맥도날드', '버거킹', '맘스터치'],
  ),

  // 기타
  Food(
    name: '치킨',
    description: '바삭한 튀김과 육즙 가득한 국민 야식',
    brands: ['BBQ', '교촌치킨', 'BHC'],
  ),
  Food(
    name: '쌀국수',
    description: '깔끔한 육수와 향신료가 어우러진 베트남 요리',
    brands: ['포메인', '에머이', '미분당'],
  ),
  Food(
    name: '카레',
    description: '향신료의 깊은 맛이 매력적인 든든한 한 끼',
    brands: ['아비꼬', '코코이찌방야', '카레마루'],
  ),
];