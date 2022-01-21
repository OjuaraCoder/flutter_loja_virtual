import 'dart:io';

import 'package:app_loja_virtual/helpers/logger.dart';
import 'package:app_loja_virtual/models/section_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class SectionModel extends ChangeNotifier {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  DocumentReference get firestoreRef => firestore.doc('home/$uid');
  Reference get storageRef => storage.ref().child('home').child(uid);

  String uid;
  String name;
  String type;
  List<SectionItem> items;
  List<SectionItem> originalItems = [];

  String _error = '';
  String get error => _error;
  set error(String value){
    _error = value;
    notifyListeners();
  }

  SectionModel({
    required this.uid,
    required this.name,
    required this.type,
    required this.items
  }){
    originalItems = List.from(items);
  }

  factory SectionModel.fromDocument(DocumentSnapshot document) {
    return SectionModel(
        uid: document.id,
        name: document['name'] as String,
        type: document['type'] as String,
        items: (document['items'] as List).map((item) => SectionItem.fromMap(item as Map<String, dynamic>)).toList(),
    );
  }

  @override
  String toString() {
    return 'SectionModel{uid: $uid, name: $name, type: $type, items: $items}';
  }

  SectionModel clone() {
    return SectionModel(
      uid: uid,
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList()
    );
  }

  void addItem(SectionItem sectionItem) {
    items.add(sectionItem);
    notifyListeners();
  }

  void removeItem(SectionItem item) {
    items.remove(item);
    notifyListeners();
  }

  bool valid() {
    if(name.isEmpty){
      error ='Título inválido';
    }else if(items.isEmpty){
      error ='Insitra ao menos uma imagem';
    }else {
      error = '';
    }
    return error.isEmpty;
  }

  Future<void> save(int pos) async {

    final Map<String, dynamic> data ={
      'name': name,
      'type': type,
      'pos' : pos
    };

    if(uid.isEmpty){
      final doc = await firestore.collection('home').add(data);
      uid = doc.id;
    }else{
      await firestoreRef.update(data);
    }

    //atualizar imagens
    for(final item in items){
      if(item.image is File){
        final UploadTask task = storageRef.child(const Uuid().v1()).putFile(item.image as File);
        final TaskSnapshot snapshot = await task;
        final String url = await snapshot.ref.getDownloadURL();
        item.image = url;
      }
    }

    for(final original in originalItems){
      if(!items.contains(original)){
        try {
          final ref = storage.refFromURL(original.image);
          await ref.delete();
        } catch (e){
          logger.e('Error ao remover a imagem do firestorm');
        }
      }
    }

    final Map<String, dynamic> itemsData = {
      'items': items.map((e) => e.toMap()).toList()
    };

    await firestoreRef.update(itemsData);

  }

  Future<void> delete() async {
    await firestoreRef.delete();
    for(final item in items){
      try {
        final ref = storage.refFromURL(item.image as String);
        await ref.delete();
      } catch (e){
        logger.e('Error ao remover a imagem do firestorm');
      }
    }
  }
}