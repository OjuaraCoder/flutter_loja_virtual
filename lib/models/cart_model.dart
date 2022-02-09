import 'package:app_loja_virtual/models/item_size_model.dart';
import 'package:app_loja_virtual/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CartModel extends ChangeNotifier{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  ProductModel productModel;
  String uid;
  String productID;
  int quantity;
  String size;

  CartModel({
    required this.productModel,
    required this.uid,
    required this.productID,
    required this.quantity,
    required this.size
  });

  CartModel.fromProduct(product)
    : productModel = product
    , uid = ''
    , productID = product.uid
    , quantity = 0
    , size = product.selectedSize.name {
    increment();
  }

  CartModel.fromDocument(DocumentSnapshot document)
    : uid = document.id
    , productID = document['pid']
    , productModel = ProductModel.cleanProduct()
    , quantity = document['quantity'] as int
    , size = document['size'] as String;


  ProductModel getProductID(String productID){
    var product = ProductModel.cleanProduct();
    firestore.doc('products/$productID').get().then((doc){
        productModel = ProductModel.fromDocument(doc);
      });
    return product;
  }

  ItemSizeModel get itemSize{
    if(productModel.uid.isEmpty) {
      return ItemSizeModel(stock: 0, name: '', price: 0.00);
    }
      return productModel.findSize(size);
  }

  num get unitPrice {
    return itemSize.price;
  }

  num get totalPrice => unitPrice * quantity;

  Map<String, dynamic> toCartItemMap(){
    return {
      'pid': productID,
      'quantity': quantity,
      'size': size,
    };
  }

  bool stackable(ProductModel productModel){
    return productModel.uid == productID && productModel.selectedSize.name == size;
  }

  void increment(){
    quantity++;
    notifyListeners();
  }

  void decrement(){
    quantity--;
    if(quantity < 0 ){
      quantity = 0;
    }
    notifyListeners();
  }

  bool get hashStock{
    final size = itemSize;
    if(!size.hashStock){
      return false;
    }
    return size.stock >= quantity;
  }

}