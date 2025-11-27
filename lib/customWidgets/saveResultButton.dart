import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../veiwsModels/scanVeiwModel.dart';

class SaveResultButton extends StatelessWidget {
  final bool isFromHistory;

  const SaveResultButton({super.key, this.isFromHistory = false});

  @override
  Widget build(BuildContext context) {
    // context.watch will rebuild the widget whenever notifyListeners is called
    final scanvm = context.watch<ScanViewModel>();

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0083B0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 6,
              shadowColor: Colors.blueAccent.withOpacity(0.4),
            ),
            // ✅ Disabled if from history OR currently saving
            onPressed: isFromHistory || scanvm.saving
                ? null
                : () async {
                    try {
                      if (scanvm.selectedImage != null &&
                          scanvm.diseaseName != null) {
                        await scanvm.saveResult(
                          disease: scanvm.diseaseName!,
                          confidence: scanvm.confidence ?? 0,
                          advice: scanvm.advice ?? "No advice",
                          imageFile: scanvm.selectedImage!,
                          timestamp: DateTime.now(),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              "✅ Result saved successfully!",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.orangeAccent,
                            content: Text("⚠️ No result to save"),
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text("❌ Error saving result: $e"),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
            icon: const Icon(Icons.save_alt_rounded, color: Colors.white),
            label: Text(
              isFromHistory ? "Already Saved to History" : "Save Result",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ),

        // Overlay spinner while saving
        if (scanvm.saving)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
