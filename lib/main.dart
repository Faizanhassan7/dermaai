import 'package:dermaai/auth/signinScreen.dart';
import 'package:dermaai/auth/signupScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MaterialApp(
      home: Signinscreen(),
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(), // pura app Poppins font
        primaryColor: Colors.purple,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            textStyle:  TextStyle(fontSize: 18),
          ),
        ),
      ),
    ),
  );
}
