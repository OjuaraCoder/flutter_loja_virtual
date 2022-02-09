import 'dart:io';

import 'package:app_loja_virtual/helpers/logger.dart';
import 'package:app_loja_virtual/models/item_size_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class ProductModel  extends ChangeNotifier{

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.doc('products/$uid');
  Reference get storageRef => storage.ref().child('products').child(uid);

  String uid;
  String name;
  String description;
  List<String> images;
  List<ItemSizeModel> sizes;
  List<dynamic>? newImages;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value){
    _loading = value;
    notifyListeners();
  }

  ItemSizeModel _selectedSize = ItemSizeModel(name: '', price: 0.00, stock: 0);

  ProductModel({
    required this.uid,
    required this.name,
    required this.description,
    required this.images,
    required this.sizes
  });

  factory ProductModel.fromDocument(DocumentSnapshot document) {
    return ProductModel (
      uid: document.id,
      name: document['name'] as String,
      description: document['description'] as String,
      images: List<String>.from(document['images'] as List<dynamic>),
      sizes: (document['sizes'] as List<dynamic>).map((s) => ItemSizeModel.fromMap(s as Map<String,dynamic>)).toList(),
    );
  }

  factory ProductModel.cleanProduct() {
    return ProductModel(uid: '', name: '', description: '', images: [], sizes: []);
  }

  ProductModel clone(){
    return ProductModel(
      uid: uid,
      name: name,
      description: description,
      images: List.from(images),
      sizes: sizes.map((e) => e.clone()).toList());
  }

  ItemSizeModel get selectedSize => _selectedSize;
  set selectedSize(ItemSizeModel value){
    _selectedSize = value;
    notifyListeners();
  }

  int get totalStock{
    int stock = 0;
    for(final size in sizes){
      stock += size.stock;
    }
    return stock;
  }

  bool get hasStock {
    return totalStock > 0;
  }

  num get basePrice {
    num lowest = double.infinity;
    for(final size in sizes){
      if(size.price < lowest && size.hashStock){
        lowest = size.price;
      }
    }
    return lowest;
  }

  ItemSizeModel findSize(String value){
    try {
      return sizes.firstWhere((s) => s.name == value);
    } catch (e) {
      return ItemSizeModel(name: '', price: 0.00, stock: 0);
    }
  }

  List<Map<String, dynamic>> exportSizeList(){
    return sizes.map((size) => size.toMap()).toList();
  }

  Future<void> save() async {

    loading = true;

    final Map<String, dynamic> data ={
      'name': name,
      'description': description,
      'sizes': exportSizeList(),
    };

    if(uid.isEmpty){
      final doc = await firestore.collection('products').add(data);
      uid = doc.id;
    }else{
      await firestoreRef.update(data);
    }

    //atualizar imagens
    final List<String> updateImages = [];
    for(final newImage in newImages!){
      if(images.contains(newImage)){
        updateImages.add(newImage as String);
      }else{
        final UploadTask task = storageRef.child(const Uuid().v1()).putFile(newImage as File);
        final TaskSnapshot snapshot = await task;
        final String url = await snapshot.ref.getDownloadURL();
        updateImages.add(url);
      }
    }

    for(final image in images){
      if(!newImages!.contains(image) && image.contains('firebase')){
        try {
          final ref = storage.refFromURL(image);
          await ref.delete();
        } catch (e){
          logger.e('Error ao remover a imagem: $image');
        }
      }
    }

    await firestoreRef.update({'images': updateImages});
    images = updateImages;
    loading = false;
  }
}