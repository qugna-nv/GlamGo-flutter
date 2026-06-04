import 'package:flutter/material.dart';
import 'package:project_shop/data/response_models/address/address_model.dart';

class AddressCardItem extends StatelessWidget {
  const AddressCardItem({
    super.key,
    required this.address,
    required this.onEdit,
    required this.onSetDefault,
    required this.onDelete,
    this.isAddressDefault = true,
  });

  final AddressModel address;
  final VoidCallback onEdit;
  final VoidCallback onSetDefault;
  final VoidCallback onDelete;
  final bool isAddressDefault;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onSetDefault,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: InkWell(
                      onTap: onSetDefault,
                      child: Icon(
                        address.isDefault
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        color: Theme.of(context).primaryColor,
                      )),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            address.recipientName ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(address.phone ?? ''),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        address.label?.isNotEmpty == true
                            ? address.label!
                            : 'Địa chỉ',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(address.addressLine ?? ''),
                      if (address.isDefault) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Mặc định',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                isAddressDefault
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (value) {
                            if (value == 'edit') {
                              onEdit();
                            } else if (value == 'delete' &&
                                !address.isDefault) {
                              onDelete();
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Sửa'),
                            ),
                            if (!address.isDefault)
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text('Xoá'),
                              ),
                          ],
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
