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
    final Size screenSize = MediaQuery.sizeOf(context);
    // final bool isMobile = screenSize.width < 600;
    final bool isTabletOrDesktop = screenSize.width >= 600;
    // final bool isLandscape = screenSize.width > screenSize.height;
    return SizedBox(
      width: isTabletOrDesktop ? 220 : 180,
      height: isTabletOrDesktop ? 150 : 180,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Icon(icon, size: 25),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Center(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 4,
                        child: Center(
                          child: Text(
                            description,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.info_outline,
                              size: 20,
                            ),
                            onPressed: onInfoTapped,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
