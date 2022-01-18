
import 'package:app_loja_virtual/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductManager extends ChangeNotifier{

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  static List<ProductModel> allProducts = [];

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
    return allProducts.firstWhere((p) => p.uid == productID);
  }

  static ProductModel findProductModel(String productID) {
    try{
      return allProducts.firstWhere((p) => p.uid == productID);
    }catch(e){
      var prod = ProductModel(uid: '', name: 'dummy', description: '', images: [], sizes: []);
      FirebaseFirestore.instance.doc('products/$productID').get().then((doc){
        prod =  ProductModel.fromDocument(doc);
      });
      return prod;
    }
  }

  void update(ProductModel product){
    allProducts.removeWhere((element) => element.uid == product.uid);
    allProducts.add(product);
    notifyListeners();
  }
}