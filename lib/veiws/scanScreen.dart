import 'dart:ui';
import 'package:dermaai/libs/libraries.dart';
import '../customWidgets/actionContainer.dart';
import '../veiwsModels/scanVeiwModel.dart';

class Scanscreen extends StatelessWidget {
  const Scanscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scanVM = Provider.of<ScanViewModel>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFF00E5FF), Color(0xFF00B4DB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            "Derma AI",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
      body: CustomGradientContainer(
        heightFactor: 1,
        widthFactor: 1,
        colors: [
          Color(0xFF0F2027),
          Color(0xFF203A43),
          Color(0xFF2C5364),
        ],
        // colors: const [Color(0xFF00B4DB), Color(0xFF0083B0), Color(0xFF4B79A1)],
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 50,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),

                        // 🔹 Glowing scanner icon in a glass circle
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.4),
                                blurRadius: 25,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(25),
                          child: const Icon(
                            Icons.document_scanner_rounded,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),

                        const SizedBox(height: 30),

                        // 🔹 Headings
                        const Text(
                          'Start New Scan',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Capture or upload a clear image to let AI detect your skin condition.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 50),

                        // 🔹 Glass container for action buttons
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white24,
                                  width: 1.2,
                                ),
                              ),
                              child: Column(
                                children: [
                                  AnimatedIconContainer(
                                    label: '  Take a Photo',
                                    icon: Icons.camera_alt_rounded,
                                    gradientColors: const [
                                      Color(0xFF00C9FF),
                                      Color(0xFF92FE9D),
                                    ],
                                    onTap: () => scanVM.pickFromCamera(context),
                                  ),
                                  const SizedBox(height: 25),
                                  AnimatedIconContainer(
                                    label: '  Pick from Gallery',
                                    icon: Icons.photo_library_rounded,
                                    gradientColors: const [
                                      Color(0xFF36D1DC),
                                      Color(0xFF5B86E5),
                                    ],
                                    onTap: () =>
                                        scanVM.pickFromGallery(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // 🔹 Footer Info
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(top: 50, bottom: 20),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white30,
                                width: 1,
                              ),
                            ),
                            child: const Text(
                              ' Tip: Use bright natural light and keep the camera steady for accurate results.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
