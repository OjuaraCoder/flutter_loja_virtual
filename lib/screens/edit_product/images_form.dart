import 'dart:io';

import 'package:app_loja_virtual/components/image_source_sheet.dart';
import 'package:app_loja_virtual/models/product_model.dart';
import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:flutter/material.dart';

class ImagesForm extends StatelessWidget {

  final ProductModel productModel;

  const ImagesForm({required this.productModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FormField<List<dynamic>>(
      initialValue: List.from(productModel.images),
      validator: (images){
        if(images == null || images.isEmpty){
          return 'Insira ao menos uma imagem';
        }
        return null;
      },
      onSaved: (images) => productModel.newImages = images,

      builder: (state){
        void onImageSelected(File file){
          state.value?.add(file);
          state.didChange(state.value);
          Navigator.of(context).pop();
        }

        return Column(
          children: [
            AspectRatio(
              aspectRatio: 1.2,
              child: Carousel(
                images: state.value!.map<Widget>((image){
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      if(image is String)
                        Image.network(image, fit: BoxFit.cover,)
                      else
                        Image.file(image as File, fit: BoxFit.cover,),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: (){
                            state.value!.remove(image);
                            state.didChange(state.value);
                          },
                        ),
                      ),
                    ],
                  );
                }).toList()..add(
                  Material(
                    color: Colors.grey[100],
                    child: IconButton(
                      icon: const Icon(Icons.add_a_photo),
                      color: Theme.of(context).primaryColor,
                      iconSize: 50,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) => ImageSourceSheet(
                            onImageSelected: onImageSelected,
                          )
                        );
                      }
                    ),
                  )
                ),
                dotSize: 4,
                dotSpacing: 15,
                dotBgColor: Colors.transparent,
                autoplay: false,
              ),
            ),
            if(state.hasError)
              Container(
                margin: const EdgeInsets.only(top: 8, left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
