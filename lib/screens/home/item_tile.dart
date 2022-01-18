import 'package:app_loja_virtual/managers/product_manager.dart';
import 'package:app_loja_virtual/models/section_item.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';

class ItemTile extends StatelessWidget {

  final SectionItem item;

  const ItemTile({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
         final product = context.read<ProductManager>().findProductByID(item.product);
         Navigator.of(context).pushNamed('/product', arguments: product);
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: FadeInImage.memoryNetwork(
            placeholder: kTransparentImage,
            image: item.image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
