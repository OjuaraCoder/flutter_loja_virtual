import 'package:app_loja_virtual/components/custom_icon_buttom.dart';
import 'package:app_loja_virtual/models/item_size_model.dart';
import 'package:flutter/material.dart';

class EditItemSize extends StatelessWidget {
  const EditItemSize({
    required this.itemSizeModel,
    required this.onRemove,
    required this.onMoveUp,
    required this.isMoveUpEnabled,
    required this.onMoveDown,
    required this.isMoveDownEnabled,
    Key? key}
  ) : super(key: key);

  final ItemSizeModel itemSizeModel;
  final VoidCallback onRemove;
  final VoidCallback onMoveUp;
  final bool isMoveUpEnabled;
  final VoidCallback onMoveDown;
  final bool isMoveDownEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: itemSizeModel.name,
            decoration: const InputDecoration(
              labelText: 'Tamanho',
              isDense: true,
            ),
            validator: (name){
              if(name == null || name.isEmpty){
                return 'Invalido';
              }
              return null;
            },
            onChanged: (name) => itemSizeModel.name = name,
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 30,
          child: TextFormField(
            initialValue: itemSizeModel.stock.toString(),
            decoration: const InputDecoration(
              labelText: 'Estoque',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            validator: (stock){
              if(stock == null || int.tryParse(stock) == null){
                return 'Invalido';
              }
              return null;
            },
            onChanged: (stock){
              if(stock.isEmpty){
                stock = '0';
              }
              itemSizeModel.stock = int.tryParse(stock)!;
            }
          ),
        ),
        const SizedBox(width: 4,),
        Expanded(
          flex: 40,
          child: TextFormField(
            initialValue: itemSizeModel.price.toStringAsFixed(2),
            decoration: const InputDecoration(
              labelText: 'Preço',
              prefixText: 'R\$',
              isDense: true,
            ),
            keyboardType: TextInputType.number,
            validator: (price){
              if(price == null || double.tryParse(price) == null){
                return 'Invalido';
              }
              return null;
            },
            onChanged: (price){
              if(price.isEmpty){
                price = '0.00';
              }
              itemSizeModel.price = double.tryParse(price)!;
            }
          ),
        ),
        const SizedBox(width: 4,),

        CurstomIconButton(
          iconData: Icons.arrow_drop_up,
          color: Colors.black,
          onTapButton: onMoveUp,
          isEnabled: isMoveUpEnabled,
        ),
        const SizedBox(width: 4,),
        CurstomIconButton(
          iconData: Icons.arrow_drop_down,
          color: Colors.black,
          onTapButton: onMoveDown,
          isEnabled: isMoveDownEnabled,
        ),
        const SizedBox(width: 4,),
        CurstomIconButton(
          iconData: Icons.delete,
          color: Colors.red,
          onTapButton: onRemove,
          isEnabled: true,
        ),
      ],
    );
  }
}
