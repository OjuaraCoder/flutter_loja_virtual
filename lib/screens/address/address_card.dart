import 'package:app_loja_virtual/managers/cart_manager.dart';
import 'package:app_loja_virtual/screens/address/cep_input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'address_input_field.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Consumer<CartManager>(
          builder: (_, cartManager, __){
            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Endereço de Entrega',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  CepInputFiel(addressModel: cartManager.addressModel),
                  AddressInputField(addressModel: cartManager.addressModel,),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
