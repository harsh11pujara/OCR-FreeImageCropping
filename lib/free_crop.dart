import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ocr_image_cropping/pick_image.dart';
import 'package:ocr_image_cropping/show_croped_image.dart';

const String imageURL = 'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg';

///left top
double px1 = 80;
double py1 = PickImage.height/5 * 1;

double px2 = 80;
double py2 = PickImage.height/5 * 2;

double px3 = 80;
double py3 = PickImage.height/5 * 3;

///left bottom
double px4 = 80;
double py4 = PickImage.height/5 * 4;

///right bottom
double px5 = PickImage.width - 80;
double py5 = PickImage.height/5 * 4;

double px6 = PickImage.width - 80;
double py6 = PickImage.height/5 * 3;

double px7 = PickImage.width - 80;
double py7 = PickImage.height/5 * 2;

///right top
double px8 = PickImage.width - 80;
double py8 = PickImage.height/5 * 1;


class FreeCrop extends StatefulWidget {
  const FreeCrop({Key? key, required this.imageToCrop}) : super(key: key);
  final File imageToCrop;

  @override
  State<FreeCrop> createState() => _FreeCropState();
}

class _FreeCropState extends State<FreeCrop> {
  GlobalKey? cropperKey = GlobalKey();
  Uint8List? image;

  Future<Uint8List?> crop({
    required GlobalKey cropperKey,
    double pixelRatio = 3,
  }) async {
    // Get cropped image
    final renderObject = cropperKey.currentContext!.findRenderObject();
    final boundary = renderObject as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: pixelRatio);

    // Convert image to bytes in PNG format and return
    final byteData = await image.toByteData(
      format: ImageByteFormat.png,
    );
    final pngBytes = byteData?.buffer.asUint8List();
    return pngBytes;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        bottomOpacity: 0,
        actions: [
          ElevatedButton(
              onPressed: () async {
                image = await crop(cropperKey: cropperKey!);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowCroppedImage(image: image),
                    ));
              },
              child: const Text("save")),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(image: FileImage(widget.imageToCrop), opacity: 0.5, fit: BoxFit.fill)),
            child: RepaintBoundary(
              key: cropperKey,
              child: ClipPath(
                clipper: MyPainter(),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                     image: DecorationImage(image: FileImage(widget.imageToCrop), fit: BoxFit.fill)),
                ),
              ),
            ),
          ),

          cropPoint(x: px1, y: py1, point: 1),
          cropPoint(x: px2, y: py2, point: 2),
          cropPoint(x: px3, y: py3, point: 3),
          cropPoint(x: px4, y: py4, point: 4),
          cropPoint(x: px5, y: py5, point: 5),
          cropPoint(x: px6, y: py6, point: 6),
          cropPoint(x: px7, y: py7, point: 7),
          cropPoint(x: px8, y: py8, point: 8),
        ],
      ),
    );
  }

  Widget cropPoint({required double x, required double y, required int point}) {
    return Positioned(
      left: x - 10,
      top: y - 10,
      child: Draggable(
        feedback: const CircleAvatar(radius: 10, backgroundColor: Colors.black87),
        childWhenDragging: Container(),
        onDragEnd: (details) {
          setState(() {
            if (point == 1) {
              px1 = details.offset.dx;
              py1 = details.offset.dy-60;
            }

            if (point == 2) {
              px2 = details.offset.dx;
              py2 = details.offset.dy-60;
            }

            if (point == 3) {
              px3 = details.offset.dx;
              py3 = details.offset.dy-60;
            }

            if (point == 4) {
              px4 = details.offset.dx;
              py4 = details.offset.dy-60;
            }

            if (point == 5) {
              px5 = details.offset.dx;
              py5 = details.offset.dy-60;
            }

            if (point == 6) {
              px6 = details.offset.dx;
              py6 = details.offset.dy-60;
            }

            if (point == 7) {
              px7 = details.offset.dx;
              py7 = details.offset.dy-60;
            }

            if (point == 8) {
              px8 = details.offset.dx;
              py8 = details.offset.dy-60;
            }
          });
        },
        child: const CircleAvatar(radius: 10, backgroundColor: Colors.black87),
      ),
    );
  }
}

class MyPainter extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addPolygon([
      Offset(px1, py1),
      Offset(px2, py2),
      Offset(px3, py3),
      Offset(px4, py4),
      Offset(px5, py5),
      Offset(px6, py6),
      Offset(px7, py7),
      Offset(px8, py8)
    ], false);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
