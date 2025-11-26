import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import '../models/scanResultModel.dart';
import '../veiws/resultScreen.dart';
import 'dart:math' as math; // ye import upar likhna mat bhoolna
import 'package:path_provider/path_provider.dart';

class ScanViewModel extends ChangeNotifier {
  bool saving = false;

  Future<void> saveResult({
    required String disease,
    required double confidence,
    required String advice,
    required File imageFile, // Hum File object le rahe hain, path nahi
    required DateTime timestamp,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint("❌ User not logged in. Cannot save.");
      return;
    }

    saving = true;
    notifyListeners();

    try {
      // ===== NAYA STEP 1: IMGBB PAR IMAGE UPLOAD KARO =====
      final String? downloadUrl = await uploadToImgBB(imageFile);

      // Check karo ki image upload hui ya nahi
      if (downloadUrl == null) {
        debugPrint("❌ Image upload failed. Data will not be saved.");
        // Yahan user ko error dikha sakte ho
        // ScaffoldMessenger.of(context).showSnackBar...
        saving = false;
        notifyListeners();
        return; // Function ko yahin rok do
      }

      // ===== STEP 2: FIRESTORE ME SAHI DATA SAVE KARO =====
      // final result = ScanResult(
      //   disease: disease,
      //   confidence: confidence,
      //   advice: advice,
      //   imagePath: downloadUrl, // <<< YAHAN AB IMGBB KA LINK SAVE HOGA
      //   timestamp: timestamp,
      //   userId: user.uid,
      // );
      // Local copy bhi store karo ImgBB se download karke
      final localPath = await cacheImageLocally(
        downloadUrl,
        'scan_${timestamp.millisecondsSinceEpoch}.jpg',
      );

      // Fir dono paths save karo (local aur online)
      final result = ScanResult(
        disease: disease,
        confidence: confidence,
        advice: advice,
        imagePath: localPath,
        // 👈 ab ye local ya online dono me se jo available hai wo save karega
        timestamp: timestamp,
        userId: user.uid,
        id: '',
      );

      // await FirebaseFirestore.instance
      //     .collection('scanResults')
      //     .add(result.toJson());
      final collection = FirebaseFirestore.instance.collection('scanResults');
      final docRef = await collection.add(result.toJson());

// ab doc ki apni Firebase ID mil gayi
      await docRef.update({'id': docRef.id});
      debugPrint("✅ Scan saved with Firestore ID: ${docRef.id}");
      debugPrint(
        "✅ Scan result with ImgBB URL saved to Firebase successfully!",
      );
    } catch (e) {
      debugPrint("❌ Error saving scan result to Firestore: $e");
    }

    saving = false;
    notifyListeners();
  }

  String? diseaseName;
  double? confidence;
  String? advice;
  File? selectedImage;
  String? predictionResult;
  bool isLoading = false;
  Interpreter? _interpreter;
  List<String>? _labels;

  final picker = ImagePicker();

