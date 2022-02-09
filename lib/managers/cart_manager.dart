
import 'package:app_loja_virtual/helpers/logger.dart';
import 'package:app_loja_virtual/managers/user_manager.dart';
import 'package:app_loja_virtual/models/address_model.dart';
import 'package:app_loja_virtual/models/cart_model.dart';
import 'package:app_loja_virtual/models/product_model.dart';
import 'package:app_loja_virtual/models/user_model.dart';
import 'package:app_loja_virtual/services/cepaberto_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';


class CartManager extends ChangeNotifier {

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<CartModel> items = [];
  late UserModel userModel;
  AddressModel addressModel = AddressModel.clean();
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
    try {
      for (CartModel i in items) {
        if (i.productModel.uid.isEmpty) {
          FirebaseFirestore.instance.doc('products/${i.productID}').get().then((
              doc) {
            i.productModel = ProductModel.fromDocument(doc);
          });
        }
      }
    } catch (e){
      logger.e(e.toString());
    }
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
    if(cartModel.uid.isNotEmpty){
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

  void setAddress(AddressModel addressModel){
    this.addressModel = addressModel;
    calculateDelivery(addressModel.latitude, addressModel.longitude);
  }

  Future<void> getAddress(String cep) async {
    final cepAbertoService = CepAbertoService();
    try{
      final cepAbertoAddress = await cepAbertoService.getAddressFromCep(cep);
      if(cepAbertoAddress.cep.isNotEmpty){
        addressModel = AddressModel(
          street: cepAbertoAddress.logradouro,
          district: cepAbertoAddress.bairro,
          zipCode: cepAbertoAddress.cep,
          city: cepAbertoAddress.cidade.nome,
          state: cepAbertoAddress.estado.sigla,
          latitude: cepAbertoAddress.latitude,
          longitude: cepAbertoAddress.longitude,
          number: '',
          complement: '',
        );
        notifyListeners();
      }
    } catch (e){
      logger.e(e.toString());
    }
  }

  void setCleanAddress(){
    addressModel = AddressModel.clean();
    notifyListeners();
  }

  Future<void> calculateDelivery(double latitude, double longitude) async {
    // final DocumentSnapshot doc = await firestore.doc('aux/delivery').get();
    //
    // final latStore = doc['latitude'] as double;
    // final longStore = doc['longitude'] as double;
    // final maxkm = doc['maxkm'] as num;
    //
    // double dist = Geolocator.distanceBetween(latStore, longStore, latitude, longitude);
    //
    // dist /= 1000.0;
    // logger.d(dist.toString());
    // if(dist <= maxkm){
    //
    // }

  }

}

