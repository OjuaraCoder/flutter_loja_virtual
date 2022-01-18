import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {

  ImageSourceSheet({required this.onImageSelected, Key? key}) : super(key: key);

  final Function(File) onImageSelected;

  final ImagePicker picker = ImagePicker();

  void editImage(BuildContext context, String path) async {
    final File? croppedFile = await ImageCropper.cropImage(
      sourcePath: path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Editar Imagem',
        toolbarColor: Theme.of(context).primaryColor,
        toolbarWidgetColor: Colors.white,
      )
    );

    if(croppedFile != null){
      onImageSelected(croppedFile);
    }

  }


  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: (){},
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton(
              onPressed: () async {
                final file = await picker.pickImage(source: ImageSource.camera);
                editImage(context, file!.path);
              },
              child: const Text('Câmera'),
          ),
          TextButton(
            onPressed: () async {
              final file = await picker.pickImage(source: ImageSource.gallery);
              editImage(context, file!.path);
            },
            child: const Text('Galeria'),
          ),
        ],
      ),
    );
  }
}
