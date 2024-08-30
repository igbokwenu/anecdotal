import 'package:flutter/material.dart';

class PoweredByAnecdotalAI extends StatelessWidget {
  const PoweredByAnecdotalAI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            // color: Colors.teal.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.auto_awesome,
            size: 12,
          ),
          SizedBox(width: 8),
          Text(
            'Powered By Anecdotal',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.health_and_safety,
            size: 12,
          ),
        ],
      ),
    );
  }
}
