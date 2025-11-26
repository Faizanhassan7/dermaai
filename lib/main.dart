// import 'package:dermaai/libs/libraries.dart';
// import 'package:dermaai/veiwsModels/scanVeiwModel.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'auth/signinScreen.dart';
// import 'firebase_options.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//   final scanVM = ScanViewModel();
//
//
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthViewModel()),
//         ChangeNotifierProvider(create: (_) => ScanViewModel()),
//
//       ],
//       child: MaterialApp(debugShowCheckedModeBanner: false,
//         home: Signinscreen(),
//         theme: ThemeData(
//           textTheme: GoogleFonts.poppinsTextTheme(),
//           primaryColor: Colors.purple,
//           inputDecorationTheme: InputDecorationTheme(
//             filled: true,
//             fillColor: Colors.white,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//           elevatedButtonTheme: ElevatedButtonThemeData(
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//               backgroundColor: Colors.purple,
//               foregroundColor: Colors.white,
//               textStyle: TextStyle(fontSize: 18),
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }
// main.dart
import 'package:dermaai/libs/libraries.dart';
import 'package:dermaai/veiwsModels/authVeiwModel.dart';
import 'package:dermaai/veiwsModels/scanVeiwModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth/signinScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel()..loadSettings(), // load dark mode pref
        ),
        ChangeNotifierProvider(create: (_) => ScanViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 👇 Yeh AuthViewModel se darkMode state sunta rahega
    return Consumer<AuthViewModel>(
      builder: (context, authVM, _) {
        print("Rebuilding MyApp with isDarkMode = ${authVM.isDarkMode}");

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const Signinscreen(),

          themeMode: authVM.isDarkMode ? ThemeMode.dark : ThemeMode.light,

          // 🌞 Light theme
          theme: ThemeData(
            brightness: Brightness.light,
            textTheme: GoogleFonts.poppinsTextTheme(),
            primaryColor: Colors.purple,
            scaffoldBackgroundColor: Colors.white,
          ),

          // 🌙 Dark theme
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            textTheme:
            GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
            scaffoldBackgroundColor: const Color(0xFF121212),
            colorScheme: const ColorScheme.dark(
              primary: Colors.purpleAccent,
              secondary: Colors.cyanAccent,
            ),
          ),
        );
      },
    );
  }
}
