import 'package:app_loja_virtual/customdrawer/custom_drawer.dart';
import 'package:app_loja_virtual/managers/product_manager.dart';
import 'package:app_loja_virtual/managers/user_manager.dart';
import 'package:app_loja_virtual/models/product_model.dart';
import 'package:app_loja_virtual/screens/products/product_list_tile.dart';
import 'package:app_loja_virtual/screens/products/search_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(
        title: Consumer<ProductManager>(
          builder: (_, productManager, __){
            if(productManager.search.isEmpty){
              return const Text('Produtos');
            }else{
              return LayoutBuilder(
                builder: (_, constraints){
                  return GestureDetector(
                    onTap: () async {
                      final search = await showDialog<String>(
                        context: context,
                        builder: (_) => SearchDialog(productManager.search),
                      );
                      if (search != null) {
                        productManager.search = search;
                      }
                    },
                    child: SizedBox(
                      width: constraints.biggest.width,
                      child: Text(productManager.search,
                      textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        centerTitle: true,
        actions: [
          Consumer<ProductManager>(
            builder: (_, productManager, __){
              if(productManager.search.isEmpty) {
                return IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    final search = await showDialog<String>(
                      context: context,
                      builder: (_) => SearchDialog(productManager.search),
                    );
                    if (search != null) {
                      productManager.search = search;
                    }
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    productManager.search = '';
                  },
                );
              }
            },
          ),
          Consumer<UserManager>(
            builder: (_, userManaer,__){
              if(userManaer.adminEnabled){
                return IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: (){
                    Navigator.of(context).pushReplacementNamed(
                      '/edit_product',
                      arguments: ProductModel.cleanProduct(),
                    );
                  },
                );
              }else {
                return Container();
              }
            },
          )
        ],
      ),
      body: Consumer<ProductManager>(
        builder: (_, productManager, __) {
          final filtered = productManager.filteredProducts;
          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (_, index) {
              return ListTile(
                title: ProductListTile(filtered[index]),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).primaryColor,
        onPressed: (){
          Navigator.of(context).pushNamed('/cart');
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}
