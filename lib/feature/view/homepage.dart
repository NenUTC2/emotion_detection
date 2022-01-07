import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:emotion_detect/feature/controlller/home_controller.dart';
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
        title: Text('My Emotion'),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => null,
      //   child: Icon(Icons.camera_alt),
      // ),
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
                          painter: MyCustomPainter(rect: _.curRect, size: size),
                        ),
                      ),
                    ),
                    Text(
                      '${_.label}',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                )
              : const Center(child: Text('loading'));
        },
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  Rect? rect;
  Size? size;

  MyCustomPainter({@required this.rect, this.size});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;
    var face = Rect.fromLTRB(getEdge(rect!.left) - 300, rect!.top - 100,
        getEdge(rect!.right) - 300, rect!.bottom - 100);
    canvas.drawRect(face, paint);
  }

  @override
  bool shouldRepaint(MyCustomPainter oldDelegate) {
    return true;
  }

  double getEdge(value) {
    if (value > size!.width) {
      return size!.width - (value - size!.width);
    } else if (value < size!.width) {
      return size!.width + (size!.width - value);
    } else {
      return size!.width;
    }
  }
}
