import 'package:flutter/material.dart';
import 'package:project_shop/data/response_models/products/product_attribute_model.dart';
import 'package:project_shop/widgets/custom_options/attribute_custom.dart';

class ItemDetail extends StatelessWidget {
  const ItemDetail(
      {super.key, required this.attribute, this.selected, this.onSelected});

  final ProductAttributeModel attribute;
  final dynamic selected;
  final ValueChanged<dynamic>? onSelected;

  @override
  Widget build(BuildContext context) {
    final attributeValues = attribute.attributeValue ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(attribute.name ?? 'N/A'),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: attributeValues.map((item) {
            return AttributeCustom(
              name: item.name ?? 'N/A',
              value: item.id,
              selectedAttribute: selected,
              onTap: (value) {
                onSelected?.call(value);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
