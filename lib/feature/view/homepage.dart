import 'package:camera/camera.dart';
import 'package:emotion_detect/feature/controlller/home_controller.dart';
import 'package:emotion_detect/feature/widget/my_custom_paint.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _homeController = HomeController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion detection'),
      ),
      body: GetBuilder<HomeController>(
        init: _homeController,
        initState: (_) async {
          await _homeController.loadCamera();
          _homeController.startImageStream();
        },
        builder: (_) {
          return _.cameraController != null &&
                  _.cameraController!.value.isInitialized
              ? Stack(
                  children: [
                    Container(
                      width: size.width,
                      height: size.height,
                      alignment: Alignment.center,
                      child: CameraPreview(
                        _.cameraController!,
                        child: CustomPaint(
                          painter: MyCustomPainter(
                              rawBoundingBox: _.faceBoundingBox, size: size),
                        ),
                      ),
                    ),
                    Text(
                      '${_.label}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                )
              : const Center(child: Text('Loading...'));
        },
      ),
    );
  }
}
