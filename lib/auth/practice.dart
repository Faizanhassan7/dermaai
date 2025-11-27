import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Practice extends StatefulWidget {
  const Practice({super.key});

  @override
  State<Practice> createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 🔹 Function to add data to Firestore
  Future<void> addPracticeData() async {
    try {
      await _firestore.collection('practiceData').add({
        'title': 'Testing Collection',
        'description': 'This is a sample Firestore write test',
        'createdAt': DateTime.now(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Data added to Firestore successfully")),
      );
      print("✅ Firestore document added!");
    } catch (e) {
      print("❌ Firestore error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore Practice"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: addPracticeData,
          child: const Text("Add to Firestore"),
        ),
      ),
    );
  }
}
