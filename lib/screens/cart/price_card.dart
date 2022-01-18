import 'package:app_loja_virtual/managers/cart_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PriceCard extends StatelessWidget {

  final String buttomText;
  final VoidCallback onPressed;
  final bool isEnable;

  const PriceCard({
    required this.buttomText,
    required this.isEnable,
    required this.onPressed,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();

    final productsPrice = cartManager.produtsPrice;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Resumo do Pedido',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('SubTotal'),
                Text('R\$ ${productsPrice.toStringAsFixed(2)}'),
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                 'R\$ 19.99',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8,),
            ElevatedButton(
              onPressed: isEnable ? onPressed : null,
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
                onSurface: Theme.of(context).primaryColor.withAlpha(100),
                //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: const TextStyle(
                  //fontSize: 14,
                )
              ),
              child: Text(
                buttomText,
                style: const TextStyle(
                  color: Colors.white,
                ),
               ),
            )
          ],
        ),
      ),
    );
  }
}
