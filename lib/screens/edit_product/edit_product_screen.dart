import 'package:app_loja_virtual/managers/product_manager.dart';
import 'package:app_loja_virtual/models/product_model.dart';
import 'package:app_loja_virtual/screens/edit_product/sizes_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'images_form.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(ProductModel model, {Key? key})
      : productModel = model.uid.isNotEmpty ? model.clone() : model,
        editing = model.uid.isNotEmpty,
        super(key: key);

  final ProductModel productModel;
  final bool editing;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return ChangeNotifierProvider.value(
      value: productModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Editar Produto' : 'Criar Produto'),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Form(
          key: formKey,
          child: ListView(
            children: [
              ImagesForm(productModel: productModel),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      initialValue: productModel.name,
                      decoration: const InputDecoration(
                        hintText: 'Titulo',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                      validator: (name) {
                        if (name == null || name.length < 6) {
                          return 'Título muito curto';
                        }
                        return null;
                      },
                      onChanged: (name) => productModel.name = name,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'A partir de',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                      ),
                    ),
                    Text(
                      'R\$ ...',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Descrição',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TextFormField(
                      initialValue: productModel.description,
                      decoration: const InputDecoration(
                        hintText: 'Descrição',
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                      validator: (desc) {
                        if (desc == null || desc.length < 10) {
                          return 'Descrição muito curta';
                        }
                        return null;
                      },
                      onChanged: (desc) => productModel.description = desc,
                    ),
                    SizesForm(
                      productModel: productModel,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Consumer<ProductModel>(
                      builder: (_, product, __) {
                        return ElevatedButton(
                          onPressed: !product.loading
                              ? () async {
                                  if (formKey.currentState!.validate()) {
                                    formKey.currentState?.save();
                                    await productModel.save();
                                    context.read<ProductManager>().update(product);
                                    Navigator.of(context).pop();
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            primary: primaryColor,
                            onSurface: primaryColor.withAlpha(100),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: product.loading
                              ? const CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text(
                                  'Salvar',
                                  style: TextStyle(fontSize: 18),
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
      ),
    );
  }
}
