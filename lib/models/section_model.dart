import 'package:app_loja_virtual/models/section_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SectionModel {

  String name;
  String type;
  List<SectionItem> items;

  SectionModel({
    required this.name,
    required this.type,
    required this.items,
  });

  factory SectionModel.fromDocument(DocumentSnapshot document) {
    return SectionModel(
        name: document['name'] as String,
        type: document['type'] as String,
        items: (document['items'] as List).map((item) =>
            SectionItem.fromMap(item as Map<String, dynamic>)).toList(),
    );
  }

  @override
  String toString() {
    return 'SectionModel{name: $name, type: $type, items: $items}';
  }

  SectionModel clone() {
    return SectionModel(
      name: name,
      type: type,
      items: items.map((e) => e.clone()).toList()
    );
  }
}