import 'package:app_loja_virtual/models/section_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeManager extends ChangeNotifier{

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<SectionModel> _sections = [];
  List<SectionModel> _editingSections = [];

  bool editing = false;

  HomeManager(){
    _loadSections();
  }

  Future<void> _loadSections() async {
    firestore.collection('home').snapshots().listen((snapshot) {
      _sections.clear();
      for(final DocumentSnapshot document in snapshot.docs){
        _sections.add(SectionModel.fromDocument(document));
      }
      notifyListeners();
    });
  }

  List<SectionModel> get sections{
    if(editing){
      return _editingSections;
    }else {
      return _sections;
    }
  }

  void enterEditing(){
    editing = true;
    _editingSections = sections.map((s) => s.clone()).toList();
    notifyListeners();
  }

  void saveEditing() {
    editing = false;
    notifyListeners();

  }

  void discardEditing() {
    editing = false;
    notifyListeners();

  }

}