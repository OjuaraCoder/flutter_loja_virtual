import 'package:app_loja_virtual/screens/home/add_tile_widget.dart';
import 'package:app_loja_virtual/managers/home_manager.dart';
import 'package:app_loja_virtual/screens/home/item_tile.dart';
import 'package:app_loja_virtual/models/section_model.dart';
import 'package:app_loja_virtual/screens/home/section_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SectionList extends StatelessWidget {

  final SectionModel sectionModel;

  const SectionList({required this.sectionModel, Key? key}) : super(key: key);

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
            SizedBox(
              height: 150,
              child: Consumer<SectionModel>(
                builder: (_, sectionModel, __){
                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (_,__) => const SizedBox(width: 10,),
                    itemCount: homeManager.editing
                        ? sectionModel.items.length + 1
                        : sectionModel.items.length,
                    itemBuilder: (_, index){
                      if(index < sectionModel.items.length){
                        return ItemTile(item: sectionModel.items[index]);
                      } else {
                        return const AddTileWidget();
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
