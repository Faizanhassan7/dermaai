import 'package:dermaai/auth/signupScreen.dart';
import 'package:dermaai/customWidgets/mainNavi.dart';
import 'package:dermaai/libs/libraries.dart';
import 'package:flutter/gestures.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../customWidgets/CustomButton.dart';
import '../customWidgets/customGradientContainer.dart';
import '../veiws/homeScreen.dart';

class Signinscreen extends StatefulWidget {
  const Signinscreen({super.key});

  @override
  State<Signinscreen> createState() => _SigninscreenState();
}

class _SigninscreenState extends State<Signinscreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();
    return Scaffold(
      body: CustomGradientContainer(
        colors: [
          Color(0xFFB993D6), // lavender
          Color(0xFF8CA6DB), // soft blue
          Color(0xFFF5E6FF), // pale skin tone
        ],

        heightFactor: 1,
        widthFactor: 1,
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
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
                  fieldType: FieldType.email,
                ),
                SizedBox(height: 5),
                CustomTextFormField(
                  controller: passwordController,
                  hintText: 'Enter your Password',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  fieldType: FieldType.password,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        if (emailController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please enter your email',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                          return;
                        }
                        try {
                          await context.read<AuthViewModel>().sendPasswordReset(
                            emailController.text.trim(),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Password reset email sent!(check your email spam folder)',
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(e.toString())));
                        }
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                authVM.loading
                    ? TweenAnimationBuilder<Color?>(
                        tween: ColorTween(
                          begin: Colors.purple,
                          end: Colors.blue,
                        ),
                        duration: Duration(seconds: 2),
                        builder: (context, color, child) {
                          return CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(color!),
                            strokeWidth: 6,
                          );
                        },
                      )
                    : CustomButton(
                        color: const Color(0xff7226FF),
                        width: MediaQuery.of(context).size.width * 0.8,
                        text: 'Sign In',
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Signing in...')),
                            );
                            try {
                              await context.read<AuthViewModel>().signIn(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                              emailController.clear();
                              passwordController.clear();

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Homescreen(),
                                ),
                              );
                              // success → navigate
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          }
                        },
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 80, // jitna chahiye utna
                      child: Divider(thickness: 1, color: Colors.black),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('OR', style: TextStyle(color: Colors.black)),
                    ),
                    SizedBox(
                      width: 80,
                      child: Divider(thickness: 1, color: Colors.black),
                    ),
                  ],
                ),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.8,
                      50,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.google,
                    color: Colors.red, // Google G color
                  ),
                  label: Text(
                    'Sign in with Google',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  onPressed: () async {
                    try {
                      final user = await context
                          .read<AuthViewModel>()
                          .signInWithGoogle();

                      if (user != null) {
                        final isNewUser =
                            user.additionalUserInfo?.isNewUser ?? false;

                        if (isNewUser) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Account created successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Signed in successfully!'),
                              backgroundColor: Colors.blue,
                            ),
                          );
                        }

                        // navigate after a small delay
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainNav(),
                            ),
                          );
                        });
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                ),
                SizedBox(height: 10),

                RichText(
                  text: TextSpan(
                    text: 'Don’t have an account? ',
                    style: TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Signupscreen(),
                              ),
                            );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