  /// ---------------- Gemini API ----------------
  Future<String> getGeminiAdvice(String diseaseName) async {
    const String apiKey = "AIzaSyCQBJ7w4wzbgN9cfCtA2g8Y0Gm2Vroksac";
    const String model = "gemini-2.0-flash";

    // Ye Gemini ka public endpoint hai (AI Studio)
    final url = Uri.parse(
      "https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent?key=$apiKey",
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                      "A person is diagnosed with $diseaseName (a skin disease). Give short professional preventive care tips in bullet points.",
                },
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Yahan se text extract hota hai (sahi structure)
        final String result =
            data['candidates'][0]['content']['parts'][0]['text'];

        return result.isEmpty ? "No advice found." : result;
      } else {
        return "Gemini API error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "Error fetching Gemini advice: $e";
    }
  }

  Future<void> pickFromCamera(BuildContext context) async {
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      selectedImage = File(picked.path);
      notifyListeners();
      await analyzeImage(context);
    }
  }

  Future<void> pickFromGallery(BuildContext context) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage = File(picked.path);
      notifyListeners();
      await analyzeImage(context);
    }
  }

  Future<void> analyzeImage(BuildContext context) async {
    if (_interpreter == null) {
      await loadModel(context); // Pass context
    }

    isLoading = true;
    notifyListeners();

    try {
      // Load and resize image manually
      img.Image? inputImage = img.decodeImage(
        await selectedImage!.readAsBytes(),
      );
      if (inputImage != null) {
        img.Image resizedImage = img.copyResize(
          inputImage,
          width: 224,
          height: 224,
        );

        // Convert to tensor (assuming model expects float32 input)
        Float32List input = imageToByteListFloat32(resizedImage, 224);
        var output = List.generate(1, (_) => List.filled(_labels!.length, 0.0));

        // Run model
        // _interpreter!.run(input, output);
        var inputTensor = input.reshape([1, 224, 224, 3]);
        _interpreter!.run(inputTensor, output);

        // Get prediction result
        // Convert output to double list
        List<double> prediction = output[0].cast<double>();
        double expSum = prediction
            .map((e) => math.exp(e))
            .reduce((a, b) => a + b);
        prediction = prediction.map((e) => math.exp(e) / expSum).toList();

        // Normalize agar sum > 1 ho (kabhi kabhi output softmax nahi hota)
        double sum = prediction.reduce((a, b) => a + b);
        if (sum > 1.0) {
          prediction = prediction.map((e) => e / sum).toList();
        }

        // Prepare readable result text
        StringBuffer buffer = StringBuffer();
        for (int i = 0; i < _labels!.length; i++) {
          buffer.writeln(
            "${_labels![i]}: ${(prediction[i] * 100).toStringAsFixed(1)}%",
          );
        }

        // Find highest probability
        //         int maxIndex = prediction.indexOf(
        //             prediction.reduce((a, b) => a > b ? a : b));
        //
        //         predictionResult =
        //         "Top Prediction: ${_labels![maxIndex]} (${(prediction[maxIndex] * 100)
        //             .toStringAsFixed(1)}%)\n\n"
        //             "All Predictions:\n${buffer.toString()}";
        // Find highest probability (top disease)
        int maxIndex = prediction.indexOf(
          prediction.reduce((a, b) => a > b ? a : b),
        );

        // String diseaseName = _labels![maxIndex];
        // double confidence = prediction[maxIndex] * 100;
        //
        // // ✅ Step 1: Gemini se preventive advice lo
        // String geminiAdvice = await _getGeminiAdvice(diseaseName);
        // Top prediction
        diseaseName = _labels![maxIndex];
        confidence = prediction[maxIndex] * 100;
        advice = await getGeminiAdvice(diseaseName!);
        // ✅ Step 3: Display result + advice
        predictionResult =
            "🧠 Disease: $diseaseName\n"
            "📊 Confidence: ${confidence!.toStringAsFixed(1)}%\n\n"
            "📋 All Predictions:\n${buffer.toString()}";
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => Resultscreen(
              // Corrected to match import
              result: predictionResult ?? "No result",
              image: selectedImage!,
              advice: advice ?? "No advice",
              diseaseName: diseaseName!,
            ),
          ),
        );
      } else {
        predictionResult = "Error: Unable to decode image";
      }
    } catch (e) {
      predictionResult = "Error analyzing image: $e";
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loadModel(BuildContext context) async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/aiModels/isic_model_float32.tflite',
      );
      _labels = await _loadLabels(context, 'assets/aiModels/labels.txt');
      print("✅ Model loaded successfully!");
    } catch (e) {
      print("❌ Error loading model: $e");
    }
  }

  // Custom method to load labels with context
  Future<List<String>> _loadLabels(
    BuildContext context,
    String assetPath,
  ) async {
    final data = await DefaultAssetBundle.of(context).loadString(assetPath);
    return data.split('\n').where((line) => line.isNotEmpty).toList();
  }

  // Helper method to convert image to Float32List tensor
  Float32List imageToByteListFloat32(img.Image image, int inputSize) {
    // 4D tensor: [1, height, width, channels] → total size = 1*inputSize*inputSize*3
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    int pixelIndex = 0;

    for (int i = 0; i < inputSize; i++) {
      for (int j = 0; j < inputSize; j++) {
        var pixel = image.getPixel(j, i);
        // Normalize pixels to [-1,1] or [0,1] depending on your model
        convertedBytes[pixelIndex++] = (img.getRed(pixel) - 127.5) / 127.5;
        convertedBytes[pixelIndex++] = (img.getGreen(pixel) - 127.5) / 127.5;
        convertedBytes[pixelIndex++] = (img.getBlue(pixel) - 127.5) / 127.5;
      }
    }

    return convertedBytes;
  }

  // for home screen data fetching
  Future<List<ScanResult>> fetchRecentScans() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('scanResults')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy('timestamp', descending: true)
          .limit(3)
          .get();

      return snapshot.docs
          .map((doc) => ScanResult.fromMap(doc.data()))
          .toList();
    } catch (e) {
      debugPrint("❌ Error fetching scans: $e");
      return [];
    }
  }

  // for history screen data fecthing
  Future<List<ScanResult>> fetchAllScans() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('scanResults')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy('timestamp', descending: true)
          .get();
    //   return snapshot.docs
    //       .map((doc)
    //   => ScanResult.fromMap(doc.data()))
    //       .toList();
    // }
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // ✅ yeh add karo
        return ScanResult.fromMap(data);
      }).toList();
    }
    catch (e) {
      debugPrint("❌ Error fetching all scans: $e");
      return [];
    }
  }

  // ++++++++++++++++ YEH POORA FUNCTION COPY-PASTE KARO ++++++++++++++++

  // Function to upload image to ImgBB and get a public URL
  Future<String?> uploadToImgBB(File imageFile) async {
    // -----------------------------------------------------------------
    //  >>>>>>> APNI API KEY YAHAN PASTE KARO <<<<<<<
    // -----------------------------------------------------------------
    const String apiKey =
        '0cf57342bcb9b1acc000e9a4f240a1f9'; // YEH AAPKI KEY HAI

    final url = Uri.parse('https://api.imgbb.com/1/upload');

    try {
      // Create a multipart request to send the image file
      var request = http.MultipartRequest('POST', url)
        ..fields['key'] = apiKey
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));

      debugPrint("📤 Uploading image to ImgBB...");

      // Send the request
      var response = await request.send();

      // Check the response
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);

        // Get the URL from the response
        final imageUrl = jsonResponse['data']['url'];
        debugPrint("✅ Image uploaded to ImgBB. URL: $imageUrl");
        return imageUrl;
      } else {
        debugPrint("❌ ImgBB upload failed. Status: ${response.statusCode}");
        final errorBody = await response.stream.bytesToString();
        debugPrint("Error Body: $errorBody");
        return null; // Return null if upload fails
      }
    } catch (e) {
      debugPrint("❌ Exception during ImgBB upload: $e");
      return null; // Return null on any other error
    }
  }

  // ======================= LOCAL + CLOUD IMAGE HANDLING =======================

  /// ye function ImgBB image ko download karke local save karta hai
  Future<String> cacheImageLocally(String imageUrl, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final localPath = '${dir.path}/$fileName';
      final file = File(localPath);

      // agar local file already hai to wahi return karo
      if (await file.exists()) {
        debugPrint("📁 Using cached image: $localPath");
        return localPath;
      }

      // warna download karo ImgBB se
      debugPrint("🌐 Downloading image from ImgBB...");
      final response = await http.get(Uri.parse(imageUrl));
      await file.writeAsBytes(response.bodyBytes);
      debugPrint("✅ Image cached locally at: $localPath");

      return localPath;
    } catch (e) {
      debugPrint("❌ Error caching image locally: $e");
      return imageUrl; // agar local save fail ho jaaye to original URL return kar do
    }
  }

  Future<void> deleteScan(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('scanResults')
          .doc(docId)
          .delete();
      debugPrint("🗑️ Scan deleted successfully: $docId");
    } catch (e) {
      debugPrint("❌ Error deleting scan: $e");
    }
  }
}
