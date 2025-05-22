import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_bridge/models/event.dart';
import 'package:volunteer_bridge/riverpod/event_list.dart';

class TagOption {
  final String name;
  bool isSelected;

  TagOption({required this.name, this.isSelected = false});
}

/// Provider to manage the list of tag options.
final tagOptionsProvider = StateProvider.autoDispose<List<TagOption>>((ref) {
  return [
    TagOption(name: "Animals", isSelected: false),
    TagOption(name: "Social Service", isSelected: false),
    TagOption(name: "Environment", isSelected: false),
    TagOption(name: "Medical Care", isSelected: false),
    TagOption(name: "Recreation and Sports", isSelected: false),
  ];
});

final selectedTagNameProvider = StateProvider<String?>((ref) => null);

final selectedTagsProvider = Provider<List<String>>((ref) {
  final tags = ref.watch(tagOptionsProvider);
  return tags.where((tag) => tag.isSelected).map((tag) => tag.name).toList();
});

void showTagPickerDialog(BuildContext context, WidgetRef ref, Event? event) {
  // Initialize temp selected tag with current state
  final selectedTag = ref.read(tagOptionsProvider).firstWhere(
        (tag) => tag.isSelected,
        orElse: () => TagOption(name: "", isSelected: false),
      );
  ref.read(selectedTagNameProvider.notifier).state = selectedTag.name;

  showDialog(
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, ref, _) {
          final selectedName = ref.watch(selectedTagNameProvider);
          final tagOptions = ref.watch(tagOptionsProvider);

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "Select a Tag",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tagOptions.map((tag) {
                  final isSelected = selectedName == tag.name;
                  return GestureDetector(
                    onTap: () {
                      ref.read(selectedTagNameProvider.notifier).state =
                          tag.name;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? const Color(0xFFB768DE) : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFB768DE)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        tag.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB768DE),
                ),
                onPressed: () async {
                  final selected = ref.read(selectedTagNameProvider);
                  if (selected != null && selected.isNotEmpty) {
                    // Update tag options in provider
                    final updated = tagOptions.map((tag) {
                      return TagOption(
                        name: tag.name,
                        isSelected: tag.name == selected,
                      );
                    }).toList();
                    ref.read(tagOptionsProvider.notifier).state = updated;

                    // Save to Firebase
                    if (event != null) {
                      final updated = event.copyWith(tag: selected);
                      ref
                          .read(eventNotifierProvider.notifier)
                          .updateEvent(updated);
                    }
                  }
                  Navigator.of(context).pop();
                },
                child: const Text("Save"),
              ),
            ],
          );
        },
      );
    },
  );
}

void showTagFilterSearchDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (context) {
      return Consumer(
        builder: (context, ref, _) {
          final tagOptions = ref.watch(tagOptionsProvider);

          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              "Filter by Tags",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tagOptions.map((tag) {
                  return GestureDetector(
                    onTap: () {
                      final updatedTags = tagOptions.map((t) {
                        if (t.name == tag.name) {
                          return TagOption(
                            name: t.name,
                            isSelected: !t.isSelected,
                          );
                        }
                        return t;
                      }).toList();

                      ref.read(tagOptionsProvider.notifier).state = updatedTags;
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: tag.isSelected
                            ? const Color(0xFFB768DE)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: tag.isSelected
                              ? const Color(0xFFB768DE)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        tag.name,
                        style: TextStyle(
                          color: tag.isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
              TextButton(
                onPressed: () {
                  // Clear all selected tags
                  final cleared = tagOptions
                      .map(
                          (tag) => TagOption(name: tag.name, isSelected: false))
                      .toList();
                  ref.read(tagOptionsProvider.notifier).state = cleared;
                  Navigator.of(context).pop();
                },
                child: const Text("Clear Filters"),
              ),
              TextButton(
                onPressed: () {
                  /*
                  final selectedTagNames = tagOptions
                      .where((tag) => tag.isSelected)
                      .map((tag) => tag.name)
                      .toList();

                  //ref.read(selectedTagsProvider.notifier).state = selectedTagNames;
                  */
                  Navigator.of(context).pop();
                },
                child: const Text("Apply"),
              ),
            ],
          );
        },
      );
    },
  );
}
