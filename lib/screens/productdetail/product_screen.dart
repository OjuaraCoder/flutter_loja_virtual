import 'package:app_loja_virtual/components/carousel_component.dart';
import 'package:app_loja_virtual/components/size_widget.dart';
import 'package:app_loja_virtual/managers/cart_manager.dart';
import 'package:app_loja_virtual/managers/user_manager.dart';
import 'package:app_loja_virtual/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {

  final ProductModel productModel;

  const ProductScreen(this.productModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: productModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text(productModel.name),
          centerTitle: true,
          actions: [
            Consumer<UserManager>(
                builder: (_, userManaer,__){
                  if(userManaer.adminEnabled){
                    return IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: (){
                        Navigator.of(context).pushReplacementNamed(
                          '/edit_product',
                          arguments: productModel,
                        );
                      },
                    );
                  }else {
                    return Container();
                  }
                },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            CarouselComponent(listImages: productModel.images,),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    productModel.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'A partir de:',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Text(
                    'R\$ ${productModel.basePrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Descrição:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Text(
                    productModel.description,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 8),
                    child: Text(
                      'Tamanhos:',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: productModel.sizes.map((s){
                      return SizeWidget(s);
                    },
                    ).toList(),
                  ),
                  const SizedBox(height: 20,),
                  if(productModel.hasStock)
                    Consumer2<UserManager, ProductModel>(
                        builder: (_, userManager, product,__){
                          return SizedBox(
                            height: 44,
                            child: ElevatedButton(
                              onPressed: productModel.selectedSize.name != '' ? (){
                                if(userManager.isLoggedIn){
                                  context.read<CartManager>().addToCart(product);
                                  Navigator.of(context).pushNamed('/cart');
                                }else{
                                  Navigator.of(context).pushNamed('/login');
                                }
                              } : null,
                              style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                  onSurface: Theme.of(context).primaryColor.withAlpha(100),
                                  //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                  textStyle: const TextStyle(
                                    //fontSize: 14,
                                  )
                              ),
                              child: Text(
                                userManager.isLoggedIn
                                    ? 'Adicionar ao Carrinho'
                                    : 'Entre para Comprar',
                                style: const TextStyle(
                                    fontSize: 16
                                ),
                              ),
                            ),
                          );
                        },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
