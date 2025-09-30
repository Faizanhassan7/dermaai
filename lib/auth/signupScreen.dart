import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../customClass/CustomTextFormFeild.dart';
import '../customClass/customGradientContainer.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomGradientContainer(
        widthFactor: 1,
        heightFactor: 1,
        child: Column(
          children: [
            Image.asset(
              'assets/images/image1.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Text(
              'Signup',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 20),
        CustomTextFormField(
          controller: nameController,
          hintText: 'Enter your Name',
          prefixIcon: Icons.email,
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your Name';
            }
            final emailRegExp = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
            if (emailRegExp.hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },),
          SizedBox(height: 10), CustomTextFormField(
              controller: emailController,
              hintText: 'Enter your Email',
              prefixIcon: Icons.email,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email';
                }
                final emailRegExp = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                if (emailRegExp.hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },)],
        ),
      ),
    );
  }
}
