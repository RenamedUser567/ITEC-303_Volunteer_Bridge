import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});

  final List<Map<String, String>> allNotifications = [
    {"title": "Lorem", "time": "1s", "status": "Unread"},
    {"title": "Lorem", "time": "1s", "status": "Unread"},
    {"title": "Lorem", "time": "1d", "status": "Unread"},
    {"title": "Lorem", "time": "1w", "status": "All"},
    {"title": "Lorem", "time": "more than 30 days", "status": "All"},
    {"title": "Lorem", "time": "more than 30 days", "status": "All"},
  ];

  @override
  Widget build(BuildContext context) {
    final unread = allNotifications
        .where((notification) => notification['status'] == 'Unread')
        .toList();

    final read = allNotifications
        .where((notification) => notification['status'] == 'All')
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(155, 93, 229, 1),
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Colors.black),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            _buildNotificationSection('Unread', unread, isRead: false),
            _buildNotificationSection('All', read, isRead: true),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection(
      String title, List<Map<String, String>> items,
      {required bool isRead}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...items.map(
            (notification) => _buildNotificationItem(notification, isRead)),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildNotificationItem(Map<String, String> notification, bool isRead) {
    return Container(
      decoration: BoxDecoration(
        color: isRead
            ? const Color.fromARGB(255, 239, 236, 239)
            : const Color.fromARGB(255, 238, 230, 249),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.handshake, size: 40, color: Colors.black),
        title: Row(
          children: [
            Text(
              notification['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(width: 10),
            Text(
              notification['time']!,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        subtitle: const Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore',
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
