import 'package:app_loja_virtual/screens/home/item_tile.dart';
import 'package:app_loja_virtual/models/section_model.dart';
import 'package:app_loja_virtual/screens/home/section_header.dart';
import 'package:flutter/material.dart';

class SectionList extends StatelessWidget {

  final SectionModel section;

  const SectionList({required this.section, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(section: section),
          SizedBox(
            height: 150,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_,__) => const SizedBox(width: 6,),
              itemCount: section.items.length,
              itemBuilder: (_, index){
                return ItemTile(item: section.items[index]);

              },
            ),
          )
        ],
      ),
    );
  }
}
