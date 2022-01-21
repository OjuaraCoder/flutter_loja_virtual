import 'package:app_loja_virtual/managers/home_manager.dart';
import 'package:app_loja_virtual/models/section_model.dart';
import 'package:flutter/material.dart';

class AddSectionWidget extends StatelessWidget {

  final HomeManager homeManager;

  const AddSectionWidget({required this.homeManager, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: (){
              homeManager.addSection(SectionModel(uid: '', name: '', type: 'List', items: []));
            },
            child: const Text(
              'Adicionar Lista',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ),
        Expanded(
            child: TextButton(
              onPressed: (){
                homeManager.addSection(SectionModel(uid: '', name: '', type: 'Staggered', items: []));
              },
              child: const Text(
                'Adicionar Grade',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
        ),
      ],
    );
  }
}
