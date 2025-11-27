import 'package:firebase_auth/firebase_auth.dart';

class ScanResult {
  final String id;
  final String disease;
  final double confidence;
  final String advice;
  final String imagePath;
   DateTime timestamp = DateTime.now();
   final String userId;




  ScanResult({
    required this.disease,
    required this.confidence,
    required this.advice,
    required this.imagePath,
     DateTime? timestamp,
    required this.userId,
    required this .id
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
       'disease': disease,
      'confidence': confidence,
      'advice': advice,
      'imagePath': imagePath,
      'timestamp': timestamp.toIso8601String(),
      'userId': userId,
    };
  }
  // 👇 Firebase se data lene ke liye
  factory ScanResult.fromMap(Map<String, dynamic> map) {
    return ScanResult(
      disease: map['disease'] ?? 'Unknown',
      confidence: (map['confidence'] ?? 0).toDouble(),
      advice: map['advice'] ?? '',
      imagePath: map['imagePath'] ?? '',
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      userId: map['userId'] ?? '',
      id: map['id'] ?? '',
    );
  }
}


