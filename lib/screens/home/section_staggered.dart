import 'package:app_loja_virtual/managers/home_manager.dart';
import 'package:app_loja_virtual/models/section_model.dart';
import 'package:app_loja_virtual/screens/home/add_tile_widget.dart';
import 'package:app_loja_virtual/screens/home/item_tile.dart';
import 'package:app_loja_virtual/screens/home/section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class SectionStaggered extends StatelessWidget {
  final SectionModel sectionModel;

  const SectionStaggered({required this.sectionModel, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();

    return ChangeNotifierProvider.value(
      value: sectionModel,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(),
            Consumer<SectionModel>(
              builder: (_, sectionModel, __) {
                return StaggeredGridView.countBuilder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: homeManager.editing
                      ? sectionModel.items.length + 1
                      : sectionModel.items.length,
                  itemBuilder: (_, index) {
                    if (index < sectionModel.items.length) {
                      return ItemTile(item: sectionModel.items[index]);
                    } else {
                      return const AddTileWidget();
                    }
                  },
                  staggeredTileBuilder: (index) => StaggeredTile.count(2, index.isEven ? 2 : 1),

                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
