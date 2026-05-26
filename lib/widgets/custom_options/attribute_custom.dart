import 'package:flutter/material.dart';
import 'package:project_shop/widgets/themes/app_colors.dart';

class AttributeCustom extends StatelessWidget {
  final dynamic name;
  final dynamic value;
  final dynamic selectedAttribute;
  final void Function(dynamic) onTap;

  const AttributeCustom({
    super.key,
    required this.name,
    this.value,
    required this.selectedAttribute,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currentValue = value ?? name;
    final isSelected = currentValue == selectedAttribute;

    return GestureDetector(
        onTap: () => onTap(currentValue),
        child: Container(
          constraints: BoxConstraints(
            minWidth: 60,
            maxWidth: MediaQuery.of(context).size.width - 48,
          ),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: ColorName.grey53,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? ColorName.orange18 : ColorName.green17,
              width: 1,
            ),
          ),
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: isSelected ? ColorName.orange18 : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }
}
