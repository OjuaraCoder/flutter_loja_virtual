import 'package:app_loja_virtual/managers/cart_manager.dart';
import 'package:app_loja_virtual/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/src/provider.dart';

class AddressInputField extends StatelessWidget {

  final AddressModel addressModel;

  const AddressInputField({required this.addressModel, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final primaryColor = Theme.of(context).primaryColor;
    String? emptyValidador(String? text) => text == null ? 'Campo obrigatório' : null;

    if(addressModel.zipCode.isNotEmpty){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: addressModel.street,
            decoration: const InputDecoration(
              isDense: true,
              labelText: 'Rua/Avenida',
              hintText: 'Av. Brasil',
            ),
            validator: emptyValidador,
            onSaved: (t) => addressModel.street = t!,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: addressModel.number,
                  decoration: const InputDecoration(
                      isDense: true,
                      labelText: 'Número',
                      hintText: '123'
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  validator: emptyValidador,
                  onSaved: (t) => addressModel.number = t!,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  initialValue: addressModel.complement,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Complemento',
                    hintText: 'Opcional',
                  ),
                  onSaved: (t) => addressModel.complement = t!,
                ),
              ),
            ],
          ),
          TextFormField(
            initialValue: addressModel.district,
            decoration: const InputDecoration(
                isDense: true,
                labelText: 'Bairro',
                hintText: 'Guara'
            ),
            validator: emptyValidador,
            onSaved: (t) => addressModel.district = t!,
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  enabled: false,
                  initialValue: addressModel.city,
                  decoration: const InputDecoration(
                      isDense: true,
                      labelText: 'Cidade',
                      hintText: 'Lucio Costa'
                  ),
                  validator: emptyValidador,
                  onSaved: (t) => addressModel.city = t!,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: TextFormField(
                  enabled: false,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 2,
                  initialValue: addressModel.state,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'UF',
                    hintText: 'DF',
                    counterText: '',
                  ),
                  validator: emptyValidador,
                  onSaved: (t) => addressModel.state = t!,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 16,
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
                Form.of(context)?.save();
                context.read<CartManager>().setAddress(addressModel);
              }
            },
            child: const Text(
              'Calcular Frete',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }
    return Container();
  }
}
