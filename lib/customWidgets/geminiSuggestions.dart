// import 'package:flutter/material.dart';
//
// class GeminiSuggestions extends StatelessWidget {
//   final String advice;
//   const GeminiSuggestions({super.key, required this.advice});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Heading
//         Text(
//           "Gemini AI Suggestions",
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             color: Colors.grey[800],
//           ),
//         ),
//         const SizedBox(height: 10),
//
//         // ExpansionTile for advice
//         ExpansionTile(
//           leading: const Icon(
//             Icons.lightbulb_outline,
//             color: Colors.blueAccent,
//           ),
//           title: const Text(
//             "Gemini AI Suggestions",
//             style: TextStyle(fontWeight: FontWeight.w600),
//           ),

import 'package:flutter/material.dart';

class GeminiSuggestions extends StatelessWidget {
  final String advice;
  final String diseaseName;

  const GeminiSuggestions({
    super.key,
    required this.advice,
    required this.diseaseName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🧠 Title Heading
        Text(
          "Gemini AI Suggestions",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.blueGrey[800],
          ),
        ),
        const SizedBox(height: 10),

        // 💡 Expandable Suggestion Tile
        ExpansionTile(
          initiallyExpanded: true,
          leading: const Icon(
            Icons.lightbulb_outline,
            color: Colors.blueAccent,
          ),
          title: const Text(
            "Tap to view AI advice",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                  children: [
                    // 🩺 Disease Name
                    TextSpan(
                      text: "Detected Disease: ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    TextSpan(
                      text: "$diseaseName\n\n",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),

                    // 🧠 Gemini Advice
                    TextSpan(
                      text: "AI Advice: ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    TextSpan(
                      text: advice,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
