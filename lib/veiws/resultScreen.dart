import 'dart:io';
import 'dart:ui';
import 'package:dermaai/customWidgets/saveResultButton.dart';
import 'package:dermaai/libs/libraries.dart';
import '../customWidgets/geminiSuggestions.dart';
import '../customWidgets/predictionTile.dart';
import '../customWidgets/warningMessage.dart';
import '../veiwsModels/scanVeiwModel.dart';

class Resultscreen extends StatelessWidget {
  final String result;
  final File image;
  final String advice;
  final String diseaseName;
  bool isFromHistory;

  Resultscreen({
    super.key,
    required this.result,
    required this.image,
    required this.advice,
    required this.diseaseName,
    this.isFromHistory = false,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> predictions = _parseResults(result);
    final scanvm = context.read<ScanViewModel>();

    return Scaffold(
      backgroundColor: Color(0xFF00B4DB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(40),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.2),
                    blurRadius: 25,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                toolbarHeight: 90,
                title: ShaderMask(
                  shaderCallback: (bounds) =>
                      LinearGradient(
                        colors: [Colors.blueAccent, Colors.cyanAccent],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(
                        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                      ),
                  child: const Text(
                    "Analysis Result",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white, // overridden by gradient
                      shadows: [
                        Shadow(
                          color: Colors.blueAccent,
                          blurRadius: 12,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                leading: Container(
                  margin: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent.withOpacity(0.3),
                        Colors.cyanAccent.withOpacity(0.2),
                      ],
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.cyanAccent.withOpacity(0.3),
                          Colors.blueAccent.withOpacity(0.2),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 📷 Image preview
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(100),
            //   child: Image.file(
            //     image,
            //     width: 180,
            //     height: 180,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: image.path.startsWith('http')
                  ? Image.network(
                      image.path,
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      image,
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
            ),

            const SizedBox(height: 24),

            // 🩺 Top heading
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Detected Conditions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              diseaseName ?? 'NO DISEASE DETECTED',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            ...predictions.entries.map((entry) {
              final value = entry.value;
              if (value is double) {
                return PredictionTile(label: entry.key, confidence: value);
              } else {
                return TextTile(label: entry.key, value: value.toString());
              }
            }),
            const SizedBox(height: 20),
            // ⚠️ Warning message
            Warningmessage(
              message:
                  "Important: This is an AI suggestion, not a medical diagnosis. Please consult a qualified doctor.",
            ),

            const SizedBox(height: 30),
            // // 💡 Suggestions section
            GeminiSuggestions(advice: advice, diseaseName: diseaseName ?? ''),

            const SizedBox(height: 5),
            SaveResultButton(isFromHistory: isFromHistory),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _parseResults(String text) {
    final Map<String, dynamic> map = {};
    final lines = text.split('\n');

    for (var line in lines) {
      if (line.trim().isEmpty) continue;

      final parts = line.split(':');
      if (parts.length == 2) {
        final key = parts[0].trim();
        final valueText = parts[1].trim().replaceAll('%', '');

        final number = double.tryParse(valueText);
        if (number != null) {
          map[key] = number; // e.g., 87%
        } else {
          map[key] = valueText; // e.g., "BKL"
        }
      }
    }
    return map;
  }
}

//backgroundColor: Color(0xFF00B4DB), appBar: AppBar( backgroundColor: Colors.white, elevation: 0, foregroundColor: Colors.black, title: const Text( "Analysis Result", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18), ), ), body: SingleChildScrollView( iss appbar ko modern vip bnao
