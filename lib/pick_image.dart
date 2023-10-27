import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ocr_image_cropping/free_crop.dart';

class PickImage extends StatefulWidget {
  PickImage({Key? key}) : super(key: key);
  static double height = 0.0;
  static double width = 0.0;

  static changeSize(double h, double w){
    height = h;
    width = w;
  }


  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  @override
  Widget build(BuildContext context) {
   PickImage.changeSize(MediaQuery.of(context).size.height, MediaQuery.of(context).size.width);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick image for cropping"),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(onPressed: () {
              ImagePicker().pickImage(source: ImageSource.gallery).then((value) {
                if(value != null){
                  File image = File(value.path);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FreeCrop(imageToCrop: image),));
                }
              });
            }, child: const Text("Pick Image from Gallery")),
            ElevatedButton(onPressed: () {
              ImagePicker().pickImage(source: ImageSource.camera).then((value) {
                if(value != null){
                  File image = File(value.path);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FreeCrop(imageToCrop: image),));
                }
              });
            }, child: const Text("Capture image from Camera"))
          ],
        ),
      ),
    );
  }
}
