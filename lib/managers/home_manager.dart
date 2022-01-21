import 'package:app_loja_virtual/models/section_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeManager extends ChangeNotifier{

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List<SectionModel> _sections = [];
  List<SectionModel> _editingSections = [];

  bool editing = false;
  bool loading = false;

  HomeManager(){
    _loadSections();
  }

  Future<void> _loadSections() async {
    firestore.collection('home').orderBy('pos').snapshots().listen((snapshot) {
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

  void addSection(SectionModel section){
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(SectionModel section){
    _editingSections.remove(section);
    notifyListeners();
  }

  void enterEditing(){
    editing = true;
    _editingSections = _sections.map((s) => s.clone()).toList();
    notifyListeners();
  }

  void saveEditing() async {
    bool valid = true;
    for(final section in _editingSections){
      if(!section.valid()){
        valid = false;
      }
    }
    if(!valid) return;

    loading = true;
    notifyListeners();

    int pos = 0;
    for(final section in _editingSections){
      await section.save(pos);
      pos++;
    }

    for(final section in List.from(_sections)){
      if(!_editingSections.any((element) => element.uid == section.uid)){
        await section.delete();
      }
    }

    loading = false;
    editing = false;
    notifyListeners();
  }

  void discardEditing() {
    editing = false;
    notifyListeners();
  }

}