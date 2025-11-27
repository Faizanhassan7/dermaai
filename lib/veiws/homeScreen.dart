import 'dart:io';

import 'package:dermaai/libs/libraries.dart';
import 'package:dermaai/veiws/historyScreen.dart';
import 'package:dermaai/veiws/resultScreen.dart';
import 'package:dermaai/veiws/scanScreen.dart';
import '../customWidgets/actionContainer.dart';
import '../customWidgets/customHeaderWidget.dart';
import '../models/scanResultModel.dart';
import '../veiwsModels/scanVeiwModel.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      body: SingleChildScrollView(
        child: CustomGradientContainer( colors: [
          Color(0xFF0F2027),
          Color(0xFF203A43),
          Color(0xFF2C5364),
        ],
          // colors: [Color(0xFF00B4DB), Color(0xFF0083B0), Color(0xFF4B79A1)],
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 👇 Ab simple ek line me header
                  CustomHeaderWidget(
                    userName: authVM.userName,
                    loading: authVM.loading,
                    imageUrl: authVM.userImage,
                  ),

                  SizedBox(height: 30),

                  authVM.loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : AnimatedIconContainer(
                          label: 'Start a New Skin Analysis',
                          icon: Icons.camera_alt,
                          gradientColors: [
                            Color(0xFF36D1DC), // Cyan
                            Color(0xFF5B86E5), // Soft Blue-Purple
                            Color(0xFF5B86E5),
                            // Teal
                          ],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Scanscreen(),
                              ),
                            );
                          },
                        ),
                  SizedBox(height: 30),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Scans',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF36D1DC),
                              Color(0xFF5B86E5),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.4),
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HistoryScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'View All',
                            style: TextStyle(
                              fontSize: 13.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),


                  FutureBuilder<List<ScanResult>>(
                    future: context.read<ScanViewModel>().fetchRecentScans(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text(
                          'Error loading scans',
                          style: TextStyle(color: Colors.white),
                        );
                      }

                      final result = snapshot.data ?? [];
                      if (result.isEmpty) {
                        return Text(
                          'No recent scans yet',
                          style: TextStyle(color: Colors.white70),
                        );
                      }
                      return SizedBox(
                        height: 170,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: result.length,
                          itemBuilder: (context, index) {
                            final scan = result[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Resultscreen(
                                      result:
                                          "Disease: ${scan.disease}\nConfidence: ${scan.confidence.toStringAsFixed(1)}%",
                                      image: File(scan.imagePath),
                                      advice: scan.advice,
                                      diseaseName: scan.disease,
                                      isFromHistory: true,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 140,
                                margin: const EdgeInsets.only(right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.15),
                                      Colors.white.withOpacity(0.05),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1.2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.circular(14),
                                    //   child: Image.file(
                                    //     File(scan.imagePath),
                                    //     height: 80,
                                    //     width: 80,
                                    //     fit: BoxFit.cover,
                                    //   ),
                                    // ),
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.circular(14),
                                    //   child: scan.imagePath.startsWith('http')
                                    //       ? Image.network(
                                    //     scan.imagePath,
                                    //     height: 80,
                                    //     width: 80,
                                    //     fit: BoxFit.cover,
                                    //   )
                                    //       : Image.file(
                                    //     File(scan.imagePath),
                                    //     height: 80,
                                    //     width: 80,
                                    //     fit: BoxFit.cover,
                                    //   ),
                                    // ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: File(scan.imagePath).existsSync()
                                          ? Image.file(
                                        File(scan.imagePath),
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      )
                                          : Image.network(
                                        scan.imagePath,
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),


                                    const SizedBox(height: 8),
                                    Text(
                                      scan.disease,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        scan.timestamp
                                            .toLocal()
                                            .toString()
                                            .split(' ')[0],
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
