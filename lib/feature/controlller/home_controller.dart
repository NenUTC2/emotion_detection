import 'dart:developer';

import 'package:camera/camera.dart';
import 'camera_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'face_detection_controller.dart';

class HomeController extends GetxController {
  CameraManager? _cameraManager;
  CameraController? cameraController;
  FaceDetetorController? _faceDetect;
  bool _isDetecting = false;
  List<Face>? faces;
  String? faceAtMoment = 'normal_face.png';
  String? label = 'No face detected';
  Rect? curRect;

  HomeController() {
    _cameraManager = CameraManager();
    _faceDetect = FaceDetetorController();
  }

  Future loadCamera() async {
    cameraController = await _cameraManager?.load();
    update();
  }

  Future<void> startImageStream() async {
    cameraController?.startImageStream((cameraImage) async {
      if (_isDetecting) return;

      _isDetecting = true;
      var inputImage = prepareInputImage(cameraImage);
      processImage(inputImage);
    });
  }

  Future<void> processImage(inputImage) async {
    faces = await _faceDetect?.processImage(inputImage);

    if (faces != null && faces!.isNotEmpty) {
      Face? face = faces?.first;
      inspect(face);
      curRect = face!.boundingBox;
      label = detectSmile(face.smilingProbability);
    } else {
      faceAtMoment = 'normal_face.png';
      label = 'No face detected';
      curRect = const Rect.fromLTRB(0.0, 0.0, 0.0, 0.0);
    }
    _isDetecting = false;
    update();
  }

  String detectSmile(smileProb) {
    if (smileProb > 0.2) {
      faceAtMoment = 'happy_face.png';
      return 'Smile';
    } else {
      faceAtMoment = 'sady_face.png';
      return 'Normal';
    }
  }

  InputImage prepareInputImage(CameraImage cameraImage) {
    CameraDescription camera = cameraController!.description;
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in cameraImage.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

    final InputImageRotation imageRotation =
        InputImageRotationMethods.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.Rotation_0deg;

    final InputImageFormat inputImageFormat =
        InputImageFormatMethods.fromRawValue(cameraImage.format.raw) ??
            InputImageFormat.NV21;

    final List<InputImagePlaneMetadata>? planeData = cameraImage.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      inputImageData: inputImageData,
    );

    return inputImage;
  }
}
