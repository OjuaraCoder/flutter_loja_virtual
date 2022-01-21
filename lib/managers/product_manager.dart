
import 'package:app_loja_virtual/helpers/logger.dart';
import 'package:app_loja_virtual/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductManager extends ChangeNotifier{

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<ProductModel> allProducts = [];

  String _search = '';

  String get search => _search;

  set search(String value){
    _search = value;
    notifyListeners();
  }

  ProductManager(){
    _loadAllProducts();
  }

  List<ProductModel> get filteredProducts {
    final List<ProductModel> filteredProducts = [];
    if(search.isEmpty){
      filteredProducts.addAll(allProducts);
    }else{
      filteredProducts.addAll(allProducts.where((p) => p.name.toLowerCase().contains(search.toLowerCase())));
    }
    return filteredProducts;
  }

  Future<void> _loadAllProducts() async {
    final QuerySnapshot querySnapshot = await firestore.collection('products').get();
    allProducts = querySnapshot.docs.map((d) => ProductModel.fromDocument(d)).toList();
    notifyListeners();
  }

  ProductModel findProductByID(String productID) {
    return allProducts.firstWhere((p) => p.uid == productID, orElse: () => ProductModel.cleanProduct());
  }

  ProductModel findProductModel(String productID) {
    try{
      var model = findProductByID(productID);
      if(model.uid.isEmpty){
        FirebaseFirestore.instance.doc('products/$productID').get().then((doc){
          model =  ProductModel.fromDocument(doc);
        });
      }
      return model;
    }catch(e){
      logger.e(e.toString());
      return ProductModel.cleanProduct();
    }
  }

  void update(ProductModel product){
    allProducts.removeWhere((element) => element.uid == product.uid);
    allProducts.add(product);
    notifyListeners();
  }
}