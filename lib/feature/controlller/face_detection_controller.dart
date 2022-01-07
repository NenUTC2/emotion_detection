import 'dart:developer';

import 'package:google_ml_kit/google_ml_kit.dart';

class FaceDetetorController {
  FaceDetector? _faceDetector;

  Future<List<Face>?> processImage(inputImage) async {
    _faceDetector = GoogleMlKit.vision.faceDetector(
      const FaceDetectorOptions(
        enableClassification: true,
        enableLandmarks: true,
        enableContours: true,
        // enableTracking: true,
      ),
    );

    final faces = await _faceDetector?.processImage(inputImage);
    inspect(faces);
    return faces;
  }
}
