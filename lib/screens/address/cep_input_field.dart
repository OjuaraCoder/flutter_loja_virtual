import 'package:app_loja_virtual/components/custom_icon_buttom.dart';
import 'package:app_loja_virtual/managers/cart_manager.dart';
import 'package:app_loja_virtual/models/address_model.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/src/provider.dart';

class CepInputFiel extends StatelessWidget {

  final AddressModel addressModel;
  final TextEditingController cepController = TextEditingController();

  CepInputFiel({required this.addressModel, Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).primaryColor;

    if(addressModel.zipCode.isEmpty){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: cepController,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'CEP',
              hintText: '70.000-000',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CepInputFormatter(),
            ],
            validator:(cep){
              if(cep!.isEmpty){
                return 'Campo obrigatório';
              }else if(cep.length != 10){
                return 'Cep inválido';
              }
              return null;
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: primaryColor,
                onSurface: primaryColor.withAlpha(100),
                //padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                textStyle: const TextStyle(
                  //fontSize: 14,
                )
            ),
            onPressed: () {
              if(Form.of(context)!.validate()){
                context.read<CartManager>().getAddress(cepController.text);
              }
            },
            child: const Text(
              'Buscar CEP',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }else{
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'CEP: ${addressModel.zipCode.substring(0,2) + '.'
                      + addressModel.zipCode.substring(2,5) + '-'
                      + addressModel.zipCode.substring(5,8)}',
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CustomIconButton(
              color: primaryColor,
              isEnabled: true,
              iconData: Icons.edit,
              size: 20,
              onTapButton: () {
                context.read<CartManager>().setCleanAddress();
              },
            ),
          ],
        ),
      );
    }

  }
}
