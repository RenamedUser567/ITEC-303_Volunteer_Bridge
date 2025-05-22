import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:volunteer_bridge/riverpod/event_list.dart';

class EventInfoPageTry extends ConsumerStatefulWidget {
  final String eventId;
  const EventInfoPageTry({super.key, required this.eventId});

  @override
  ConsumerState<EventInfoPageTry> createState() => _EventInfoPageTryState();
}

class _EventInfoPageTryState extends ConsumerState<EventInfoPageTry> {
  @override
  void initState() {
    super.initState();
    ref.read(eventNotifierProvider.notifier).loadEvent(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    final event = ref.watch(eventNotifierProvider);

    if (event == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: Column(
        children: [
          Text(event.description),
          Text("Location: ${event.location}"),
          ElevatedButton(
            onPressed: () {
              final updated = event.copyWith(title: "Updated Title");
              ref.read(eventNotifierProvider.notifier).updateEvent(updated);
            },
            child: const Text("Update Title"),
          ),
        ],
      ),
    );
  }
}
