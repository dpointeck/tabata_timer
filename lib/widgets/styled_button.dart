import 'package:flutter/material.dart';
import '../theme/palette.dart';

class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const StyledButton({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 40.0,
        width: 40.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Palette.yellow500,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              color: Palette.almostBlack,
            ),
          ),
        ),
      ),
    );
  }
}
