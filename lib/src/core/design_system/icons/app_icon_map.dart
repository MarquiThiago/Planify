import 'package:flutter/material.dart';

/// Maps Material Icons string names (as stored in the database) to [IconData].
///
/// Usage:
/// ```dart
/// final icon = AppIconMap.fromString(category.icon); // never null
/// ```
abstract final class AppIconMap {
  static const IconData _fallback = Icons.label_outline;

  static const Map<String, IconData> _map = {
    // Food & drink
    'restaurant': Icons.restaurant,
    'local_dining': Icons.local_dining,
    'fastfood': Icons.fastfood,
    'local_cafe': Icons.local_cafe,
    'local_bar': Icons.local_bar,
    'shopping_cart': Icons.shopping_cart,

    // Transport
    'directions_car': Icons.directions_car,
    'flight': Icons.flight,
    'directions_bus': Icons.directions_bus,
    'directions_bike': Icons.directions_bike,
    'local_taxi': Icons.local_taxi,
    'train': Icons.train,

    // Home & living
    'home': Icons.home,
    'apartment': Icons.apartment,
    'electrical_services': Icons.electrical_services,
    'water_drop': Icons.water_drop,
    'wifi': Icons.wifi,

    // Health
    'favorite': Icons.favorite,
    'local_hospital': Icons.local_hospital,
    'medical_services': Icons.medical_services,
    'fitness_center': Icons.fitness_center,
    'spa': Icons.spa,

    // Education
    'school': Icons.school,
    'menu_book': Icons.menu_book,
    'laptop': Icons.laptop,

    // Entertainment & leisure
    'sports_esports': Icons.sports_esports,
    'movie': Icons.movie,
    'music_note': Icons.music_note,
    'sports_soccer': Icons.sports_soccer,
    'hiking': Icons.hiking,

    // Shopping & personal
    'checkroom': Icons.checkroom,
    'card_giftcard': Icons.card_giftcard,
    'subscriptions': Icons.subscriptions,
    'pets': Icons.pets,

    // Finance & work
    'work': Icons.work,
    'trending_up': Icons.trending_up,
    'account_balance': Icons.account_balance,
    'savings': Icons.savings,
    'sync': Icons.sync,
    'star': Icons.star,
    'payments': Icons.payments,

    // Generic
    'category': Icons.category,
    'label_outline': Icons.label_outline,
    'attach_money': Icons.attach_money,
    'monetization_on': Icons.monetization_on,
  };

  /// Returns the [IconData] for [name], or [Icons.label_outline] if not found.
  static IconData fromString(String? name) =>
      name != null ? _map[name] ?? _fallback : _fallback;
}
