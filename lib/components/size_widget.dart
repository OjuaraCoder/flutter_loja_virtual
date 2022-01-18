import 'package:app_loja_virtual/models/item_size_model.dart';
import 'package:app_loja_virtual/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SizeWidget extends StatelessWidget {

  final ItemSizeModel itemSizeModel;

  const SizeWidget(this.itemSizeModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final product = context.watch<ProductModel>();
    final selected = itemSizeModel == product.selectedSize;
    Color color;

    if(!itemSizeModel.hashStock){
      color = Colors.red.withAlpha(30);
    }else if(selected){
      color = Theme.of(context).primaryColor;
    }else{
      color = Colors.grey;
    }
    
    return GestureDetector(
      onTap: (){
        if(product.selectedSize == itemSizeModel){
          product.selectedSize = ItemSizeModel(name: '', price: 0.00, stock: 0);
          return;
        }
        if(itemSizeModel.hashStock){
          product.selectedSize = itemSizeModel;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: color,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(
                  itemSizeModel.name,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'R\$${itemSizeModel.price.toStringAsFixed(2)}',
                style: TextStyle(
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
