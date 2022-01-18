
import 'package:app_loja_virtual/managers/user_manager.dart';
import 'package:app_loja_virtual/models/cart_model.dart';
import 'package:app_loja_virtual/models/product_model.dart';
import 'package:app_loja_virtual/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CartManager extends ChangeNotifier {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<CartModel> items = [];
  late UserModel userModel;
  num produtsPrice = 0.0;

  void updateUser(UserManager userManager) {
    userModel = userManager.usermodel;
    items.clear();

    if (userModel.uid != '') {
      _loadCartItems();
    }
  }

  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await userModel.cartReference.get();
    items = cartSnap.docs.map((e) => CartModel.fromDocument(e)..addListener(_onItemUpdate) ).toList();

  }

  void addToCart(ProductModel product){
    try{
      final e = items.firstWhere((p) => p.stackable(product));
      e.quantity++;
    }catch(e){
      final cartProduct = CartModel.fromProduct(product);
      cartProduct.addListener(_onItemUpdate);
      items.add(cartProduct);
      userModel.cartReference.add(cartProduct.toCartItemMap()).then((doc) => cartProduct.uid = doc.id);
      _onItemUpdate();
    }
  }

  void removeFromCart(CartModel cartModel){
    items.removeWhere((p) => p.uid == cartModel.uid);
    userModel.cartReference.doc(cartModel.uid).delete();
    cartModel.removeListener(_onItemUpdate);
    notifyListeners();
  }

  void _onItemUpdate(){

    produtsPrice = 0.0;

    for(int i = 0; i < items.length; i++){
      final cartProduct = items[i];

      if(cartProduct.quantity <= 0){
        removeFromCart(cartProduct);
        i--;
        continue;
      }
        produtsPrice += cartProduct.totalPrice;
        _updateCartProduct(cartProduct);
    }
    notifyListeners();
  }

  void _updateCartProduct(CartModel cartModel){
    if(cartModel.uid != ''){
      userModel.cartReference.doc(cartModel.uid).update(cartModel.toCartItemMap());
    }
  }

  bool get isCartValid {
    for(final cartModel in items){
      if(!cartModel.hashStock){
        return false;
      }
    }
    return true;
  }
}

