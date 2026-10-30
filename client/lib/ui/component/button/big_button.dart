import 'package:flutter/material.dart';

enum _Type { filled, outlined }

class BigButton extends StatelessWidget {
  final _Type _type;
  final String label;
  final VoidCallback? onPressed;

  const BigButton._({
    required this._type,
    required this.label,
    required this.onPressed,
  });

  factory BigButton.filled({required String label, VoidCallback? onPressed}) {
    return BigButton._(type: _Type.filled, label: label, onPressed: onPressed);
  }

  factory BigButton.outlined({required String label, VoidCallback? onPressed}) {
    return BigButton._(
      type: _Type.outlined,
      label: label,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 325,
    height: 54,
    child: switch (_type) {
      _Type.filled => FilledButton(onPressed: onPressed, child: Text(label)),
      _Type.outlined => OutlinedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    },
  );
}
