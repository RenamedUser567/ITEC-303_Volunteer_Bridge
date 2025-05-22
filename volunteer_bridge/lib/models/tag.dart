import 'dart:ui';

class Tag {
  final String name;
  final Color color;
  bool isSelected;

  Tag({required this.name, required this.color, this.isSelected = false});
}
