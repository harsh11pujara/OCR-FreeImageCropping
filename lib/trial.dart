import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CropImagePage(),
    );
  }
}

class CropImagePage extends StatefulWidget {
  @override
  _CropImagePageState createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  final Random random = Random();

  Future<ui.Image> loadImage() async {
    final ImageProvider imageProvider = NetworkImage('https://example.com/image.jpg');
    final ImageStream stream = imageProvider.resolve(ImageConfiguration.empty);
    final Completer<ui.Image> completer = Completer();
    stream.addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    }));
    return completer.future;
  }

  Future<ui.Image> cropRandomArea(ui.Image image) async {
    final double imageWidth = image.width.toDouble();
    final double imageHeight = image.height.toDouble();

    final double left = random.nextDouble() * imageWidth;
    final double top = random.nextDouble() * imageHeight;
    final double right = left + random.nextDouble() * (imageWidth - left);
    final double bottom = top + random.nextDouble() * (imageHeight - top);

    final cropRect = Rect.fromLTRB(left, top, right, bottom);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawImageRect(image, cropRect, cropRect, Paint());

    final picture = recorder.endRecording();
    final croppedImage = await picture.toImage(cropRect.width.toInt(), cropRect.height.toInt());

    return croppedImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Image Example'),
      ),
      body: Center(
        child: FutureBuilder<ui.Image>(
          future: loadImage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              final image = snapshot.data;
              final croppedImage = cropRandomArea(image!);

              return FutureBuilder<ui.Image>(
                future: croppedImage,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                    final croppedImage = snapshot.data;
                    return Image(image: Image.memory(ui.encodePng(croppedImage!.)).image);
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}