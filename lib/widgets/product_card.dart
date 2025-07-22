import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../routes/route.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final double width;
  final double cardHeight;
  final double imageHeight;
  final double cardElevation;

  const ProductCard({
    super.key,
    required this.product,
    this.width = 340.0,
    this.cardHeight = 280.0,
    this.imageHeight = 100.0,
    this.cardElevation = 4.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    return InkWell(
      onTap: () => context.router.push(ProductDetailRoute(productId: product.id)),
      child: SizedBox(
        width: width,
        height: cardHeight,
        child: Card(
          elevation: cardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      product.image,
                      width: width,
                      height: imageHeight,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: IconButton(
                    icon: Icon(
                      favorites.contains(product.id) ? Icons.favorite : Icons.favorite_border,
                      color: favorites.contains(product.id) ? Colors.red : Colors.black54,
                      size: 24,
                    ),
                    onPressed: () => ref.read(favoritesProvider.notifier).toggleFavorite(product.id),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}