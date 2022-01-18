import 'package:app_loja_virtual/screens/home/item_tile.dart';
import 'package:app_loja_virtual/models/section_model.dart';
import 'package:app_loja_virtual/screens/home/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SectionStaggered extends StatelessWidget {

  final SectionModel section;

  const SectionStaggered({required this.section, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(section: section),
          GridView.custom(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverQuiltedGridDelegate(
                  crossAxisSpacing: 8,
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  repeatPattern: QuiltedGridRepeatPattern.inverted,
                  pattern: [
                    const QuiltedGridTile(2, 2),
                    const QuiltedGridTile(1, 1),
                    const QuiltedGridTile(1, 1),
                    //const QuiltedGridTile(2, 2),
                  ]
              ),
              childrenDelegate: SliverChildBuilderDelegate(
                  (context, index) => ItemTile(item: section.items[index]),
                childCount: section.items.length,
              ),
          ),
        ],
      ),
    );
  }
}
