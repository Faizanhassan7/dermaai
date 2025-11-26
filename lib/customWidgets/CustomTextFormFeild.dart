// // import 'package:flutter/material.dart';
// //
// // class CustomTextFormField extends StatelessWidget {
// //   final TextEditingController controller;
// //   final String hintText;
// //   final IconData prefixIcon;
// //   final bool obscureText;
// //   final String? Function(String?)? validator;
// //
// //   const CustomTextFormField({
// //     super.key,
// //     required this.controller,
// //     required this.hintText,
// //     required this.prefixIcon,
// //     this.obscureText = false,
// //     this.validator,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return TextFormField(
// //       controller: controller,
// //       obscureText: obscureText,
// //       style:  TextStyle(color: Colors.black), // text color
// //       decoration: InputDecoration(
// //         filled: true,
// //         fillColor: Colors.white.withOpacity(0.1), // transparent fill
// //         hintText: hintText,
// //         hintStyle:  TextStyle(color: Colors.black),
// //         prefixIcon: Icon(prefixIcon, color: Colors.black),
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(20),
// //         ),
// //         enabledBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(20),
// //           borderSide:  BorderSide(color: Colors.black),
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(20),
// //           borderSide:  BorderSide(color: Colors.blueAccent),
// //         ),
// //       ),
// //       validator: validator,
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
//
// class CustomTextFormField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final IconData prefixIcon;
//   final bool obscureText;
//   final String? Function(String?)? validator;
//
//   const CustomTextFormField({
//     super.key,
//     required this.controller,
//     required this.hintText,
//     required this.prefixIcon,
//     this.obscureText = false,
//     this.validator,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     // screen width nikaal lo
//     final screenWidth = MediaQuery.of(context).size.width;
//
//     return Container(
//       // har screen ka ~90% width le lega
//       width: screenWidth * 0.9,
//       margin:  EdgeInsets.symmetric(vertical: 8), // thoda spacing
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         style: const TextStyle(color: Colors.black), // text color
//         decoration: InputDecoration(
//           filled: true,
//           fillColor: Colors.white.withOpacity(0.1), // transparent fill
//           hintText: hintText,
//           hintStyle: const TextStyle(color: Colors.black),
//           prefixIcon: Icon(prefixIcon, color: Colors.black),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide:  BorderSide(color: Colors.black),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//             borderSide: const BorderSide(color: Colors.blueAccent),
//           ),
//         ),
//         validator: validator,
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';

enum FieldType { email, password, normal }

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;

  /// field type batayega kis tarah ka validation karna hai
  final FieldType fieldType;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.fieldType = FieldType.normal,
  });

  String? _validate(String? value) {
    // sabhi validators yahan
    switch (fieldType) {
      case FieldType.email:
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email';
        }
        final emailRegExp = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
        if (!emailRegExp.hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;

      case FieldType.password:
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        } else if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;

      case FieldType.normal:
        if (value == null || value.trim().isEmpty) {
          return 'This field is required';
        }
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.9,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black),
          prefixIcon: Icon(prefixIcon, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.blueAccent),
          ),
        ),
        validator: _validate,
      ),
    );
  }
}

