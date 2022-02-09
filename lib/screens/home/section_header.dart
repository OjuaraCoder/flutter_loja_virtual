import 'package:app_loja_virtual/components/custom_icon_buttom.dart';
import 'package:app_loja_virtual/managers/home_manager.dart';
import 'package:app_loja_virtual/models/section_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeManager = context.watch<HomeManager>();
    final section = context.watch<SectionModel>();

    if(homeManager.editing){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: section.name,
                  decoration: const InputDecoration(
                    hintText: 'Titulo',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                  onChanged: (text) => section.name = text,
                ),
              ),
              CustomIconButton(
                iconData: Icons.delete,
                color: Colors.white,
                isEnabled: true,
                onTapButton: (){
                  homeManager.removeSection(section);
                },
                size: 24,
              ),
            ],
          ),
          if(section.error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                section.error,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
        ],
      );

    }else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          section.name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
      );

    }


  }
}
