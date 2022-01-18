import 'package:app_loja_virtual/models/section_model.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {

  final SectionModel section;

  const SectionHeader({required this.section, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
