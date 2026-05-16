import 'package:flutter/material.dart';
import 'package:project_shop/widgets/styles_widget/styles_widget.dart';

class QuantitySelectorWidget extends StatelessWidget {
  const QuantitySelectorWidget({
    super.key,
    required this.onAdd,
    required this.onRemove,
    this.onChanged,
    this.controller,
  });

  final VoidCallback onAdd, onRemove;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildQtyButton(
          icon: Icons.remove,
          onTap: onRemove,
        ),
        Container(
          width: 60,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            controller: controller ?? TextEditingController(),
            style: Styles.normalText(size: 14),
            onChanged: (value) {
              onChanged?.call(value);
            },
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
        _buildQtyButton(
          icon: Icons.add,
          onTap: onAdd,
        ),
      ],
    );
  }

  Widget _buildQtyButton(
      {required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }
}
