import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File)? onImageSelected;

  const ImagePickerWidget({Key? key, this.onImageSelected}) : super(key: key);

  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _image != null
            ? Image.file(
          _image!,
          height: 150,
          width: 150,
          fit: BoxFit.cover,
        )
            : Container(
          height: 150,
          width: 150,
          color: Colors.grey[200],
          child: Icon(Icons.image, size: 50),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            _getImage();
          },
          child: Text(
            'Select Image',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final directory = Directory('${appDir.path}/product_images');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
      final imagePath = '${directory.path}/$fileName';

      final imageFile = File(pickedFile.path);
      await imageFile.copy(imagePath);

      setState(() {
        _image = File(imagePath);
        if (widget.onImageSelected != null) {
          widget.onImageSelected!(_image!);
        }
      });
    } else {
      print('No image selected.');
    }
  }
}
