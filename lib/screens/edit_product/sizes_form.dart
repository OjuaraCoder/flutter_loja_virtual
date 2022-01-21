import 'package:app_loja_virtual/components/custom_icon_buttom.dart';
import 'package:app_loja_virtual/models/item_size_model.dart';
import 'package:app_loja_virtual/models/product_model.dart';
import 'package:flutter/material.dart';

import 'edit_item_size.dart';

class SizesForm extends StatelessWidget {

  const SizesForm({required this.productModel, Key? key}) : super(key: key);

  final ProductModel productModel;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSizeModel>>(
      initialValue: productModel.sizes,
      validator: (sizes){
        if(sizes == null || sizes.isEmpty){
          return 'Insira um tamanho';
        }
        return null;
      },
      builder:(state){
        return Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Tamanhos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                CurstomIconButton(
                  iconData: Icons.add,
                  color: Colors.black,
                  isEnabled: true,
                  onTapButton: (){
                    state.value!.add(ItemSizeModel(name: '', price: 0.00, stock: 0));
                    state.didChange(state.value);
                  },
                ),
              ],
            ),
            Column(
              children: state.value!.map((size){
                return EditItemSize(
                  key: ObjectKey(size),
                  itemSizeModel: size,
                  onRemove: () {
                    state.value?.remove(size);
                    state.didChange(state.value);
                  },
                  isMoveUpEnabled: size != state.value?.first,
                  onMoveUp: () {
                    final index = state.value?.indexOf(size);
                    state.value?.remove(size);
                    state.value?.insert(index!-1, size);
                    state.didChange(state.value);
                  },
                  isMoveDownEnabled: size != state.value?.last,
                  onMoveDown: () {
                    final index = state.value?.indexOf(size);
                    state.value?.remove(size);
                    state.value?.insert(index!+1, size);
                    state.didChange(state.value);
                  },


                );
              }).toList(),
            ),
            if(state.hasError)
              Container(
                margin: const EdgeInsets.only(top: 8, left: 16),
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
