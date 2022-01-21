import 'dart:io';

import 'package:app_loja_virtual/components/image_source_sheet.dart';
import 'package:app_loja_virtual/models/section_item.dart';
import 'package:app_loja_virtual/models/section_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddTileWidget extends StatelessWidget {

  const AddTileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final sectionModel = context.watch<SectionModel>();

    void onImageSelected(File file){
      sectionModel.addItem(SectionItem(image: file, uidProduct: ''));
      Navigator.of(context).pop();
    }

    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: (){
          if(Platform.isAndroid){
            showModalBottomSheet(
              context: context,
              builder: (context) => ImageSourceSheet(onImageSelected: onImageSelected),
            );
          } else {
            showCupertinoModalPopup(
              context: context,
              builder: (context) => ImageSourceSheet(onImageSelected: onImageSelected),
            );
          }
        },
        child: Container(
          color: Colors.white.withAlpha(30),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
