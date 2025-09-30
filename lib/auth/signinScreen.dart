import 'package:dermaai/customClass/CustomTextFormFeild.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../customClass/CustomButton.dart';
import '../customClass/customGradientContainer.dart';

class Signinscreen extends StatefulWidget {
  const Signinscreen({super.key});

  @override
  State<Signinscreen> createState() => _SigninscreenState();
}

class _SigninscreenState extends State<Signinscreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomGradientContainer(
        heightFactor: 1,
        widthFactor: 1,
        child: Column(
          children: [
            SizedBox(height: 20),
            Image.asset(
              'assets/images/image1.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height * 0.2,
            ),

            Text(
              'Welcome !',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 20),
            CustomTextFormField(
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
              },
            ),
            SizedBox(height: 10),
            CustomTextFormField(
              controller: passwordController,
              hintText: 'Enter your Password',
              prefixIcon: Icons.lock,
              obscureText: true,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                } else {
                  return null;
                }
              },
            ),
            SizedBox(height: 20),
            CustomButton(
              text: 'Sign In',
              onPressed: () {
                // yahan sign-in logic lagao
              },
              width: MediaQuery.of(context).size.width * 0.8, // thoda chhota
              color: Colors.purple,                           // koi bhi color
            ),
          ],
        ),
      ),
    );
  }
}
