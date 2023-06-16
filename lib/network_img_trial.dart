import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:math';



class CropImagePage extends StatefulWidget {
  @override
  _CropImagePageState createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  final Random random = Random();
  String croppedImageUrl = '';

  Future<ImageProvider> loadImage() async {
    // Load the image using the desired ImageProvider (e.g., NetworkImage, AssetImage)
    return NetworkImage('https://example.com/image.jpg');
  }

  Future<void> cropRandomArea(ImageProvider imageProvider) async {
    final image = await loadImageFromProvider(imageProvider);
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

    final croppedBytes = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
    setState(() {
      croppedImageUrl = 'data:image/png;base64,${base64Encode(croppedBytes!.buffer.asUint8List())}';
    });
  }

  Future<ui.Image> loadImageFromProvider(ImageProvider imageProvider) async {
    final Completer<ui.Image> completer = Completer();
    final ImageStream stream = imageProvider.resolve(ImageConfiguration.empty);
    stream.addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info.image);
    }));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop Image Example'),
      ),
      body: Center(
        child: FutureBuilder<ImageProvider>(
          future: loadImage(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              final imageProvider = snapshot.data;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => cropRandomArea(imageProvider!),
                    child: Text('Crop Image'),
                  ),
                  SizedBox(height: 20),
                  if (croppedImageUrl.isNotEmpty)
                    Image(
                      image: NetworkImage(croppedImageUrl),
                    ),
                ],
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