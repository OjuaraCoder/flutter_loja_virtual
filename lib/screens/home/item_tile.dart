import 'dart:io';
import 'package:app_loja_virtual/managers/home_manager.dart';
import 'package:app_loja_virtual/managers/product_manager.dart';
import 'package:app_loja_virtual/models/product_model.dart';
import 'package:app_loja_virtual/models/section_item.dart';
import 'package:app_loja_virtual/models/section_model.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';

class ItemTile extends StatelessWidget {
  final SectionItem item;

  const ItemTile({required this.item, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return GestureDetector(
      onTap: () {
        final product = context.read<ProductManager>().findProductByID(item.uidProduct);
        if(product.uid != ''){
          Navigator.of(context).pushNamed('/product', arguments: product);
        }
      },
      onLongPress: homeManager.editing
          ? () {
              final product = context
                  .read<ProductManager>()
                  .findProductByID(item.uidProduct);
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text('Editar Item'),
                      content: product.uid.isNotEmpty
                          ? ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Image.network(product.images.first),
                              title: Text(product.name),
                              subtitle: Text(
                                  'R\$ ${product.basePrice.toStringAsFixed(2)}'),
                            )
                          : null,
                      actions: [
                        TextButton(
                          onPressed: () {
                            context.read<SectionModel>().removeItem(item);
                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            'Excluir',
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            if(product.uid.isNotEmpty){
                              item.uidProduct = '';
                            }else{
                              var product = await Navigator.of(context).pushNamed('/select_product') as ProductModel?;
                              if(product != null){
                                item.uidProduct = product.uid;
                              }
                            }
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            product.uid.isNotEmpty
                                 ? 'Desvincular'
                                 : 'Vincular',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    );
                  });
            }
          : null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: item.image is String
              ? FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: item.image as String,
                  fit: BoxFit.cover)
              : Image.file(
                  item.image as File,
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
