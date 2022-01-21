import 'package:app_loja_virtual/components/custom_icon_buttom.dart';
import 'package:app_loja_virtual/models/cart_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartTile extends StatelessWidget {
  final CartModel cartModel;

  const CartTile(this.cartModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: cartModel,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              SizedBox(
                height: 80,
                width: 80,
                child: Image.network(cartModel.productModel.images.first),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartModel.productModel.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'Tamanho: ${cartModel.size}',
                          style: const TextStyle(fontWeight: FontWeight.w300),
                        ),
                      ),
                      Consumer<CartModel>(
                        builder: (_, cartM,__){
                          if(cartM.hashStock) {
                            return Text(
                              'R\$ ${cartModel.unitPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          } else {
                            return const Text(
                              'Sem estoque disponível',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Consumer<CartModel>(
                builder: (_, cartModel, __) {
                  return Column(
                    children: [
                      CurstomIconButton(
                        iconData: Icons.add,
                        color: Theme.of(context).primaryColor,
                        onTapButton: cartModel.increment,
                        isEnabled: true,
                      ),
                      Text(
                        '${cartModel.quantity}',
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      CurstomIconButton(
                        iconData: Icons.remove,
                        color: cartModel.quantity > 1 ? Theme.of(context).primaryColor : Colors.red,
                        onTapButton: cartModel.decrement,
                        isEnabled: true,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
