import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
class UploadImageWidget extends StatefulWidget {
  final Function callback;
  const UploadImageWidget({Key? key,required this.callback}) : super(key: key);

  @override
  State<UploadImageWidget> createState() => _UploadImageWidgetState();
}

class _UploadImageWidgetState extends State<UploadImageWidget> {
  File? _image;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey,
      onTap:showSelectImagePopupBox,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),

            border: Border.all(
                width: 1, color: Colors.black.withOpacity(0.4))),
        child:_image==null? const Text(
          'Click to upload photos',
          style: TextStyle(fontWeight: FontWeight.w500),
        ):Image.file(_image!,fit: BoxFit.contain,height: 160,),
      ),
    );
  }
  showSelectImagePopupBox() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              height: 120,
              child: Column(
                children: [
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      captureImage();
                    },
                    leading: const Icon(Icons.camera_alt_outlined),
                    title: Text(
                      'Capture Image',
                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      pickImage();
                    },
                    leading: const Icon(Icons.image_outlined),
                    title: Text(
                      'Pick Image',
                      style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery, maxWidth: 500, imageQuality: 20);
      if (image == null) return;
      final imageTemp = File(image.path);
      _image=imageTemp;
      widget.callback(_image);
      setState(() {

      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
  Future captureImage() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera, maxWidth: 500, imageQuality: 20);
      if (image == null) return;
      final imageTemp = File(image.path);
      _image =imageTemp;
      widget.callback(_image);
      setState(() {

      });
    } on PlatformException catch (e) {
      print('Failed to capture image: $e');
    }
  }
}

