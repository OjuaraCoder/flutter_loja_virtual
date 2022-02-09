import 'package:app_loja_virtual/screens/cart/price_card.dart';
import 'package:app_loja_virtual/managers/cart_manager.dart';
import 'package:app_loja_virtual/screens/cart/cart_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        centerTitle: true,
      ),
      body: Consumer<CartManager>(
        builder: (_, cartManager, __){
          return ListView(
            children: [
              Column(
              children: cartManager.items.map(
                  (cartModel) => CartTile(cartModel)
              ).toList(),
              ),
              PriceCard(
                buttomText: 'Continuar para Entrega',
                isEnable: cartManager.isCartValid,
                onPressed: () {
                  Navigator.of(context).pushNamed('/address');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
