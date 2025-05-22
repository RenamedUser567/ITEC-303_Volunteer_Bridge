import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_bridge/ScreensOrganizer/org_edit_tag.dart';

final selectedTagsProvider = Provider<List<String>>((ref) {
  final tags = ref.watch(tagOptionsProvider);
  return tags.where((tag) => tag.isSelected).map((tag) => tag.name).toList();
});
