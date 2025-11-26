import 'package:dermaai/customWidgets/mainNavi.dart';
import 'package:dermaai/libs/libraries.dart';

import '../customWidgets/CustomButton.dart';

import '../customWidgets/customGradientContainer.dart';
import '../veiws/homeScreen.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nameController.dispose();
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
        widthFactor: 1,
        heightFactor: 1,
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
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
                  fieldType: FieldType.normal,
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  controller: emailController,
                  hintText: 'Enter your Email',
                  prefixIcon: Icons.email,
                  fieldType: FieldType.email,
                ),
                SizedBox(height: 10),
                CustomTextFormField(
                  controller: passwordController,
                  hintText: 'Enter your Password',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                  fieldType: FieldType.password,
                ),

                SizedBox(height: 20),
                authVM.loading
                    ? CircularProgressIndicator()
                    : CustomButton(
                        text: 'Sign Up',
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Please fill all the fields',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            );
                            return;
                          }
                          try {
                            final user = await context
                                .read<AuthViewModel>()
                                .signUp(
                                  nameController.text.trim(),
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );

                            if (user != null) {
                              // success → home ya login page
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Account created!',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainNav(),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                        width: MediaQuery.of(context).size.width * 0.8,
                        color: Color(0xff7226FF),
                      ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
