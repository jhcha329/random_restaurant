import 'package:flutter/material.dart';
import 'food_card.dart';
import 'package:random_restaurant/food_data.dart';

class FoodCardSwitcher extends StatelessWidget {
  final Food food;
  final Color accent;

  const FoodCardSwitcher({
    super.key,
    required this.food,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: 0.96, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
      child: FoodCard(
        key: ValueKey(food.name),
        food: food,
        accent: accent,
      ),
    );
  }
}