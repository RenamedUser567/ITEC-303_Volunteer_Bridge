import 'package:flutter/material.dart';


class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});

  final List<Map<String, String>> unreadnotifications = [
    {"title": "Lorem", "time": "1s", "status": "Unread"},
    {"title": "Lorem", "time": "1s", "status": "Unread"},
    {"title": "Lorem", "time": "1d", "status": "Unread"},
    {"title": "Lorem", "time": "1w", "status": "All"},
    {"title": "Lorem", "time": "more than 30 days", "status": "All"},
    {"title": "Lorem", "time": "more than 30 days", "status": "All"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
            child: Text(
              'Notification',
              style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.bold,
              )
            ),
          ),
      
          const SizedBox(height: 20),
      
          Expanded(
            child: ListView.builder(
              itemCount: unreadnotifications.length,
              itemBuilder: (context,index){
                final notification = unreadnotifications[index];
      
                return Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(238, 230, 249, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 5), 
                  child: ListTile(
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
                          style: TextStyle(fontSize: 12, 
                          color: Colors.grey[600])
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
            )
          ),
        ],
      )
    );
  }
}