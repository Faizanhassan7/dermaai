
import 'package:flutter/material.dart';

class CustomHeaderWidget extends StatelessWidget {
  final String userName;
  final bool loading;
  final String? imageUrl;

  const CustomHeaderWidget({
    super.key,
    required this.userName,
    required this.loading,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            loading
                ? const Row(
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "Loading user...",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ],
            )
                : Text(
              "Hello, $userName 👋",
              style:  TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
             SizedBox(height: 4),
             Text(
              "Welcome back!",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),

        // Right profile image
        CircleAvatar(
          radius: 28,
          backgroundImage: (imageUrl != null && imageUrl!.isNotEmpty)
              ? NetworkImage(imageUrl!)
              : AssetImage("assets/images/image1.png") as ImageProvider,
        )

      ],
    );
  }
}
