import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget buildCard(
    String title, IconData icon, String description, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              if (kDebugMode) {
                print("Information Icon clicked");
              }
            },
          ),
        ],
      ),
    ),
  );
}
