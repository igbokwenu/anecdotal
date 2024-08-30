import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String description;
  final VoidCallback onTap;
  final VoidCallback onInfoTapped;

  const CustomCard({
    required this.title,
    required this.icon,
    required this.description,
    required this.onTap,
    required this.onInfoTapped,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 140,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 25),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // const SizedBox(height: 4),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                // const SizedBox(height: 16),
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    size: 20,
                  ),
                  onPressed: onInfoTapped,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
