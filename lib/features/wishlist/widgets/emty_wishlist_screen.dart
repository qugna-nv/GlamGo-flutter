import 'package:flutter/material.dart';
import 'package:project_shop/gen/assets.gen.dart';

class EmtyWishlistScreen extends StatelessWidget {
  const EmtyWishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Assets.images.wishlistEmpty.image(
                  width: MediaQuery.of(context).size.width * 0.65,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: Colors.redAccent,
                      ),
                    );
                  },
                ),
              ),
              const Text(
                'Oops! Danh sách yêu thích đang rỗng',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Lưu các sản phẩm mà bạn yêu thích để\ndễ dàng xem lại.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
