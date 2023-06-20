import 'dart:typed_data';

import 'package:flutter/material.dart';

class ShowCroppedImage extends StatelessWidget {
  final Uint8List? image;
  const ShowCroppedImage({Key? key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: image != null ? Image.memory(image!) : Text("NO Image")),
    );
  }
}
