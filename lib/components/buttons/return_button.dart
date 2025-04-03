import 'package:flutter/material.dart';
import 'package:bid/components/buttons/shopping_buttons.dart';

class ReturnButton extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const ReturnButton({
    Key? key,
    required this.isSubmitting,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BaseStyledButton(
        text: "INITIATE RETURN",
        onTap: isSubmitting ? null : onSubmit,
        height: 50,
        fontSize: 16,
      ),
    );
  }
}

