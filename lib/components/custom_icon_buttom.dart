import 'package:flutter/material.dart';

class CurstomIconButton extends StatelessWidget {

  final IconData iconData;
  final Color color;
  final VoidCallback onTapButton;
  final bool isEnabled;

  const CurstomIconButton({Key? key, required this.iconData, required this.color, required this.onTapButton, required this.isEnabled,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onTapButton : null,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              iconData,
              color: isEnabled ? color : Colors.grey[400],
            ),
          ),
        ),
      ),
    );
  }
}
